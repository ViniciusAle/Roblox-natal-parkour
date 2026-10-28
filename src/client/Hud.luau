--!strict
-- Interface, celular primeiro: layout por escala, botões grandes, dentro da área segura.
-- Telas: Title (logo de entrada), Lobby (vila: personagem, fase, fila da corrida), Run (HUD),
-- Results (solo) e RaceResults (ranking da corrida multiplayer). Visual em UiKit.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Strings = require(Shared.Config.Strings)
local Types = require(Shared.Types)

local UiKit = require(script.Parent.UiKit)

local Ui = GameConfig.Ui
local C = UiKit.Colors
local MAX_STANDINGS = 8
local SPEED_LINES = 14

export type Screen = "Title" | "Lobby" | "Run" | "Results" | "RaceResults"

export type Handlers = {
	solo: () -> (),
	again: () -> (),
	village: () -> (),
	cycleHero: (step: number) -> (),
	cycleChapter: (step: number) -> (),
	ability: () -> (),
	transform: () -> (),
}

export type StandingRow = { name: string, meters: number, alive: boolean, isYou: boolean }

type HudData = {
	gui: ScreenGui,
	screens: { [Screen]: Frame },
	slides: { [Screen]: { frame: Frame, target: UDim2 } },
	heroLabel: TextLabel,
	rarityLabel: TextLabel,
	chapterLabel: TextLabel,
	statusLabel: TextLabel,
	matchBanner: Frame,
	matchLabel: TextLabel,
	coinsLabel: TextLabel,
	distanceLabel: TextLabel,
	effectsLabel: TextLabel,
	banner: TextLabel,
	abilityButton: TextButton,
	energyFill: Frame,
	transformButton: TextButton,
	transformPulse: Tween?,
	countdown: TextLabel,
	spectating: TextLabel,
	standings: Frame,
	standingRows: { TextLabel },
	page: Frame,
	pageLabel: TextLabel,
	resultLabels: { TextLabel },
	raceRows: { TextLabel },
	raceCoins: TextLabel,
	logo: Frame,
	tapLabel: TextLabel,
	cache: { [Instance]: string },
	flashToken: number,
}

local Hud = {}
Hud.__index = Hud

export type Hud = typeof(setmetatable({} :: HudData, Hud))

local function screenFrame(parent: Instance, name: string): Frame
	local frame = UiKit.frame(parent, name, UDim2.fromScale(1, 1))
	frame.Visible = false
	return frame
end

local function sizeLimits(parent: Instance, min: Vector2, max: Vector2)
	local constraint = Instance.new("UISizeConstraint")
	constraint.MinSize = min
	constraint.MaxSize = max
	constraint.Parent = parent
end

-- Linha "< valor >"
local function selector(parent: Instance, name: string, order: number, onStep: (number) -> ()): TextLabel
	local row = UiKit.frame(parent, name, UDim2.fromScale(1, 0.14))
	row.LayoutOrder = order

	local prev = UiKit.button(row, "Prev", UDim2.fromScale(0.18, 1), "<", "Pink", function()
		onStep(-1)
	end)
	prev.Position = UDim2.fromScale(0, 0)

	local value = UiKit.text(row, "Value", UDim2.fromScale(0.6, 0.8), "", 30)
	value.AnchorPoint = Vector2.new(0.5, 0.5)
	value.Position = UDim2.fromScale(0.5, 0.5)

	local nextButton = UiKit.button(row, "Next", UDim2.fromScale(0.18, 1), ">", "Pink", function()
		onStep(1)
	end)
	nextButton.AnchorPoint = Vector2.new(1, 0)
	nextButton.Position = UDim2.fromScale(1, 0)
	return value
end

local function caption(parent: Instance, text: string, order: number): TextLabel
	local label = UiKit.text(parent, "Caption", UDim2.fromScale(1, 0.07), text, 20, C.mute, UiKit.Fonts.body)
	label.LayoutOrder = order
	return label
end

-- Logo temporário: "BRAINROT RUSH" em letras tortas e coloridas, linhas de velocidade e um risco rosa
local function buildTitle(gui: ScreenGui): (Frame, Frame, TextLabel)
	local title = screenFrame(gui, "Title")
	title.BackgroundTransparency = 0
	title.BackgroundColor3 = C.grape
	title.ZIndex = 30
	UiKit.gradient(title, C.grapeLight, Color3.fromRGB(18, 6, 34))

	local random = Random.new(7)
	for i = 1, SPEED_LINES do
		local line = UiKit.shape(
			title,
			`SpeedLine{i}`,
			UDim2.fromScale(random:NextNumber(0.2, 0.5), 0.006),
			UDim2.fromScale(random:NextNumber(0, 1), random:NextNumber(0.05, 0.95)),
			if i % 3 == 0 then C.pink else C.lime
		)
		line.BackgroundTransparency = random:NextNumber(0.4, 0.8)
		line.ZIndex = 31
	end

	local logo = UiKit.frame(title, "Logo", UDim2.fromScale(0.8, 0.5), UDim2.fromScale(0.5, 0.44), Vector2.new(0.5, 0.5))
	sizeLimits(logo, Vector2.new(280, 140), Vector2.new(900, 420))

	local slash = UiKit.shape(logo, "Slash", UDim2.fromScale(1.1, 0.05), UDim2.fromScale(0.5, 0.55), C.gold)
	slash.Rotation = -6
	slash.ZIndex = 32
	UiKit.gradient(slash, C.pink, C.gold, 0)

	local function word(name: string, text: string, y: number, height: number, tilt: number, from: Color3, to: Color3)
		local label = UiKit.text(logo, name, UDim2.fromScale(1, height), text, 140, C.white)
		label.AnchorPoint = Vector2.new(0.5, 0.5)
		label.Position = UDim2.fromScale(0.5, y)
		label.Rotation = tilt
		label.ZIndex = 33
		UiKit.gradient(label, from, to)
		UiKit.stroke(label, C.outline, 6)
	end
	word("Brainrot", "BRAINROT", 0.3, 0.42, -5, C.lime, C.gold)
	word("Rush", "RUSH", 0.74, 0.46, 3, C.pink, C.outlineLight)

	local tagline = UiKit.text(title, "Tagline", UDim2.fromScale(0.7, 0.05), Strings.TitleTagline, 28, C.mute, UiKit.Fonts.body)
	tagline.AnchorPoint = Vector2.new(0.5, 0.5)
	tagline.Position = UDim2.fromScale(0.5, 0.72)
	tagline.ZIndex = 33

	local tap = UiKit.text(title, "Tap", UDim2.fromScale(0.6, 0.06), Strings.TapToStart, 34)
	tap.AnchorPoint = Vector2.new(0.5, 0.5)
	tap.Position = UDim2.fromScale(0.5, 0.86)
	tap.ZIndex = 33
	return title, logo, tap
end

local function buildLobby(gui: ScreenGui, handlers: Handlers)
	local lobby = screenFrame(gui, "Lobby")

	-- Aviso da fila da corrida, no topo
	local matchBanner = UiKit.frame(lobby, "Match", UDim2.fromScale(0.56, 0.075), UDim2.fromScale(0.5, 0.02), Vector2.new(0.5, 0))
	matchBanner.BackgroundTransparency = 0.15
	matchBanner.BackgroundColor3 = C.grape
	UiKit.corner(matchBanner, 0.5)
	UiKit.stroke(matchBanner, C.gold, 3, true)
	sizeLimits(matchBanner, Vector2.new(280, 36), Vector2.new(760, 60))
	local matchLabel = UiKit.text(matchBanner, "Text", UDim2.fromScale(0.94, 0.7), "", 28)
	matchLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	matchLabel.Position = UDim2.fromScale(0.5, 0.5)

	-- Cartão de preparo, à direita (deixa a esquerda livre para o analógico no celular)
	local cardPosition = UDim2.fromScale(0.985, 0.52)
	local card = UiKit.panel(lobby, "Card", UDim2.fromScale(0.27, 0.6), cardPosition, Vector2.new(1, 0.5))
	sizeLimits(card, Vector2.new(230, 290), Vector2.new(360, 470))
	UiKit.scroll(card, Strings.Title)
	local body = UiKit.frame(card, "Body", UDim2.fromScale(0.88, 0.82), UDim2.fromScale(0.5, 0.56), Vector2.new(0.5, 0.5))
	UiKit.list(body, 0.02)
	caption(body, Strings.HeroLabel, 1)
	local heroLabel = selector(body, "Hero", 2, handlers.cycleHero)
	local rarityLabel = UiKit.text(body, "Rarity", UDim2.fromScale(1, 0.07), "", 22, C.mute)
	rarityLabel.LayoutOrder = 3
	UiKit.stroke(rarityLabel, C.grape, 2)
	caption(body, Strings.ChapterLabel, 4)
	local chapterLabel = selector(body, "Chapter", 5, handlers.cycleChapter)
	UiKit.button(body, "Solo", UDim2.fromScale(1, 0.19), Strings.Solo, "Pink", handlers.solo).LayoutOrder = 6
	local statusLabel = UiKit.text(body, "Status", UDim2.fromScale(1, 0.08), "", 18, C.red, UiKit.Fonts.body)
	statusLabel.LayoutOrder = 7

	return lobby, card, cardPosition, heroLabel, rarityLabel, chapterLabel, statusLabel, matchBanner, matchLabel
end

function Hud.new(handlers: Handlers): Hud
	local player = Players.LocalPlayer
	local gui = Instance.new("ScreenGui")
	gui.Name = "BrainrotRushHud"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = false
	gui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local title, logo, tapLabel = buildTitle(gui)
	local lobby, card, cardPosition, heroLabel, rarityLabel, chapterLabel, statusLabel, matchBanner, matchLabel =
		buildLobby(gui, handlers)

	-- HUD da corrida -------------------------------------------------------------------
	local run = screenFrame(gui, "Run")
	local coinsLabel = UiKit.pill(run, "Coins", UDim2.fromScale(0.2, 0.08), UDim2.fromScale(0.015, 0.02), Vector2.zero, "Coin")
	sizeLimits(coinsLabel.Parent :: Frame, Vector2.new(120, 38), Vector2.new(260, 64))
	local distanceLabel =
		UiKit.pill(run, "Distance", UDim2.fromScale(0.2, 0.08), UDim2.fromScale(0.985, 0.02), Vector2.new(1, 0), "Speed")
	sizeLimits(distanceLabel.Parent :: Frame, Vector2.new(120, 38), Vector2.new(260, 64))

	local effectsLabel = UiKit.text(run, "Effects", UDim2.fromScale(0.4, 0.05), "", 24)
	effectsLabel.Position = UDim2.fromScale(0.02, 0.12)
	effectsLabel.TextXAlignment = Enum.TextXAlignment.Left

	local banner = UiKit.text(run, "Banner", UDim2.fromScale(0.8, 0.1), "", 56)
	banner.AnchorPoint = Vector2.new(0.5, 0.5)
	banner.Position = UDim2.fromScale(0.5, 0.24)
	banner.Visible = false
	UiKit.gradient(banner, C.white, C.gold)

	local countdown = UiKit.text(run, "Countdown", UDim2.fromScale(0.5, 0.26), "", 140, C.gold)
	countdown.AnchorPoint = Vector2.new(0.5, 0.5)
	countdown.Position = UDim2.fromScale(0.5, 0.42)
	UiKit.stroke(countdown, C.grape, 6)
	UiKit.gradient(countdown, C.gold, C.pink)
	countdown.Visible = false

	local spectating = UiKit.text(run, "Spectating", UDim2.fromScale(0.6, 0.06), "", 30)
	spectating.AnchorPoint = Vector2.new(0.5, 1)
	spectating.Position = UDim2.fromScale(0.5, 0.96)
	spectating.Visible = false

	local abilityButton = UiKit.button(run, "Ability", UDim2.fromScale(0.15, 0.15), Strings.Ability, "Pink", handlers.ability)
	abilityButton.AnchorPoint = Vector2.new(1, 1)
	abilityButton.Position = UDim2.fromScale(0.97, 0.95)
	UiKit.aspect(abilityButton, 1)
	UiKit.corner(abilityButton, 0.5)

	-- Barra de caos (embaixo das moedas) e botão do modo brainrot (acima do PODER)
	local energy = UiKit.frame(run, "Energy", UDim2.fromScale(0.2, 0.03), UDim2.fromScale(0.015, 0.115), Vector2.zero)
	energy.BackgroundTransparency = 0.2
	energy.BackgroundColor3 = C.grape
	UiKit.corner(energy, 0.5)
	UiKit.stroke(energy, C.gold, 2, true)
	sizeLimits(energy, Vector2.new(120, 12), Vector2.new(260, 22))
	local energyFill = UiKit.shape(energy, "Fill", UDim2.fromScale(0, 1), UDim2.fromScale(0, 0.5), C.lime, 0.5)
	energyFill.AnchorPoint = Vector2.new(0, 0.5)
	UiKit.gradient(energyFill, C.lime, C.pink, 0)
	local energyLabel = UiKit.text(energy, "Label", UDim2.fromScale(1, 0.9), Strings.Energy, 14)
	energyLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	energyLabel.Position = UDim2.fromScale(0.5, 0.5)
	energyLabel.ZIndex = 2

	local transformButton = UiKit.button(run, "Transform", UDim2.fromScale(0.15, 0.09), Strings.Transform, "Gold", handlers.transform)
	transformButton.AnchorPoint = Vector2.new(1, 1)
	transformButton.Position = UDim2.fromScale(0.97, 0.78)
	sizeLimits(transformButton, Vector2.new(110, 40), Vector2.new(220, 70))

	-- Placar ao vivo dos rivais (bom para streamers)
	local standings = UiKit.frame(run, "Standings", UDim2.fromScale(0.22, 0.34), UDim2.fromScale(0.985, 0.12), Vector2.new(1, 0))
	standings.BackgroundTransparency = 0.25
	standings.BackgroundColor3 = C.grape
	UiKit.corner(standings, 0.08)
	UiKit.stroke(standings, C.gold, 2, true)
	UiKit.padding(standings, 0.04)
	UiKit.list(standings, 0.01)
	sizeLimits(standings, Vector2.new(150, 120), Vector2.new(300, 300))
	local standingRows: { TextLabel } = {}
	for i = 1, MAX_STANDINGS do
		local row = UiKit.text(standings, `Row{i}`, UDim2.fromScale(1, 1 / MAX_STANDINGS - 0.01), "", 20, C.white, UiKit.Fonts.body)
		row.TextXAlignment = Enum.TextXAlignment.Left
		row.LayoutOrder = i
		standingRows[i] = row
	end
	standings.Visible = false

	-- Fim de corrida solo --------------------------------------------------------------
	local results = screenFrame(gui, "Results")
	local resultsPosition = UDim2.fromScale(0.5, 0.54)
	local resultsPanel = UiKit.panel(results, "Panel", UDim2.fromScale(0.42, 0.66), resultsPosition, Vector2.new(0.5, 0.5))
	sizeLimits(resultsPanel, Vector2.new(280, 300), Vector2.new(520, 480))
	UiKit.scroll(resultsPanel, Strings.ResultsTitle)
	local resultsBody = UiKit.frame(resultsPanel, "Body", UDim2.fromScale(0.86, 0.82), UDim2.fromScale(0.5, 0.56), Vector2.new(0.5, 0.5))
	UiKit.list(resultsBody, 0.03)
	local resultLabels: { TextLabel } = {}
	for i = 1, 4 do
		local line = UiKit.text(resultsBody, `Line{i}`, UDim2.fromScale(1, 0.12), "", 32, if i == 1 then C.gold else C.white)
		line.LayoutOrder = i
		resultLabels[i] = line
	end
	UiKit.button(resultsBody, "Again", UDim2.fromScale(1, 0.2), Strings.RunAgain, "Pink", handlers.again).LayoutOrder = 10
	UiKit.button(resultsBody, "Village", UDim2.fromScale(0.7, 0.13), Strings.BackToVillage, "Dark", handlers.village).LayoutOrder =
		11

	-- Ranking da corrida ---------------------------------------------------------------
	local raceResults = screenFrame(gui, "RaceResults")
	local racePosition = UDim2.fromScale(0.5, 0.54)
	local racePanel = UiKit.panel(raceResults, "Panel", UDim2.fromScale(0.44, 0.78), racePosition, Vector2.new(0.5, 0.5))
	sizeLimits(racePanel, Vector2.new(290, 340), Vector2.new(540, 560))
	UiKit.scroll(racePanel, Strings.RaceTitle)
	local raceBody = UiKit.frame(racePanel, "Body", UDim2.fromScale(0.86, 0.84), UDim2.fromScale(0.5, 0.56), Vector2.new(0.5, 0.5))
	UiKit.list(raceBody, 0.012)
	local raceRows: { TextLabel } = {}
	for i = 1, MAX_STANDINGS do
		local row = UiKit.text(raceBody, `Place{i}`, UDim2.fromScale(1, 0.07), "", 26, C.white)
		row.LayoutOrder = i
		raceRows[i] = row
	end
	local raceCoins = UiKit.text(raceBody, "Coins", UDim2.fromScale(1, 0.07), "", 24, C.gold, UiKit.Fonts.body)
	raceCoins.LayoutOrder = 20
	UiKit.button(raceBody, "Village", UDim2.fromScale(1, 0.13), Strings.BackToVillage, "Pink", handlers.village).LayoutOrder = 21
	UiKit.button(raceBody, "Solo", UDim2.fromScale(0.7, 0.1), Strings.Solo, "Dark", handlers.solo).LayoutOrder = 22

	-- Faixa de adesivo que atravessa a tela entre as fases ---------------------------------
	local page = UiKit.frame(gui, "PageTurn", UDim2.fromScale(1.1, 0.5), UDim2.fromScale(1.9, 0.5), Vector2.new(0.5, 0.5))
	page.BackgroundTransparency = 0
	page.BackgroundColor3 = C.paper
	page.ZIndex = 20
	UiKit.stroke(page, C.outline, 8, true)
	UiKit.gradient(page, C.paper, C.paperDark)
	local pageBand = UiKit.shape(page, "Band", UDim2.fromScale(1, 0.06), UDim2.fromScale(0.5, 0.82), C.pink)
	pageBand.ZIndex = 21
	local pageLabel = UiKit.text(page, "Chapter", UDim2.fromScale(0.7, 0.36), "", 72, C.ink)
	pageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	pageLabel.Position = UDim2.fromScale(0.5, 0.45)
	pageLabel.ZIndex = 21
	page.Visible = false

	gui.Parent = player:WaitForChild("PlayerGui")

	local self: HudData = {
		gui = gui,
		screens = { Title = title, Lobby = lobby, Run = run, Results = results, RaceResults = raceResults },
		slides = {
			Lobby = { frame = card, target = cardPosition },
			Results = { frame = resultsPanel, target = resultsPosition },
			RaceResults = { frame = racePanel, target = racePosition },
		},
		heroLabel = heroLabel,
		rarityLabel = rarityLabel,
		chapterLabel = chapterLabel,
		statusLabel = statusLabel,
		matchBanner = matchBanner,
		matchLabel = matchLabel,
		coinsLabel = coinsLabel,
		distanceLabel = distanceLabel,
		effectsLabel = effectsLabel,
		banner = banner,
		abilityButton = abilityButton,
		energyFill = energyFill,
		transformButton = transformButton,
		transformPulse = nil,
		countdown = countdown,
		spectating = spectating,
		standings = standings,
		standingRows = standingRows,
		page = page,
		pageLabel = pageLabel,
		resultLabels = resultLabels,
		raceRows = raceRows,
		raceCoins = raceCoins,
		logo = logo,
		tapLabel = tapLabel,
		cache = {},
		flashToken = 0,
	}
	return setmetatable(self, Hud)
end

-- Só troca o texto quando muda (evita retrabalho de layout a cada quadro)
function Hud._setText(self: Hud, target: TextLabel | TextButton, text: string)
	if self.cache[target] ~= text then
		self.cache[target] = text
		target.Text = text
	end
end

function Hud.showScreen(self: Hud, screen: Screen)
	for name, frame in self.screens do
		frame.Visible = name == screen
	end
	local slide = self.slides[screen]
	if slide then
		UiKit.slideIn(slide.frame, slide.target)
	end
	if screen ~= "Run" then
		self.banner.Visible = false
		self.countdown.Visible = false
		self.spectating.Visible = false
	end
end

-- Tela de entrada com o logo; chama onDone ao tocar ou depois de alguns segundos
function Hud.showTitle(self: Hud, onDone: () -> ())
	local title = self.screens.Title
	title.Visible = true
	local logo = self.logo
	local target = logo.Position
	logo.Position = target - UDim2.fromScale(0.6, 0)
	logo.Rotation = -8
	TweenService:Create(logo, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = target, Rotation = 0 })
		:Play()
	local pulse = TweenService:Create(
		self.tapLabel,
		TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
		{ TextTransparency = 0.6 }
	)
	pulse:Play()

	local finished = false
	local function finish()
		if finished then
			return
		end
		finished = true
		pulse:Cancel()
		local fade = TweenService:Create(title, TweenInfo.new(Ui.TweenSeconds), { BackgroundTransparency = 1 })
		fade.Completed:Once(function()
			title.Visible = false
			title.BackgroundTransparency = 0
			onDone()
		end)
		self.logo.Visible = false
		fade:Play()
	end
	title.InputBegan:Connect(function(input: InputObject)
		local kind = input.UserInputType
		if kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch then
			finish()
		end
	end)
	task.delay(Ui.TitleSeconds, finish)
end

function Hud.setSelection(self: Hud, heroName: string, rarityName: string, rarityColor: Color3, chapterName: string)
	self:_setText(self.heroLabel, heroName)
	self:_setText(self.rarityLabel, rarityName)
	self.rarityLabel.TextColor3 = rarityColor
	self:_setText(self.chapterLabel, chapterName)
end

function Hud.setStatus(self: Hud, text: string)
	self:_setText(self.statusLabel, text)
end

function Hud.setMatch(self: Hud, text: string, hot: boolean)
	self:_setText(self.matchLabel, text)
	self.matchBanner.BackgroundColor3 = if hot then C.pinkDark else C.grape
end

function Hud.setCoins(self: Hud, coins: number)
	self:_setText(self.coinsLabel, tostring(coins))
end

function Hud.setDistance(self: Hud, meters: number)
	self:_setText(self.distanceLabel, string.format(Strings.Meters, meters))
end

function Hud.setEffects(self: Hud, text: string)
	self:_setText(self.effectsLabel, text)
end

-- cooldown < 0 = personagem sem habilidade ativa
function Hud.setAbility(self: Hud, cooldown: number)
	local button = self.abilityButton
	button.Visible = cooldown >= 0
	if cooldown > 0 then
		self:_setText(button, tostring(math.ceil(cooldown)))
		button.TextTransparency = 0.3
	else
		self:_setText(button, Strings.Ability)
		button.TextTransparency = 0
	end
end

-- fraction 0..1; com a barra cheia o botão MODO BRAINROT acende e pulsa
function Hud.setEnergy(self: Hud, fraction: number, transformed: boolean)
	self.energyFill.Size = UDim2.fromScale(math.clamp(fraction, 0, 1), 1)
	local ready = fraction >= 1 and not transformed
	local button = self.transformButton
	button.Visible = ready or transformed or fraction > 0
	button.TextTransparency = if ready then 0 else 0.55
	button.BackgroundTransparency = if ready then 0 else 0.5
	if ready and not self.transformPulse then
		local pulse = TweenService:Create(
			button,
			TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
			{ Rotation = 4 }
		)
		pulse:Play()
		self.transformPulse = pulse
	elseif not ready and self.transformPulse then
		self.transformPulse:Cancel()
		self.transformPulse = nil
		button.Rotation = 0
	end
end

-- Contagem 3, 2, 1, JÁ! (nil esconde)
function Hud.setCountdown(self: Hud, text: string?)
	if text == nil then
		self.countdown.Visible = false
		return
	end
	if self.cache[self.countdown] ~= text then
		self:_setText(self.countdown, text)
		self.countdown.Visible = true
		self.countdown.Size = UDim2.fromScale(0.75, 0.38)
		TweenService:Create(self.countdown, TweenInfo.new(0.25, Enum.EasingStyle.Back), { Size = UDim2.fromScale(0.5, 0.26) })
			:Play()
	end
end

function Hud.setSpectating(self: Hud, text: string?)
	self.spectating.Visible = text ~= nil
	if text then
		self:_setText(self.spectating, text)
	end
end

function Hud.setStandings(self: Hud, rows: { StandingRow }?)
	if rows == nil then
		self.standings.Visible = false
		return
	end
	self.standings.Visible = true
	for i, label in self.standingRows do
		local row = rows[i]
		if row then
			local name = if row.isYou then Strings.You else row.name
			self:_setText(label, `{i}. {name}  {row.meters} m`)
			label.TextColor3 = if row.isYou then C.gold elseif row.alive then C.white else C.mute
			label.Visible = true
		else
			label.Visible = false
		end
	end
end

function Hud.flash(self: Hud, text: string)
	self.flashToken += 1
	local token = self.flashToken
	self.banner.Text = text
	self.banner.Visible = true
	self.banner.Size = UDim2.fromScale(0.95, 0.13)
	TweenService:Create(self.banner, TweenInfo.new(0.2, Enum.EasingStyle.Back), { Size = UDim2.fromScale(0.8, 0.1) }):Play()
	task.delay(Ui.FlashSeconds, function()
		if self.flashToken == token then
			self.banner.Visible = false
		end
	end)
end

function Hud.pageTurn(self: Hud, chapterText: string)
	local page = self.page
	self.pageLabel.Text = chapterText
	page.Position = UDim2.fromScale(1.9, 0.5)
	page.Rotation = 8
	page.Visible = true
	local half = Ui.PageTurnSeconds / 2
	local inTween = TweenService:Create(
		page,
		TweenInfo.new(half, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Position = UDim2.fromScale(0.5, 0.5), Rotation = 0 }
	)
	local outTween = TweenService:Create(
		page,
		TweenInfo.new(half, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{ Position = UDim2.fromScale(-0.9, 0.5), Rotation = -8 }
	)
	inTween.Completed:Once(function()
		task.wait(0.25)
		outTween:Play()
	end)
	outTween.Completed:Once(function()
		page.Visible = false
	end)
	inTween:Play()
end

function Hud.showResults(self: Hud, result: Types.RunResult)
	local lines = self.resultLabels
	lines[1].Text = if result.newBest then Strings.NewBest else string.format(Strings.ResultBest, result.bestMeters)
	lines[2].Text = string.format(Strings.ResultDistance, result.meters)
	lines[3].Text = string.format(Strings.ResultCoins, result.coins)
	lines[4].Text = string.format(Strings.ResultTotal, result.totalCoins)
	self:showScreen("Results")
end

function Hud.showRaceResults(self: Hud, results: Types.RaceResults, myUserId: number, coins: number)
	for i, label in self.raceRows do
		local standing = results.ranking[i]
		if standing then
			local name = if standing.userId == myUserId then Strings.You else standing.name
			label.Text = string.format(Strings.RacePlace, standing.place, name, standing.meters)
			label.TextColor3 = if standing.userId == myUserId then C.pink elseif i == 1 then C.gold else C.white
			label.Visible = true
		else
			label.Visible = false
		end
	end
	self.raceCoins.Text = string.format(Strings.RaceCoins, coins)
	self:showScreen("RaceResults")
end

return Hud
