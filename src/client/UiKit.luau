--!strict
-- Componentes visuais da interface (estilo "Anime Racers": azul-noite, laranja energia, dourado,
-- pergaminho ninja nos títulos). Layout por escala; textos com tamanho máximo para telas grandes.
-- Fontes por FontFace; ícones desenhados com frames (iguais em todo aparelho, sem emoji nem upload).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)

local Ui = GameConfig.Ui

local UiKit = {}

UiKit.Colors = {
	night = Color3.fromRGB(22, 24, 48),
	nightLight = Color3.fromRGB(44, 48, 92),
	orange = Color3.fromRGB(255, 136, 30),
	orangeDark = Color3.fromRGB(190, 80, 10),
	gold = Color3.fromRGB(255, 205, 60),
	goldDark = Color3.fromRGB(180, 120, 20),
	red = Color3.fromRGB(225, 50, 60),
	redDark = Color3.fromRGB(130, 20, 32),
	green = Color3.fromRGB(60, 200, 110),
	greenDark = Color3.fromRGB(25, 110, 60),
	cyan = Color3.fromRGB(90, 220, 255),
	parchment = Color3.fromRGB(250, 236, 200),
	parchmentDark = Color3.fromRGB(226, 200, 150),
	wood = Color3.fromRGB(120, 72, 40),
	woodDark = Color3.fromRGB(70, 40, 24),
	ink = Color3.fromRGB(50, 30, 30),
	white = Color3.fromRGB(255, 255, 255),
	mute = Color3.fromRGB(160, 165, 190),
}

UiKit.Fonts = {
	title = Font.new("rbxasset://fonts/families/LuckiestGuy.json", Enum.FontWeight.Regular),
	body = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold),
	bodyHeavy = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.ExtraBold),
}

local C = UiKit.Colors

function UiKit.corner(parent: Instance, scale: number?)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(scale or 0.18, 0)
	corner.Parent = parent
end

function UiKit.stroke(parent: Instance, color: Color3, thickness: number, border: boolean?): UIStroke
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness
	stroke.ApplyStrokeMode = if border then Enum.ApplyStrokeMode.Border else Enum.ApplyStrokeMode.Contextual
	stroke.Parent = parent
	return stroke
end

function UiKit.gradient(parent: Instance, top: Color3, bottom: Color3, rotation: number?): UIGradient
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new(top, bottom)
	gradient.Rotation = rotation or 90
	gradient.Parent = parent
	return gradient
end

function UiKit.maxText(parent: Instance, size: number)
	local constraint = Instance.new("UITextSizeConstraint")
	constraint.MaxTextSize = size
	constraint.MinTextSize = 10
	constraint.Parent = parent
end

function UiKit.aspect(parent: Instance, ratio: number)
	local constraint = Instance.new("UIAspectRatioConstraint")
	constraint.AspectRatio = ratio
	constraint.Parent = parent
end

function UiKit.padding(parent: Instance, scale: number)
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(scale, 0)
	padding.PaddingBottom = UDim.new(scale, 0)
	padding.PaddingLeft = UDim.new(scale, 0)
	padding.PaddingRight = UDim.new(scale, 0)
	padding.Parent = parent
end

function UiKit.list(parent: Instance, gap: number, horizontal: boolean?): UIListLayout
	local list = Instance.new("UIListLayout")
	list.FillDirection = if horizontal then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical
	list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	list.VerticalAlignment = Enum.VerticalAlignment.Center
	list.Padding = UDim.new(gap, 0)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = parent
	return list
end

function UiKit.frame(parent: Instance, name: string, size: UDim2, position: UDim2?, anchor: Vector2?): Frame
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = size
	frame.Position = position or UDim2.new()
	frame.AnchorPoint = anchor or Vector2.zero
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	return frame
end

-- Bloco sólido (usado para desenhar ícones e enfeites)
function UiKit.shape(parent: Instance, name: string, size: UDim2, position: UDim2, color: Color3, round: number?): Frame
	local frame = UiKit.frame(parent, name, size, position, Vector2.new(0.5, 0.5))
	frame.BackgroundTransparency = 0
	frame.BackgroundColor3 = color
	frame.BorderSizePixel = 0
	if round then
		UiKit.corner(frame, round)
	end
	return frame
end

-- Texto branco com contorno escuro (legível sobre qualquer cenário)
function UiKit.text(parent: Instance, name: string, size: UDim2, text: string, maxSize: number, color: Color3?, font: Font?): TextLabel
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = size
	label.BackgroundTransparency = 1
	label.FontFace = font or UiKit.Fonts.title
	label.Text = text
	label.TextColor3 = color or C.white
	label.TextScaled = true
	label.TextWrapped = true
	label.Parent = parent
	UiKit.maxText(label, maxSize)
	if color == nil then
		UiKit.stroke(label, C.night, 2.5)
	end
	return label
end

-- Painel azul-noite com borda dourada
function UiKit.panel(parent: Instance, name: string, size: UDim2, position: UDim2, anchor: Vector2): Frame
	local panel = UiKit.frame(parent, name, size, position, anchor)
	panel.BackgroundTransparency = 0.05
	panel.BackgroundColor3 = C.night
	UiKit.corner(panel, 0.06)
	UiKit.stroke(panel, C.gold, 3, true)
	UiKit.gradient(panel, C.nightLight, C.night)
	return panel
end

-- Pergaminho ninja de título preso no topo de um painel: papel no meio e rolos de madeira nas pontas
function UiKit.scroll(panel: Frame, text: string)
	local scroll = UiKit.frame(panel, "Scroll", UDim2.fromScale(0.86, 0.15), UDim2.fromScale(0.5, 0), Vector2.new(0.5, 0.55))
	scroll.ZIndex = 3

	local paper = UiKit.shape(scroll, "Paper", UDim2.fromScale(0.86, 0.82), UDim2.fromScale(0.5, 0.5), C.parchment, 0.08)
	paper.ZIndex = 3
	UiKit.gradient(paper, C.parchment, C.parchmentDark)
	UiKit.stroke(paper, C.woodDark, 2, true)
	local band = UiKit.shape(paper, "Band", UDim2.fromScale(1, 0.12), UDim2.fromScale(0.5, 0.86), C.red)
	band.ZIndex = 4

	for _, side in { 0, 1 } do
		local rod = UiKit.shape(scroll, `Rod{side}`, UDim2.fromScale(0.09, 1), UDim2.fromScale(0.05 + side * 0.9, 0.5), C.wood, 0.5)
		rod.ZIndex = 4
		UiKit.gradient(rod, C.wood, C.woodDark, 0)
		UiKit.stroke(rod, C.woodDark, 2, true)
		local knob = UiKit.shape(scroll, `Knob{side}`, UDim2.fromScale(0.05, 0.3), UDim2.fromScale(0.05 + side * 0.9, 0.5), C.gold, 0.5)
		knob.ZIndex = 5
	end

	local label = UiKit.text(paper, "Title", UDim2.fromScale(0.9, 0.72), text, 40, C.ink)
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.fromScale(0.5, 0.45)
	label.ZIndex = 5
end

-- Animações de toque: cresce ao passar o mouse, encolhe ao apertar (UIScale + TweenService)
function UiKit.pressable(button: GuiButton)
	local scale = Instance.new("UIScale")
	scale.Parent = button
	local info = TweenInfo.new(Ui.TweenSeconds * 0.5, Enum.EasingStyle.Back)
	local function to(value: number)
		TweenService:Create(scale, info, { Scale = value }):Play()
	end
	button.MouseEnter:Connect(function()
		to(Ui.HoverScale)
	end)
	button.MouseLeave:Connect(function()
		to(1)
	end)
	button.MouseButton1Down:Connect(function()
		to(Ui.PressScale)
	end)
	button.MouseButton1Up:Connect(function()
		to(1)
	end)
	button.TouchTap:Connect(function()
		scale.Scale = Ui.PressScale
		to(1)
	end)
end

export type ButtonStyle = "Orange" | "Green" | "Red" | "Gold" | "Dark"

local STYLES: { [ButtonStyle]: { top: Color3, bottom: Color3, stroke: Color3, text: Color3 } } = {
	Orange = { top = Color3.fromRGB(255, 175, 70), bottom = C.orange, stroke = C.orangeDark, text = C.white },
	Green = { top = Color3.fromRGB(110, 230, 140), bottom = C.green, stroke = C.greenDark, text = C.white },
	Red = { top = Color3.fromRGB(245, 95, 100), bottom = C.red, stroke = C.redDark, text = C.white },
	Gold = { top = Color3.fromRGB(255, 230, 120), bottom = C.gold, stroke = C.goldDark, text = C.ink },
	Dark = { top = C.nightLight, bottom = C.night, stroke = C.gold, text = C.white },
}

local clickSound: Sound? = nil

-- Som de clique compartilhado por todos os botões
function UiKit.setClickSound(sound: Sound)
	clickSound = sound
end

function UiKit.button(parent: Instance, name: string, size: UDim2, text: string, style: ButtonStyle, onClick: () -> ()): TextButton
	local look = STYLES[style]
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = size
	button.BackgroundColor3 = C.white
	button.AutoButtonColor = false
	button.FontFace = UiKit.Fonts.title
	button.Text = text
	button.TextColor3 = look.text
	button.TextScaled = true
	button.Parent = parent
	UiKit.corner(button, 0.25)
	UiKit.stroke(button, look.stroke, 3, true)
	UiKit.gradient(button, look.top, look.bottom)
	UiKit.maxText(button, 36)
	if look.text == C.white then
		UiKit.stroke(button, look.stroke, 1.5)
	end
	local inner = Instance.new("UIPadding")
	inner.PaddingTop = UDim.new(0.18, 0)
	inner.PaddingBottom = UDim.new(0.18, 0)
	inner.PaddingLeft = UDim.new(0.06, 0)
	inner.PaddingRight = UDim.new(0.06, 0)
	inner.Parent = button
	UiKit.pressable(button)
	button.Activated:Connect(function()
		if clickSound then
			clickSound:Play()
		end
		onClick()
	end)
	return button
end

-- Ícones desenhados ---------------------------------------------------------------------

-- Moeda dourada com aro e brilho
function UiKit.coinIcon(parent: Instance): Frame
	local holder = UiKit.frame(parent, "CoinIcon", UDim2.fromScale(1, 1))
	UiKit.aspect(holder, 1)
	local outer = UiKit.shape(holder, "Rim", UDim2.fromScale(0.92, 0.92), UDim2.fromScale(0.5, 0.5), C.goldDark, 0.5)
	local face = UiKit.shape(outer, "Face", UDim2.fromScale(0.78, 0.78), UDim2.fromScale(0.5, 0.5), C.gold, 0.5)
	UiKit.gradient(face, Color3.fromRGB(255, 240, 150), C.gold)
	UiKit.shape(face, "Mark", UDim2.fromScale(0.18, 0.5), UDim2.fromScale(0.5, 0.5), C.goldDark, 0.4)
	UiKit.shape(face, "Shine", UDim2.fromScale(0.22, 0.22), UDim2.fromScale(0.3, 0.28), C.white, 0.5).BackgroundTransparency = 0.3
	return holder
end

-- Distância: três setas de velocidade
function UiKit.speedIcon(parent: Instance): Frame
	local holder = UiKit.frame(parent, "SpeedIcon", UDim2.fromScale(1, 1))
	UiKit.aspect(holder, 1)
	for i = 0, 2 do
		local x = 0.25 + i * 0.25
		local color = if i == 2 then C.orange else C.cyan
		local top = UiKit.shape(holder, `ArrowTop{i}`, UDim2.fromScale(0.36, 0.12), UDim2.fromScale(x, 0.38), color, 0.5)
		top.Rotation = 40
		local bottom = UiKit.shape(holder, `ArrowBottom{i}`, UDim2.fromScale(0.36, 0.12), UDim2.fromScale(x, 0.62), color, 0.5)
		bottom.Rotation = -40
	end
	return holder
end

-- "Pílula" escura do HUD (moedas, distância) com ícone desenhado à esquerda
function UiKit.pill(parent: Instance, name: string, size: UDim2, position: UDim2, anchor: Vector2, icon: "Coin" | "Speed"): TextLabel
	local pill = UiKit.frame(parent, name, size, position, anchor)
	pill.BackgroundTransparency = 0.15
	pill.BackgroundColor3 = C.night
	UiKit.corner(pill, 0.5)
	UiKit.stroke(pill, C.gold, 3, true)

	local iconSlot = UiKit.frame(pill, "Icon", UDim2.fromScale(0.3, 0.8), UDim2.fromScale(0.04, 0.5), Vector2.new(0, 0.5))
	if icon == "Coin" then
		UiKit.coinIcon(iconSlot)
	else
		UiKit.speedIcon(iconSlot)
	end

	local value = UiKit.text(pill, "Value", UDim2.fromScale(0.62, 0.72), "0", 40, C.white)
	value.AnchorPoint = Vector2.new(1, 0.5)
	value.Position = UDim2.fromScale(0.94, 0.5)
	value.TextXAlignment = Enum.TextXAlignment.Right
	return value
end

-- Entrada de tela: desliza de baixo até a posição final do painel
function UiKit.slideIn(frame: GuiObject, target: UDim2)
	frame.Position = target + UDim2.fromScale(0, 0.08)
	TweenService:Create(frame, TweenInfo.new(Ui.TweenSeconds, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = target })
		:Play()
end

return UiKit
