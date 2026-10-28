--!strict
-- Monta a pista à frente do jogador a partir do gerador por seed, reaproveitando peças (pooling).
-- Cada chunk recebe o tema do seu capítulo: piso, faixas, bordas, chão lateral, cenário e obstáculos.
-- Também responde às perguntas de jogo: onde há chão e quais objetos estão perto.
-- O cenário de cada chunk entra numa fila e é montado aos poucos (alguns milissegundos por frame):
-- montar um chunk inteiro de uma vez travava o jogo a cada 60 studs.
-- Peças e props ficam em pools do jogo todo (sobrevivem às corridas): nada é recriado ao jogar de novo.

local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Abilities = require(Shared.Config.Abilities)
local Themes = require(Shared.Config.Themes)
local ChunkGeometry = require(Shared.ChunkGeometry)
local TrackGenerator = require(Shared.TrackGenerator)
local Types = require(Shared.Types)

local Pool = require(script.Parent.Pool)
local PropPool = require(script.Parent.PropPool)
local TrackSpace = require(script.Parent.TrackSpace)
local Visuals = require(script.Parent.Visuals)

local TrackConfig = GameConfig.Track
local Obstacles = GameConfig.Obstacles
local Scenery = GameConfig.Scenery
local CHUNK = TrackConfig.ChunkLength
local LANES = TrackConfig.LaneCount
local TRACK_WIDTH = TrackConfig.LaneWidth * LANES
local EDGE = TRACK_WIDTH / 2 + TrackConfig.RailWidth
local SMOOTH = Enum.Material.SmoothPlastic
local BLAST_PARTICLES = 40
local SCENERY_BUDGET = 0.002 -- segundos por frame para montar cenário da fila
local PREWARM_SLACK = 1.3 -- cópias extras de cada prop no pré-carregamento
-- Celular e tablet: menos cenário e menos chunks à frente (Scenery.Mobile)
local LOW_DETAIL = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local DENSITY = if LOW_DETAIL then Scenery.Mobile.Density else 1
local CHUNKS_AHEAD = if LOW_DETAIL then Scenery.Mobile.ChunksAhead else TrackConfig.ChunksAhead

export type Obstacle = {
	kind: Types.ObjectKind,
	lane: number,
	x: number,
	z0: number,
	z1: number,
	bottom: number,
	top: number,
	disabled: boolean,
	props: { PropPool.PropInstance }, -- visual do obstáculo (some quando é destruído)
}

export type Coin = {
	part: BasePart,
	position: Vector3, -- coordenadas da pista
	collected: boolean,
	attracted: boolean,
}

export type Pickup = {
	kind: "PowerUp" | "Trampoline",
	powerUpId: string?,
	lane: number,
	x: number,
	z0: number,
	z1: number,
	part: BasePart,
	used: boolean,
}

export type BuiltChunk = {
	index: number,
	slot: Types.ChunkSlot,
	parts: { { pool: Pool.Pool, part: BasePart } },
	props: { PropPool.PropInstance },
	obstacles: { Obstacle },
	coins: { Coin },
	pickups: { Pickup },
	released: boolean,
}

-- Prop de cenário esperando para ser montado
type PendingProp = {
	built: BuiltChunk,
	name: string,
	center: Vector3,
	size: Vector3,
}

type Pools = {
	solid: Pool.Pool,
	flat: Pool.Pool,
	coin: Pool.Pool,
	powerUp: Pool.Pool,
}

type TrackData = {
	generator: TrackGenerator.TrackGenerator,
	folder: Folder,
	pools: Pools,
	props: PropPool.PropPool,
	built: { [number]: BuiltChunk },
	nearby: { BuiltChunk },
	pending: { PendingProp },
	pendingHead: number,
}

local Track = {}
Track.__index = Track

-- Contadores do frame (lidos e zerados pelo medidor de travadas do Main)
Track.stats = { chunks = 0, props = 0 }

export type Track = typeof(setmetatable({} :: TrackData, Track))

local function pickWeighted(rng: Random, entries: { Themes.PropEntry }): Themes.PropEntry
	local total = 0
	for _, entry in entries do
		total += entry.weight
	end
	local roll = rng:NextNumber() * total
	for _, entry in entries do
		if roll < entry.weight then
			return entry
		end
		roll -= entry.weight
	end
	return entries[#entries]
end

local sharedPools: Pools? = nil

-- Pools de peças do jogo todo, numa pasta fora da corrida
local function pools(): Pools
	if sharedPools then
		return sharedPools
	end
	local folder = Instance.new("Folder")
	folder.Name = "TrackCache"
	folder.Parent = Workspace
	local created: Pools = {
		solid = Pool.new(folder, Visuals.block),
		flat = Pool.new(folder, Visuals.flat),
		coin = Pool.new(folder, Visuals.coin),
		powerUp = Pool.new(folder, Visuals.powerUp),
	}
	sharedPools = created
	return created
end

local function propsPerSide(theme: Themes.Theme): number
	return math.max(1, math.floor(theme.propsPerSide * DENSITY + 0.5))
end

local function decorSpacing(theme: Themes.Theme): number
	return theme.decorSpacing / DENSITY
end

-- Pré-carrega no fundo os props de todas as fases, na quantidade que cabe nos chunks montados ao mesmo tempo
function Track.prewarm()
	local alive = CHUNKS_AHEAD + TrackConfig.ChunksBehind + 1
	local counts: { [string]: number } = {}
	local sizes: { [string]: Vector3 } = {}
	local function add(name: string, perChunk: number)
		local need = math.ceil(perChunk * alive * PREWARM_SLACK)
		counts[name] = math.max(counts[name] or 0, need)
	end
	local function addEntries(entries: { Themes.PropEntry }, perChunk: number)
		local total = 0
		for _, entry in entries do
			total += entry.weight
		end
		for _, entry in entries do
			add(entry.recipe, perChunk * entry.weight / total)
			sizes[entry.recipe] = entry.size
		end
	end
	for _, theme in Themes do
		addEntries(theme.props, propsPerSide(theme) * 2)
		if theme.decorSpacing > 0 and #theme.decor > 0 then
			addEntries(theme.decor, 2 * CHUNK / decorSpacing(theme))
		end
		addEntries(theme.backdrop, 2)
		add(theme.obstacles.Low, 2)
		add(theme.obstacles.High, 2)
		add(theme.obstacles.Block, 4)
	end
	PropPool.shared():prewarm(counts, sizes)
end

function Track.new(generator: TrackGenerator.TrackGenerator, parent: Instance): Track
	local folder = Instance.new("Folder")
	folder.Name = "Track"
	folder.Parent = parent

	local self: TrackData = {
		generator = generator,
		folder = folder,
		pools = pools(),
		props = PropPool.shared(),
		built = {},
		nearby = {},
		pending = {},
		pendingHead = 1,
	}
	PropPool.shared().warmPaused = true
	return setmetatable(self, Track)
end

-- Altura do chão na distância indicada; nil = vão
function Track.groundAt(self: Track, distance: number): number?
	if distance < 0 then
		return 0
	end
	local index = math.floor(distance / CHUNK)
	local dz = distance - index * CHUNK
	for _, gap in ChunkGeometry.gapsOf(self.generator:getSlot(index).chunk) do
		if dz >= gap.z0 and dz < gap.z1 then
			return nil
		end
	end
	return 0
end

function Track._place(
	self: Track,
	built: BuiltChunk,
	pool: Pool.Pool,
	size: Vector3,
	center: Vector3,
	color: Color3,
	material: Enum.Material?
): BasePart
	local part = pool:acquire()
	part.Size = size
	part.Color = color
	part.Material = material or SMOOTH
	part.CFrame = TrackSpace.cframe(center.X, center.Y, center.Z)
	table.insert(built.parts, { pool = pool, part = part })
	return part
end

function Track._prop(self: Track, built: BuiltChunk, recipeName: string, center: Vector3, size: Vector3): PropPool.PropInstance
	local prop = self.props:acquire(recipeName)
	Track.stats.props += 1
	self.props:place(prop, TrackSpace.cframe(center.X, center.Y, center.Z), size)
	table.insert(built.props, prop)
	return prop
end

-- Cenário vai para a fila; montado por _drain
function Track._queueProp(self: Track, built: BuiltChunk, name: string, center: Vector3, size: Vector3)
	table.insert(self.pending, { built = built, name = name, center = center, size = size })
end

-- Monta props da fila até estourar o orçamento (budget = nil monta tudo)
function Track._drain(self: Track, budget: number?)
	local pending = self.pending
	local started = os.clock()
	while self.pendingHead <= #pending do
		local item = pending[self.pendingHead]
		self.pendingHead += 1
		if not item.built.released then
			self:_prop(item.built, item.name, item.center, item.size)
			if budget and os.clock() - started > budget then
				break
			end
		end
	end
	if self.pendingHead > #pending then
		table.clear(pending)
		self.pendingHead = 1
	end
end

-- Piso de um trecho sem vão: placa, linhas das pistas e faixas decorativas
function Track._floor(self: Track, built: BuiltChunk, from: number, to: number, theme: Themes.Theme)
	local length = to - from
	if length <= 0 then
		return
	end
	local thickness = TrackConfig.FloorThickness
	local mid = from + length / 2
	self:_place(
		built,
		self.pools.solid,
		Vector3.new(TRACK_WIDTH, thickness, length),
		Vector3.new(0, -thickness / 2, mid),
		theme.floor.color,
		theme.floor.material
	)

	-- Linhas entre as pistas
	for boundary = 1, LANES - 1 do
		self:_place(
			built,
			self.pools.flat,
			Vector3.new(Scenery.LaneLineWidth, 0.06, length),
			Vector3.new(TrackSpace.laneX(boundary + 0.5), 0.03, mid),
			theme.laneLine.color,
			theme.laneLine.material
		)
	end

	local every = theme.floor.stripeEvery
	local stripe = theme.floor.stripe
	if every and stripe then
		local z = math.ceil(from / every) * every
		while z < to do
			self:_place(
				built,
				self.pools.flat,
				Vector3.new(TRACK_WIDTH, 0.05, Scenery.StripeWidth),
				Vector3.new(0, 0.025, z),
				stripe
			)
			z += every
		end
	end
end

function Track._scenery(self: Track, built: BuiltChunk, start: number, theme: Themes.Theme)
	-- Bordas da pista
	local railX = TRACK_WIDTH / 2 + TrackConfig.RailWidth / 2
	local trimHeight = Scenery.RailTrimHeight
	for _, side in { -1, 1 } do
		self:_place(
			built,
			self.pools.flat,
			Vector3.new(TrackConfig.RailWidth, TrackConfig.RailHeight, CHUNK),
			Vector3.new(side * railX, TrackConfig.RailHeight / 2, start + CHUNK / 2),
			theme.rail.color
		)
		self:_place(
			built,
			self.pools.flat,
			Vector3.new(TrackConfig.RailWidth + 0.2, trimHeight, CHUNK),
			Vector3.new(side * railX, TrackConfig.RailHeight + trimHeight / 2, start + CHUNK / 2),
			theme.rail.trim,
			theme.rail.trimMaterial
		)

		-- Chão dos lados
		local width = Scenery.SideGroundWidth
		self:_place(
			built,
			self.pools.flat,
			Vector3.new(width, 1, CHUNK),
			Vector3.new(side * (EDGE + width / 2), -Scenery.SideGroundDrop - 0.5, start + CHUNK / 2),
			theme.ground.color,
			theme.ground.material
		)
	end

	-- Props sorteados pela seed: mesma pista, mesmo cenário para todos na corrida
	local rng = Random.new(self.generator.seed + built.index * Scenery.SeedSalt + 1)
	local slots = propsPerSide(theme)
	local slotLength = CHUNK / slots
	for _, side in { -1, 1 } do
		for s = 1, slots do
			local entry = pickWeighted(rng, theme.props)
			local size = entry.size
			local z = start + (s - 1 + rng:NextNumber(0.15, 0.85)) * slotLength
			local x = side * (EDGE + rng:NextNumber(entry.offset.Min, entry.offset.Max) + size.X / 2)
			local y = -Scenery.SideGroundDrop + (entry.elevation or 0) + size.Y / 2
			self:_queueProp(built, entry.recipe, Vector3.new(x, y, z), size)
		end
	end

	-- Decoração pequena e densa junto à borda (deixa a lateral viva)
	local spacing = decorSpacing(theme)
	if #theme.decor > 0 and spacing > 0 then
		for _, side in { -1, 1 } do
			local z = start + rng:NextNumber(0, spacing)
			while z < start + CHUNK do
				local entry = pickWeighted(rng, theme.decor)
				local size = entry.size
				local x = side * (EDGE + rng:NextNumber(entry.offset.Min, entry.offset.Max) + size.X / 2)
				local y = -Scenery.SideGroundDrop + (entry.elevation or 0) + size.Y / 2
				self:_queueProp(built, entry.recipe, Vector3.new(x, y, z), size)
				z += spacing * rng:NextNumber(0.7, 1.3)
			end
		end
	end

	-- Cerca contínua dos dois lados
	local fence = theme.fence
	if fence then
		local count = math.max(1, math.floor(CHUNK / fence.size.Z + 0.5))
		local length = CHUNK / count
		for _, side in { -1, 1 } do
			for i = 0, count - 1 do
				local x = side * (EDGE + fence.offset + fence.size.X / 2)
				local size = Vector3.new(fence.size.X, fence.size.Y, length)
				self:_queueProp(built, fence.recipe, Vector3.new(x, -Scenery.SideGroundDrop + size.Y / 2, start + (i + 0.5) * length), size)
			end
		end
	end

	-- Um elemento de fundo grande de cada lado por chunk
	if #theme.backdrop > 0 then
		for _, side in { -1, 1 } do
			local entry = pickWeighted(rng, theme.backdrop)
			local size = entry.size
			local x = side * (EDGE + rng:NextNumber(entry.offset.Min, entry.offset.Max) + size.X / 2)
			local z = start + CHUNK / 2 + rng:NextNumber(-CHUNK / 4, CHUNK / 4)
			local y = -Scenery.SideGroundDrop + (entry.elevation or 0) + size.Y / 2
			self:_queueProp(built, entry.recipe, Vector3.new(x, y, z), size)
		end
	end
end

function Track._obstacle(self: Track, built: BuiltChunk, kind: Types.ObjectKind, lane: number, z0: number, z1: number, theme: Themes.Theme)
	local x = TrackSpace.laneX(lane)
	local width = Obstacles.HalfWidth * 2
	local bottom, top
	local visuals: { PropPool.PropInstance } = {}

	if kind == "Low" then
		bottom, top = Obstacles.Low.bottom, Obstacles.Low.top
		table.insert(visuals, self:_prop(built, theme.obstacles.Low, Vector3.new(x, top / 2, (z0 + z1) / 2), Vector3.new(width, top, z1 - z0)))
	elseif kind == "High" then
		-- A caixa visual vai até o chão para mostrar os postes; a colisão é só a viga
		bottom, top = Obstacles.High.bottom, Obstacles.High.top
		table.insert(visuals, self:_prop(built, theme.obstacles.High, Vector3.new(x, top / 2, (z0 + z1) / 2), Vector3.new(width, top, z1 - z0)))
	else
		bottom, top = Obstacles.Block.bottom, Obstacles.Block.top
		local length = z1 - z0
		local tiles = math.max(1, math.floor(length / Scenery.BlockTileLength + 0.5))
		local tileLength = length / tiles
		for t = 0, tiles - 1 do
			local center = z0 + (t + 0.5) * tileLength
			table.insert(visuals, self:_prop(built, theme.obstacles.Block, Vector3.new(x, top / 2, center), Vector3.new(width, top, tileLength)))
		end
	end

	table.insert(built.obstacles, {
		kind = kind,
		lane = lane,
		x = x,
		z0 = z0,
		z1 = z1,
		bottom = bottom,
		top = top,
		disabled = false,
		props = visuals,
	})
end

-- Rajada de energia: o obstáculo some numa explosão e deixa de bater
function Track.blast(self: Track, obstacle: Obstacle, color: Color3)
	obstacle.disabled = true
	for _, prop in obstacle.props do
		self.props:hide(prop)
	end
	local center = TrackSpace.cframe(obstacle.x, (obstacle.bottom + obstacle.top) / 2, (obstacle.z0 + obstacle.z1) / 2)
	local holder = Instance.new("Part")
	holder.Anchored = true
	holder.CanCollide = false
	holder.CanQuery = false
	holder.CanTouch = false
	holder.Transparency = 1
	holder.Size = Vector3.new(Obstacles.HalfWidth * 2, obstacle.top - obstacle.bottom, obstacle.z1 - obstacle.z0)
	holder.CFrame = center
	holder.Parent = self.folder
	local burst = Instance.new("ParticleEmitter")
	burst.Shape = Enum.ParticleEmitterShape.Box
	burst.Rate = 0
	burst.Lifetime = NumberRange.new(0.4, 0.8)
	burst.Speed = NumberRange.new(15, 30)
	burst.SpreadAngle = Vector2.new(180, 180)
	burst.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.4), NumberSequenceKeypoint.new(1, 0) })
	burst.Color = ColorSequence.new(Color3.new(1, 1, 1), color)
	burst.LightEmission = 1
	burst.LightInfluence = 0
	burst.Parent = holder
	burst:Emit(BLAST_PARTICLES)
	Debris:AddItem(holder, 1.5)
end

function Track._build(self: Track, index: number): BuiltChunk
	local slot = self.generator:getSlot(index)
	local theme = Themes[slot.chapterId]
	local start = index * CHUNK
	local built: BuiltChunk = {
		index = index,
		slot = slot,
		parts = {},
		props = {},
		obstacles = {},
		coins = {},
		pickups = {},
		released = false,
	}

	-- Piso, interrompido nos vãos
	local cursor = 0
	for _, gap in ChunkGeometry.gapsOf(slot.chunk) do
		self:_floor(built, start + cursor, start + gap.z0, theme)
		cursor = gap.z1
	end
	self:_floor(built, start + cursor, start + CHUNK, theme)
	self:_scenery(built, start, theme)

	for _, object in slot.chunk.objects do
		local kind = object.kind
		local z0, z1 = ChunkGeometry.extent(object)
		z0 += start
		z1 += start
		local lane = object.lane or TrackSpace.CenterLane
		local x = TrackSpace.laneX(lane)

		if kind == "Low" or kind == "High" or kind == "Block" then
			self:_obstacle(built, kind, lane, z0, z1, theme)
		elseif kind == "Coins" then
			local count = object.count or 1
			local spacing = object.spacing or 0
			local arc = object.arcHeight or 0
			for k = 0, count - 1 do
				local t = if count > 1 then k / (count - 1) else 0.5
				local position = Vector3.new(
					x,
					GameConfig.Coins.Height + arc * math.sin(math.pi * t),
					start + object.z + k * spacing
				)
				local part = self.pools.coin:acquire()
				table.insert(built.parts, { pool = self.pools.coin, part = part })
				table.insert(built.coins, { part = part, position = position, collected = false, attracted = false })
			end
		elseif kind == "PowerUp" then
			local powerUpId = object.powerUp :: string
			local def = Abilities.PowerUps[powerUpId]
			local part = self:_place(
				built,
				self.pools.powerUp,
				Vector3.one * Obstacles.PowerUp.size,
				Vector3.new(x, Obstacles.PowerUp.height, (z0 + z1) / 2),
				def.color,
				Enum.Material.Neon
			)
			table.insert(built.pickups, {
				kind = "PowerUp",
				powerUpId = powerUpId,
				lane = lane,
				x = x,
				z0 = z0,
				z1 = z1,
				part = part,
				used = false,
			})
		elseif kind == "Trampoline" then
			local top = Obstacles.Trampoline.top
			local part = self:_place(
				built,
				self.pools.flat,
				Vector3.new(Obstacles.HalfWidth * 2, top, z1 - z0),
				Vector3.new(x, top / 2, (z0 + z1) / 2),
				theme.trampoline,
				Enum.Material.Neon
			)
			table.insert(built.pickups, {
				kind = "Trampoline",
				lane = lane,
				x = x,
				z0 = z0,
				z1 = z1,
				part = part,
				used = false,
			})
		end
	end

	return built
end

function Track._release(self: Track, built: BuiltChunk)
	built.released = true
	for _, entry in built.parts do
		entry.pool:release(entry.part)
	end
	for _, prop in built.props do
		self.props:release(prop)
	end
	table.clear(built.parts)
	table.clear(built.props)
end

-- Mantém os chunks perto do ponto indicado montados e devolve os outros ao pool.
-- budget = segundos por frame para montar o cenário da fila (maior durante a contagem de largada)
function Track.update(self: Track, distance: number, budget: number?)
	local current = math.floor(distance / CHUNK)
	local first = math.max(0, current - TrackConfig.ChunksBehind)
	local last = current + CHUNKS_AHEAD

	for index, built in self.built do
		if index < first or index > last then
			self:_release(built)
			self.built[index] = nil
		end
	end
	for index = first, last do
		if not self.built[index] then
			self.built[index] = self:_build(index)
			Track.stats.chunks += 1
		end
	end
	self:_drain(budget or SCENERY_BUDGET)
end

-- Chunk atual e o seguinte (para colisão, moedas e ímã)
function Track.chunksAround(self: Track, distance: number): { BuiltChunk }
	local nearby = self.nearby
	table.clear(nearby)
	local current = math.floor(distance / CHUNK)
	for index = current, current + 1 do
		local built = self.built[index]
		if built then
			table.insert(nearby, built)
		end
	end
	return nearby
end

function Track.hide(_self: Track, part: BasePart)
	part.CFrame = TrackSpace.Hidden
end

-- Moedas girando e power-ups flutuando
function Track.render(self: Track, time: number)
	local spin = CFrame.Angles(0, time * GameConfig.Coins.SpinSpeed, 0)
	local bob = math.sin(time * 3) * GameConfig.Visuals.PowerUpBob
	for _, built in self.built do
		for _, coin in built.coins do
			if not coin.collected then
				local p = coin.position
				coin.part.CFrame = TrackSpace.cframe(p.X, p.Y, p.Z) * spin
			end
		end
		for _, pickup in built.pickups do
			if pickup.kind == "PowerUp" and not pickup.used then
				pickup.part.CFrame =
					TrackSpace.cframe(pickup.x, Obstacles.PowerUp.height + bob, (pickup.z0 + pickup.z1) / 2)
			end
		end
	end
end

-- Devolve tudo aos pools do jogo (nada é destruído; a próxima corrida reaproveita)
function Track.destroy(self: Track)
	for _, built in self.built do
		self:_release(built)
	end
	table.clear(self.built)
	table.clear(self.pending)
	self.pendingHead = 1
	self.props.warmPaused = false
	self.folder:Destroy()
end

return Track
