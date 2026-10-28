--!strict
-- Simulação do corredor: movimento próprio e previsível em coordenadas da pista (sem física do Humanoid).
-- Troca de pista suave, pulo de altura variável, coyote time, buffer de entrada, pulo duplo, planar e deslizar.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local SpeedCurve = require(Shared.SpeedCurve)
local TrackSpace = require(script.Parent.TrackSpace)

local Jump = GameConfig.Jump
local LANE_COUNT = GameConfig.Track.LaneCount

export type MoveAction = "Left" | "Right" | "Jump" | "Slide"
export type RunnerEvent = "Jump" | "DoubleJump" | "Launch" | "Land" | "LaneChange" | "LaneBlocked" | "Slide"

export type Modifiers = {
	laneSwitchTime: number,
	slideDuration: number,
	glideDuration: number,
	doubleJump: boolean,
}

type Buffered = { action: MoveAction, at: number }

type RunnerData = {
	modifiers: Modifiers,
	onEvent: (RunnerEvent, number) -> (),
	time: number,
	distance: number,
	speed: number,
	speedScale: number, -- multiplicador externo: tropeço, patins, dash
	lane: number, -- pista de destino
	laneFrom: number,
	laneAlpha: number, -- 0..1 durante a troca
	x: number,
	y: number,
	vy: number,
	grounded: boolean,
	lastGroundedAt: number,
	jumpedSinceGround: boolean,
	cuttable: boolean, -- pulo do jogador (trampolim não é cortado ao soltar)
	jumpHeld: boolean,
	airJumpsUsed: number,
	glideUsed: number,
	gliding: boolean,
	slideRemaining: number,
	-- Buffers separados: trocar de pista não apaga um pulo pedido, e vice-versa
	lateralBuffer: Buffered?,
	verticalBuffer: Buffered?,
}

local Runner = {}
Runner.__index = Runner

export type Runner = typeof(setmetatable({} :: RunnerData, Runner))

local function smoothstep(t: number): number
	return t * t * (3 - 2 * t)
end

function Runner.new(modifiers: Modifiers, onEvent: (RunnerEvent, number) -> ()): Runner
	local self: RunnerData = {
		modifiers = modifiers,
		onEvent = onEvent,
		time = 0,
		distance = 0,
		speed = GameConfig.Speed.Start,
		speedScale = 1,
		lane = TrackSpace.CenterLane,
		laneFrom = TrackSpace.CenterLane,
		laneAlpha = 1,
		x = 0,
		y = 0,
		vy = 0,
		grounded = true,
		lastGroundedAt = 0,
		jumpedSinceGround = false,
		cuttable = false,
		jumpHeld = false,
		airJumpsUsed = 0,
		glideUsed = 0,
		gliding = false,
		slideRemaining = 0,
		lateralBuffer = nil,
		verticalBuffer = nil,
	}
	return setmetatable(self, Runner)
end

function Runner.isSliding(self: Runner): boolean
	return self.slideRemaining > 0
end

function Runner.height(self: Runner): number
	return if self.slideRemaining > 0 then GameConfig.Runner.SlideHeight else GameConfig.Runner.Height
end

function Runner.isSwitching(self: Runner): boolean
	return self.laneAlpha < 1
end

function Runner.press(self: Runner, action: MoveAction)
	local entry = { action = action, at = self.time }
	if action == "Left" or action == "Right" then
		self.lateralBuffer = entry
	else
		if action == "Jump" then
			self.jumpHeld = true
		end
		self.verticalBuffer = entry
	end
	self:_consumeBuffers()
end

-- Soltar cedo deixa o pulo mais baixo
function Runner.releaseJump(self: Runner)
	self.jumpHeld = false
	if self.cuttable and not self.grounded and self.vy > Jump.CutVelocity then
		self.vy = Jump.CutVelocity
	end
end

function Runner.launch(self: Runner, velocity: number)
	self:_takeOff(velocity, false)
	self.onEvent("Launch", velocity)
end

-- Bateu de lado num bloco: volta para a pista de onde veio
function Runner.cancelLaneChange(self: Runner)
	if self.laneAlpha >= 1 then
		return
	end
	self.lane, self.laneFrom = self.laneFrom, self.lane
	self.laneAlpha = 1 - self.laneAlpha
end

-- Revive: recoloca no chão num ponto seguro
function Runner.placeAt(self: Runner, distance: number)
	self.distance = distance
	self.y = 0
	self.vy = 0
	self.grounded = true
	self.slideRemaining = 0
	self.laneFrom = self.lane
	self.laneAlpha = 1
	self.x = TrackSpace.laneX(self.lane)
end

function Runner._takeOff(self: Runner, velocity: number, cuttable: boolean)
	-- Pulo pedido e já solto (toque curto ou buffer) sai baixo
	self.vy = if cuttable and not self.jumpHeld then math.min(velocity, Jump.CutVelocity) else velocity
	self.cuttable = cuttable
	self.grounded = false
	self.jumpedSinceGround = true
	self.slideRemaining = 0
end

function Runner._perform(self: Runner, action: MoveAction): boolean
	if action == "Left" or action == "Right" then
		if self.laneAlpha < 1 then
			return false -- ainda trocando: fica no buffer
		end
		local target = self.lane + (if action == "Left" then -1 else 1)
		if target < 1 or target > LANE_COUNT then
			self.onEvent("LaneBlocked", 0)
			return true
		end
		self.laneFrom = self.lane
		self.lane = target
		self.laneAlpha = 0
		self.onEvent("LaneChange", target)
		return true
	elseif action == "Jump" then
		local coyote = not self.jumpedSinceGround and self.time - self.lastGroundedAt <= Jump.CoyoteTime
		if self.grounded or coyote then
			self:_takeOff(Jump.Velocity, true)
			self.onEvent("Jump", 0)
			return true
		elseif self.modifiers.doubleJump and self.airJumpsUsed < 1 then
			self.airJumpsUsed += 1
			self:_takeOff(Jump.DoubleJumpVelocity, true)
			self.onEvent("DoubleJump", 0)
			return true
		end
		return false -- no ar: fica no buffer e sai ao pousar
	else
		self.slideRemaining = self.modifiers.slideDuration
		if not self.grounded then
			self.vy = math.min(self.vy, -GameConfig.Slide.FastFallSpeed)
		end
		self.onEvent("Slide", 0)
		return true
	end
end

function Runner._consumeBuffers(self: Runner)
	local window = GameConfig.Lanes.InputBuffer
	local lateral = self.lateralBuffer
	if lateral then
		if self.time - lateral.at > window or self:_perform(lateral.action) then
			self.lateralBuffer = nil
		end
	end
	local vertical = self.verticalBuffer
	if vertical then
		if self.time - vertical.at > window or self:_perform(vertical.action) then
			self.verticalBuffer = nil
		end
	end
end

function Runner.step(self: Runner, dt: number, groundAt: (distance: number) -> number?)
	self.time += dt
	self:_consumeBuffers()

	-- Lateral
	if self.laneAlpha < 1 then
		self.laneAlpha = math.min(1, self.laneAlpha + dt / self.modifiers.laneSwitchTime)
	end
	local fromX, toX = TrackSpace.laneX(self.laneFrom), TrackSpace.laneX(self.lane)
	self.x = fromX + (toX - fromX) * smoothstep(self.laneAlpha)

	-- Frente
	self.speed = SpeedCurve.speedAt(self.time) * self.speedScale
	self.distance += self.speed * dt

	-- Vertical
	local ground = groundAt(self.distance)
	if self.grounded then
		if ground == nil then
			-- Saiu da borda: começa o coyote time
			self.grounded = false
			self.lastGroundedAt = self.time
			self.jumpedSinceGround = false
			self.cuttable = false
		else
			self.y = ground
		end
	end

	if not self.grounded then
		self.vy -= Jump.Gravity * dt
		self.gliding = self.jumpHeld and self.vy < 0 and self.glideUsed < self.modifiers.glideDuration
		if self.gliding then
			self.vy = math.max(self.vy, -Jump.GlideFallSpeed)
			self.glideUsed += dt
		end

		local nextY = self.y + self.vy * dt
		if ground ~= nil and self.vy <= 0 and nextY <= ground and self.y >= ground - Jump.LandSnap then
			local impact = -self.vy
			self.y = ground
			self.vy = 0
			self.grounded = true
			self.gliding = false
			self.cuttable = false
			self.airJumpsUsed = 0
			self.glideUsed = 0
			self.jumpedSinceGround = false
			self.onEvent("Land", impact)
			self:_consumeBuffers() -- pulo pedido pouco antes de pousar sai agora
		else
			self.y = nextY
		end
	elseif self.slideRemaining > 0 then
		-- Deslizar pedido no ar só começa a contar ao pousar
		self.slideRemaining = math.max(0, self.slideRemaining - dt)
	end
end

return Runner
