--!strict
-- Congela o personagem do lobby durante a corrida (o herói da corrida é outro modelo, movido por script).
-- Não espera o PlayerModule: algumas versões do Roblox não o colocam em PlayerScripts.

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local locked = false
local lockedRoot: BasePart? = nil
local previousTouchControls = true

local function setDefaultControls(enabled: boolean)
	local playerScripts = player:FindFirstChild("PlayerScripts")
	local module = playerScripts and playerScripts:FindFirstChild("PlayerModule")
	if not module or not module:IsA("ModuleScript") then
		return
	end
	pcall(function()
		local controls = (require :: any)(module):GetControls()
		if enabled then
			controls:Enable()
		else
			controls:Disable()
		end
	end)
end

local CharacterLock = {}

function CharacterLock.lock()
	if locked then
		return
	end
	locked = true
	setDefaultControls(false)
	previousTouchControls = GuiService.TouchControlsEnabled
	GuiService.TouchControlsEnabled = false

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if root and root:IsA("BasePart") then
		root.Anchored = true
		lockedRoot = root
	end
end

function CharacterLock.unlock()
	if not locked then
		return
	end
	locked = false
	setDefaultControls(true)
	GuiService.TouchControlsEnabled = previousTouchControls

	local root = lockedRoot
	if root and root.Parent then
		root.Anchored = false
	end
	lockedRoot = nil
end

return CharacterLock
