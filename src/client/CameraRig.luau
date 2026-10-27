--!strict
-- Câmera atrás e acima do herói, com FOV que cresce com a velocidade e tremida em impactos.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)

local Config = GameConfig.Camera
local Speed = GameConfig.Speed

type RigData = {
	camera: Camera,
	previousFov: number,
	x: number,
	y: number,
	shakeAmount: number,
	random: Random,
}

local CameraRig = {}
CameraRig.__index = CameraRig

export type CameraRig = typeof(setmetatable({} :: RigData, CameraRig))

function CameraRig.new(): CameraRig
	local camera = Workspace.CurrentCamera :: Camera
	local self: RigData = {
		camera = camera,
		previousFov = camera.FieldOfView,
		x = 0,
		y = 0,
		shakeAmount = 0,
		random = Random.new(),
	}
	camera.CameraType = Enum.CameraType.Scriptable
	return setmetatable(self, CameraRig)
end

function CameraRig.shake(self: CameraRig, amount: number)
	self.shakeAmount = math.max(self.shakeAmount, amount)
end

-- focus em coordenadas da pista (x, y, distância)
function CameraRig.update(self: CameraRig, dt: number, focus: Vector3, speed: number)
	self.x += (focus.X - self.x) * math.min(1, dt * Config.FollowX)
	self.y += (focus.Y - self.y) * math.min(1, dt * Config.FollowY)

	local shake = Vector3.zero
	if self.shakeAmount > 0 then
		shake = Vector3.new(self.random:NextNumber(-1, 1), self.random:NextNumber(-1, 1), 0) * self.shakeAmount
		self.shakeAmount = math.max(0, self.shakeAmount - dt * Config.ShakeDecay)
	end

	local origin = GameConfig.Track.Origin
	local eye = origin + Vector3.new(self.x, self.y, -focus.Z) + Config.Offset + shake
	local target = origin + Vector3.new(self.x, self.y + Config.LookHeight, -focus.Z - Config.LookAhead)
	self.camera.CFrame = CFrame.lookAt(eye, target)

	local alpha = math.clamp((speed - Speed.Start) / (Speed.Max - Speed.Start), 0, 1)
	self.camera.FieldOfView = Config.BaseFov + (Config.MaxFov - Config.BaseFov) * alpha
end

function CameraRig.destroy(self: CameraRig)
	self.camera.CameraType = Enum.CameraType.Custom
	self.camera.FieldOfView = self.previousFov
end

return CameraRig
