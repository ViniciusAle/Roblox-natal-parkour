--!strict
-- Habilidades (GDD seção 9) e habilidades ativas dos heróis (seção 6).
-- Durações, alcances e recargas são valores iniciais para balancear; preços a definir.

local Types = require(script.Parent.Parent.Types)

export type PowerUpDef = {
	color: Color3,
	shield: boolean?,
	effect: Types.Effect?,
}

export type UpgradeDef = {
	maxLevel: number,
	price: number?,
}

export type HeroActiveDef = {
	cooldown: number,
	effect: Types.Effect,
	blastRange: number?, -- rajada: destrói o primeiro obstáculo à frente na pista, até esta distância (studs)
}

-- Itens pegos na pista
local PowerUps: { [string]: PowerUpDef } = {
	Magnet = { color = Color3.fromRGB(230, 60, 80), effect = { duration = 8, magnet = true } },
	Shield = { color = Color3.fromRGB(120, 210, 255), shield = true },
	DoubleCoins = { color = Color3.fromRGB(255, 200, 40), effect = { duration = 10, coinMultiplier = 2 } },
	Skates = {
		color = Color3.fromRGB(160, 120, 255),
		effect = { duration = 4, speedMultiplier = 1.4, invulnerable = true },
	},
}

-- Melhorias permanentes (nível guardado no perfil do jogador)
local Upgrades: { [string]: UpgradeDef } = {
	DoubleJump = { maxLevel = 1 },
	ExtraLife = { maxLevel = 3 }, -- 1 revive por nível
	MagnetPower = { maxLevel = 5 },
}

-- Ganho por nível do Ímã Poderoso
local MagnetPerLevel = { duration = 1.5, radius = 2 }

-- Consumíveis fortes (entram junto com a loja)
local Consumables = {
	WarpScroll = { distanceMeters = 150, graceSeconds = 2 },
}

local HeroActives: { [string]: HeroActiveDef } = {
	Dash = { cooldown = 30, effect = { duration = 2, speedMultiplier = 1.5, invulnerable = true } },
	Smash = { cooldown = 30, effect = { duration = 3, crushKinds = { Low = true } } },
	TimeSlow = { cooldown = 35, effect = { duration = 2.5, timeScale = 0.6 } },
	EnergyBlast = { cooldown = 18, effect = { duration = 0.5 }, blastRange = 70 },
}

-- Transformação (energia cheia): mais rápido, imune a batidas e puxando moedas.
-- Sem multiplicador de moedas, para não passar do limite que o servidor aceita.
local Transform: Types.Effect = { duration = 7, speedMultiplier = 1.2, invulnerable = true, magnet = true }

-- Maior multiplicador de moedas possível ao mesmo tempo (usado na validação do servidor)
local function maxEffectCoinMultiplier(): number
	local best = 1
	for _, def in PowerUps do
		if def.effect and def.effect.coinMultiplier then
			best = math.max(best, def.effect.coinMultiplier)
		end
	end
	for _, def in HeroActives do
		if def.effect.coinMultiplier then
			best = math.max(best, def.effect.coinMultiplier)
		end
	end
	return best
end

return {
	PowerUps = PowerUps,
	Upgrades = Upgrades,
	MagnetPerLevel = MagnetPerLevel,
	Consumables = Consumables,
	HeroActives = HeroActives,
	Transform = Transform,
	maxEffectCoinMultiplier = maxEffectCoinMultiplier,
}
