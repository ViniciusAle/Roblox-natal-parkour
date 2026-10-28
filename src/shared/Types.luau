--!strict
-- Tipos compartilhados entre cliente e servidor.

export type ObjectKind = "Low" | "High" | "Block" | "Gap" | "Coins" | "PowerUp" | "Trampoline"

-- Objeto dentro de um chunk. z é medido em studs a partir da entrada do chunk.
export type ChunkObject = {
	kind: ObjectKind,
	z: number,
	lane: number?, -- 1 a GameConfig.Track.LaneCount (5); Gap ocupa todas as pistas
	length: number?, -- Block e Gap
	count: number?, -- Coins
	spacing: number?, -- Coins
	arcHeight: number?, -- Coins em arco (sobre obstáculos e trampolins)
	powerUp: string?, -- PowerUp: id em Abilities.PowerUps
}

export type ChunkDef = {
	id: string,
	difficulty: number, -- 1 a 5
	chapters: { string }?, -- nil = serve em qualquer capítulo
	special: ("Start" | "PageTurn")?,
	objects: { ChunkObject },
}

export type ChunkSlot = {
	index: number,
	chunk: ChunkDef,
	chapterId: string,
}

-- Efeito temporário (power-up da pista ou habilidade ativa de herói)
export type Effect = {
	duration: number,
	speedMultiplier: number?,
	invulnerable: boolean?,
	coinMultiplier: number?,
	magnet: boolean?,
	timeScale: number?,
	crushKinds: { [string]: boolean }?,
}

export type RunUpgrades = {
	doubleJump: boolean,
	extraLives: number,
	magnetLevel: number,
}

-- O que o servidor entrega ao iniciar uma corrida
export type RunLoadout = {
	seed: number,
	chapterId: string,
	heroId: string,
	upgrades: RunUpgrades,
}

-- O que o cliente informa ao terminar (o servidor valida tudo)
export type RunReport = {
	distance: number,
	coins: number,
}

export type RunResult = {
	meters: number,
	coins: number,
	totalCoins: number,
	bestMeters: number,
	newBest: boolean,
	adjusted: boolean,
}

-- Corrida multiplayer --------------------------------------------------------------

export type Rival = {
	userId: number,
	name: string,
	heroId: string,
}

-- Estado da fila do lobby, enviado a todos
export type MatchState = {
	state: "Waiting" | "Countdown" | "Racing",
	queued: number,
	minPlayers: number,
	maxPlayers: number,
	endsAt: number, -- workspace:GetServerTimeNow() em que a contagem acaba
	chapterId: string,
}

export type RaceStart = {
	raceId: number,
	loadout: RunLoadout,
	startAt: number, -- workspace:GetServerTimeNow() da largada
	rivals: { Rival },
}

-- { userId, distância, x, y, deslizando (0/1), vivo (0/1) }: compacto para o UnreliableRemoteEvent
export type RaceSnapshotEntry = { number }

export type RaceStanding = {
	userId: number,
	name: string,
	meters: number,
	place: number,
}

export type RaceResults = {
	raceId: number,
	ranking: { RaceStanding },
}

return {}
