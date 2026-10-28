--!strict
-- Números do jogo. Valores iniciais sugeridos no GDD: ajustar em play test, nunca espalhar pelo código.

local GameConfig = {
	Track = {
		Origin = Vector3.new(6000, 600, 0), -- a pista é local do cliente, longe da vila do lobby
		LaneCount = 5, -- pistas lado a lado; a do meio é a de largada
		LaneWidth = 8,
		ChunkLength = 60,
		ChunksAhead = 6,
		ChunksBehind = 1,
		StartChunks = 2, -- chunks calmos no começo da corrida
		EdgeMargin = 6, -- encaixe: sem obstáculos nos primeiros e últimos studs do chunk
		MaxGapLength = 14,
		MetersPerStud = 0.28,
		ChapterLengthMeters = 1000,
		FloorThickness = 2,
		RailWidth = 2,
		RailHeight = 2,
		KillHeight = -15,
		HiddenPosition = Vector3.new(0, 10000, 0), -- peças guardadas no pool (acima do FallenPartsDestroyHeight)
	},

	-- Velocidade em studs/s: começa baixa e sobe até o teto
	Speed = {
		Start = 30,
		Max = 70,
		RampSeconds = 180,
	},

	Lanes = {
		SwitchTime = 0.12,
		InputBuffer = 0.15,
	},

	Jump = {
		Gravity = 120,
		Velocity = 42, -- pulo alto: ~7,3 studs
		CutVelocity = 30, -- soltar cedo corta o pulo (pulo baixo: ~3,7 studs)
		DoubleJumpVelocity = 36,
		TrampolineVelocity = 70,
		CoyoteTime = 0.1,
		LandSnap = 1,
		GlideFallSpeed = 6,
		GlideDuration = 0.8,
	},

	Slide = {
		Duration = 0.6,
		FastFallSpeed = 60, -- deslizar no ar puxa para o chão
	},

	Runner = {
		Width = 2.4,
		Height = 5,
		SlideHeight = 2.2,
		Depth = 2,
	},

	Obstacles = {
		HalfWidth = 3.4,
		Low = { length = 2, bottom = 0, top = 2.5 },
		High = { length = 2, bottom = 3.5, top = 9 },
		Block = { bottom = 0, top = 12 },
		Trampoline = { length = 4, top = 0.6 },
		PowerUp = { length = 3, size = 2.5, height = 2.5 },
	},

	Collision = {
		-- Bater de frente num bloco inteiro: "Crash" encerra (estilo do gênero) ou "Stumble" só tropeça.
		-- Balanceamento a validar com o usuário.
		BlockHeadOn = "Crash" :: "Crash" | "Stumble",
		GraceSeconds = 1,
	},

	Stumble = {
		ComboWindow = 10, -- segundo tropeço dentro desta janela encerra a corrida
		SpeedPenalty = 0.7,
		RecoverSeconds = 1.5,
	},

	-- Perseguidor desligado por enquanto (decisão de 28/10/2026); o código fica para voltar depois
	Chaser = {
		Enabled = false,
		FarGap = 45,
		NearGap = 8,
		CaughtGap = 1.5,
		Follow = 1, -- velocidade com que o vilão se aproxima ou se afasta
		CatchFollow = 4, -- alcançando o herói no fim da corrida
	},

	-- Energia: enche com moedas e distância; cheia, libera a transformação (Abilities.Transform)
	Energy = {
		Max = 100,
		PerCoin = 2,
		PerMeter = 0.12,
	},

	Revive = {
		GraceSeconds = 2,
	},

	Coins = {
		Value = 1,
		Height = 2,
		PickupRadius = 3,
		MagnetRadius = 14,
		MagnetPull = 12,
		SpinSpeed = 3,
	},

	-- Dificuldade máxima dos chunks por distância percorrida (metros)
	Difficulty = {
		{ meters = 0, maxDifficulty = 1 },
		{ meters = 300, maxDifficulty = 2 },
		{ meters = 700, maxDifficulty = 3 },
		{ meters = 1300, maxDifficulty = 4 },
		{ meters = 2000, maxDifficulty = 5 },
	},
	-- Peso do sorteio: [1] = chunk na dificuldade máxima atual, [2] = um nível abaixo...
	DifficultyWeights = { 3, 2, 1, 1, 1 },

	Camera = {
		Offset = Vector3.new(0, 10.5, 20), -- mais alta e afastada para enxergar as 5 pistas
		LookAhead = 14,
		LookHeight = 2,
		FollowX = 10,
		FollowY = 6,
		BaseFov = 72,
		MaxFov = 86,
		ShakeDecay = 3,
		LandShake = 0.2,
		HitShake = 0.9,
	},

	-- Animações padrão do Roblox para corpos R15 (as mesmas do script Animate)
	Animations = {
		Run = "rbxassetid://913376220",
		Jump = "rbxassetid://507765000",
		Fall = "rbxassetid://507767968",
		Idle = "rbxassetid://507766666",
		RunSpeed = 1.4, -- a corrida do jogo é rápida
	},

	Visuals = {
		LeanAngle = 0.35,
		CoinSize = Vector3.new(0.4, 2.2, 2.2),
		LandParticles = 8,
		LandParticlesMinImpact = 25,
		PowerUpBob = 0.5,
		GhostTransparency = 0.55,
	},

	-- Cenário montado ao redor da pista
	Scenery = {
		BlockTileLength = 12, -- blocos longos viram uma fileira de casas/torres
		LaneLineWidth = 0.3,
		StripeWidth = 0.6,
		SideGroundWidth = 260,
		SideGroundDrop = 0.6, -- chão lateral um pouco abaixo da pista
		RailTrimHeight = 0.4,
		SeedSalt = 7919,
		MaxModelParts = 300, -- modelo da loja com mais peças que isso não entra (usa a receita de reserva)
		-- Aparelho de toque sem teclado (celular/tablet): menos cenário e menos chunks montados à frente
		Mobile = {
			Density = 0.6, -- fração de props e decoração
			ChunksAhead = 4,
		},
	},

	-- Efeitos de ambiente no cliente
	Fx = {
		ParticleArea = Vector3.new(140, 1, 180),
		ParticleHeight = 45,
		ParticleAhead = 70,
		AuroraDistance = 700,
		AuroraHeight = 220,
		AuroraBands = 4,
		SpeedLinesFromSpeed = 50, -- studs/s em que as linhas de vento aparecem
		SpeedLinesMaxRate = 60,
	},

	-- Vila do lobby (montada pelo servidor): vila japonesa com cerejeiras
	Lobby = {
		Center = Vector3.new(0, 0, 0),
		GroundSize = 700,
		PlazaRadius = 70,
		SpawnOffset = Vector3.new(0, 3, 45),
		TempleOffset = Vector3.new(0, 0, -62),
		PadOffset = Vector3.new(0, 0, -22),
		PadRadius = 11,
		HouseRing = 98,
		HouseCount = 8,
		TreeRing = 82,
		TreeCount = 10,
		LanternRing = 58,
		LanternCount = 10,
		ForestRing = 150,
		ForestCount = 18,
		CanalOffset = 30, -- canal de água dos dois lados da avenida
	},

	-- Corrida multiplayer (GDD seção 10). Mínimo de jogadores e regras de vitória: em aberto.
	Match = {
		MinPlayers = 2,
		MaxPlayers = 8,
		CountdownSeconds = 30,
		CountIn = 3, -- 3, 2, 1, já!
		MaxRaceSeconds = 600,
		TickSeconds = 0.2,
		RelayInterval = 0.125, -- posição dos rivais ~8x por segundo
		StudioMinPlayers = 1, -- no Studio dá para testar sozinho
		StudioCountdownSeconds = 8,
	},

	Input = {
		SwipeThreshold = 0.05, -- fração da altura da tela
		Keys = {
			Left = { Enum.KeyCode.A, Enum.KeyCode.Left },
			Right = { Enum.KeyCode.D, Enum.KeyCode.Right },
			Jump = { Enum.KeyCode.Space, Enum.KeyCode.W, Enum.KeyCode.Up },
			Slide = { Enum.KeyCode.S, Enum.KeyCode.LeftControl, Enum.KeyCode.Down },
			Ability = { Enum.KeyCode.E, Enum.KeyCode.LeftShift },
			Transform = { Enum.KeyCode.Q, Enum.KeyCode.R },
		},
	},

	Juice = {
		CoinPitchStep = 0.04,
		CoinPitchMax = 1.8,
		CoinComboReset = 1.2,
	},

	Ui = {
		TitleSeconds = 2.5, -- logo na entrada, antes da vila (toque pula)
		TweenSeconds = 0.25,
		PressScale = 0.92,
		HoverScale = 1.05,
		ResultsDelay = 1.2,
		ResultsTimeout = 8, -- sem resposta do servidor, volta ao menu
		FlashSeconds = 1.2,
		PageTurnSeconds = 0.9,
		SoloCountIn = 1.5,
	},

	Simulation = {
		MaxStep = 1 / 120, -- subpassos evitam atravessar obstáculos em alta velocidade
		MaxFrame = 1 / 15,
	},

	Server = {
		StartCooldown = 1.5,
		LatencyAllowance = 3,
		DistanceTolerance = 1.25, -- folga para patins e dash
		MaxRunSeconds = 3600,
	},

	Dev = {
		-- No Studio todos os heróis e capítulos ficam liberados, para testar
		UnlockAllInStudio = true,
		-- Fase de testes: todos os personagens liberados também no jogo publicado (ainda não há loja nem ovos).
		-- Desligar quando existir um jeito de desbloquear.
		UnlockAllHeroes = true,
		LagLogInStudio = true, -- frames lentos da corrida aparecem no Output ([Lag])
		StudioUpgrades = { DoubleJump = 1, ExtraLife = 0, MagnetPower = 2 },
	},
}

return GameConfig
