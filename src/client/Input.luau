--!strict
-- Comandos da corrida: deslizar o dedo no celular e teclas no PC (mapeadas em GameConfig.Input).
-- O deslize dispara assim que passa do limiar, sem esperar o dedo sair, para resposta imediata.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)

export type Action = "Left" | "Right" | "Jump" | "Slide" | "Ability"

type Handlers = {
	onAction: (Action) -> (),
	onJumpRelease: () -> (),
}

type TouchState = { start: Vector3, fired: Action? }

type InputData = {
	handlers: Handlers,
	keyMap: { [Enum.KeyCode]: Action },
	touches: { [InputObject]: TouchState },
	connections: { RBXScriptConnection },
}

local Input = {}
Input.__index = Input

export type Input = typeof(setmetatable({} :: InputData, Input))

local function buildKeyMap(): { [Enum.KeyCode]: Action }
	local map: { [Enum.KeyCode]: Action } = {}
	for action, keys in GameConfig.Input.Keys :: { [string]: { Enum.KeyCode } } do
		for _, key in keys do
			map[key] = action :: Action
		end
	end
	return map
end

local function swipeAction(delta: Vector3): Action
	if math.abs(delta.X) > math.abs(delta.Y) then
		return if delta.X < 0 then "Left" else "Right"
	end
	return if delta.Y < 0 then "Jump" else "Slide" -- Y da tela cresce para baixo
end

function Input.new(handlers: Handlers): Input
	local self: InputData = {
		handlers = handlers,
		keyMap = buildKeyMap(),
		touches = {},
		connections = {},
	}
	local input = setmetatable(self, Input)

	table.insert(
		self.connections,
		UserInputService.InputBegan:Connect(function(object, processed)
			if processed then
				return
			end
			if object.UserInputType == Enum.UserInputType.Keyboard then
				local action = self.keyMap[object.KeyCode]
				if action then
					handlers.onAction(action)
				end
			elseif object.UserInputType == Enum.UserInputType.Touch then
				self.touches[object] = { start = object.Position, fired = nil }
			end
		end)
	)

	table.insert(
		self.connections,
		UserInputService.InputChanged:Connect(function(object)
			local touch = self.touches[object]
			if not touch or touch.fired then
				return
			end
			local camera = Workspace.CurrentCamera
			local threshold = (if camera then camera.ViewportSize.Y else 800) * GameConfig.Input.SwipeThreshold
			local delta = object.Position - touch.start
			if delta.Magnitude >= threshold then
				local action = swipeAction(delta)
				touch.fired = action
				handlers.onAction(action)
			end
		end)
	)

	table.insert(
		self.connections,
		UserInputService.InputEnded:Connect(function(object)
			if object.UserInputType == Enum.UserInputType.Keyboard then
				if self.keyMap[object.KeyCode] == "Jump" then
					handlers.onJumpRelease()
				end
				return
			end
			local touch = self.touches[object]
			if touch then
				self.touches[object] = nil
				if touch.fired == "Jump" then
					handlers.onJumpRelease()
				end
			end
		end)
	)

	return input
end

function Input.destroy(self: Input)
	for _, connection in self.connections do
		connection:Disconnect()
	end
	table.clear(self.connections)
	table.clear(self.touches)
end

return Input
