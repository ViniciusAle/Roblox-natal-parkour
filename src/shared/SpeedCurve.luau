--!strict
-- Velocidade base pelo tempo de corrida. O servidor usa distanceAt para limitar a distância informada.

local GameConfig = require(script.Parent.Config.GameConfig)

local Speed = GameConfig.Speed

local SpeedCurve = {}

function SpeedCurve.speedAt(seconds: number): number
	local alpha = math.clamp(seconds / Speed.RampSeconds, 0, 1)
	return Speed.Start + (Speed.Max - Speed.Start) * alpha
end

-- Integral de speedAt: distância máxima sem bônus após t segundos
function SpeedCurve.distanceAt(seconds: number): number
	local t = math.max(0, seconds)
	local ramp = Speed.RampSeconds
	local gain = Speed.Max - Speed.Start
	if t <= ramp then
		return Speed.Start * t + gain * t * t / (2 * ramp)
	end
	return Speed.Start * ramp + gain * ramp / 2 + Speed.Max * (t - ramp)
end

return SpeedCurve
