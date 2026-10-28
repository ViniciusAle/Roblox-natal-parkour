--!strict
-- Vilão perseguidor montado pela receita dele (Config/Props). A distância até o herói vem da RunSession.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local Villains = require(Shared.Config.Villains)
local Props = require(Shared.Config.Props)
local PropAssembler = require(Shared.PropAssembler)

local TrackSpace = require(script.Parent.TrackSpace)

local BOX = Vector3.new(3.6, 7, 2.6)
local DEFAULT_RECIPE = "ChaserShadow"

type ViewData = {
	parent: Instance,
	villainId: string?,
	model: Model?,
	recipe: PropAssembler.Recipe?,
	parts: { BasePart },
	x: number,
}

local ChaserView = {}
ChaserView.__index = ChaserView

export type ChaserView = typeof(setmetatable({} :: ViewData, ChaserView))

function ChaserView.new(parent: Instance): ChaserView
	local self: ViewData = { parent = parent, villainId = nil, model = nil, recipe = nil, parts = {}, x = 0 }
	return setmetatable(self, ChaserView)
end

function ChaserView.setVillain(self: ChaserView, villainId: string)
	if self.villainId == villainId then
		return
	end
	local villain = Villains.ById[villainId]
	local recipe = Props[(villain and villain.recipe) or DEFAULT_RECIPE]
	if self.model then
		self.model:Destroy()
	end
	local model, parts = PropAssembler.create(recipe, self.parent, false)
	model.Name = "Chaser"
	self.villainId = villainId
	self.model = model
	self.recipe = recipe
	self.parts = parts
end

function ChaserView.update(self: ChaserView, dt: number, targetX: number, distance: number, time: number)
	local recipe = self.recipe
	if not recipe then
		return
	end
	self.x += (targetX - self.x) * math.min(1, dt * 6)
	local bob = math.abs(math.sin(time * 10)) * 0.6
	local sway = CFrame.Angles(0, 0, math.sin(time * 10) * 0.08)
	PropAssembler.place(self.parts, recipe, TrackSpace.cframe(self.x, BOX.Y / 2 + bob, distance) * sway, BOX)
end

function ChaserView.destroy(self: ChaserView)
	if self.model then
		self.model:Destroy()
	end
end

return ChaserView
