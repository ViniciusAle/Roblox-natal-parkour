--!strict
-- Componentes visuais da interface (estilo "Brainrot Rush": roxo-uva, rosa-choque, verde-limão, amarelo,
-- adesivos tortos de contorno grosso nos títulos). Layout por escala; textos com tamanho máximo para telas grandes.
-- Fontes por FontFace; ícones desenhados com frames (iguais em todo aparelho, sem emoji nem upload).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)

local Ui = GameConfig.Ui

local UiKit = {}

UiKit.Colors = {
	grape = Color3.fromRGB(42, 18, 72),
	grapeLight = Color3.fromRGB(96, 40, 150),
	pink = Color3.fromRGB(255, 70, 160),
	pinkDark = Color3.fromRGB(160, 20, 95),
	gold = Color3.fromRGB(255, 220, 50),
	goldDark = Color3.fromRGB(190, 130, 10),
	red = Color3.fromRGB(225, 50, 60),
	redDark = Color3.fromRGB(130, 20, 32),
	green = Color3.fromRGB(60, 200, 110),
	greenDark = Color3.fromRGB(25, 110, 60),
	lime = Color3.fromRGB(170, 255, 60),
	paper = Color3.fromRGB(255, 240, 90),
	paperDark = Color3.fromRGB(255, 196, 40),
	outlineLight = Color3.fromRGB(255, 120, 190),
	outline = Color3.fromRGB(20, 8, 34),
	ink = Color3.fromRGB(30, 10, 50),
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
		UiKit.stroke(label, C.grape, 2.5)
	end
	return label
end

-- Painel roxo-uva com borda amarela
function UiKit.panel(parent: Instance, name: string, size: UDim2, position: UDim2, anchor: Vector2): Frame
	local panel = UiKit.frame(parent, name, size, position, anchor)
	panel.BackgroundTransparency = 0.05
	panel.BackgroundColor3 = C.grape
	UiKit.corner(panel, 0.06)
	UiKit.stroke(panel, C.gold, 3, true)
	UiKit.gradient(panel, C.grapeLight, C.grape)
	return panel
end

-- Adesivo de título preso no topo de um painel: faixa amarela torta, contorno grosso e sombra rosa
function UiKit.scroll(panel: Frame, text: string)
	local sticker = UiKit.frame(panel, "Sticker", UDim2.fromScale(0.8, 0.14), UDim2.fromScale(0.5, 0), Vector2.new(0.5, 0.55))
	sticker.ZIndex = 3
	sticker.Rotation = -3

	local shadow = UiKit.shape(sticker, "Shadow", UDim2.fromScale(1, 1), UDim2.new(0.5, 6, 0.5, 6), C.pink, 0.25)
	shadow.ZIndex = 3
	local paper = UiKit.shape(sticker, "Paper", UDim2.fromScale(1, 1), UDim2.fromScale(0.5, 0.5), C.paper, 0.25)
	paper.ZIndex = 4
	UiKit.gradient(paper, C.paper, C.paperDark)
	UiKit.stroke(paper, C.outline, 4, true)

	-- Estrelinhas nas pontas
	for _, side in { 0, 1 } do
		local star = UiKit.shape(sticker, `Star{side}`, UDim2.fromScale(0.07, 0.45), UDim2.fromScale(0.02 + side * 0.96, 0.15), C.lime)
		star.Rotation = 45
		star.ZIndex = 5
		UiKit.aspect(star, 1)
		UiKit.stroke(star, C.outline, 2, true)
	end

	local label = UiKit.text(paper, "Title", UDim2.fromScale(0.9, 0.78), text, 40, C.ink)
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.fromScale(0.5, 0.5)
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

export type ButtonStyle = "Pink" | "Green" | "Red" | "Gold" | "Dark"

local STYLES: { [ButtonStyle]: { top: Color3, bottom: Color3, stroke: Color3, text: Color3 } } = {
	Pink = { top = Color3.fromRGB(255, 140, 200), bottom = C.pink, stroke = C.pinkDark, text = C.white },
	Green = { top = Color3.fromRGB(110, 230, 140), bottom = C.green, stroke = C.greenDark, text = C.white },
	Red = { top = Color3.fromRGB(245, 95, 100), bottom = C.red, stroke = C.redDark, text = C.white },
	Gold = { top = Color3.fromRGB(255, 230, 120), bottom = C.gold, stroke = C.goldDark, text = C.ink },
	Dark = { top = C.grapeLight, bottom = C.grape, stroke = C.gold, text = C.white },
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
		local color = if i == 2 then C.pink else C.lime
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
	pill.BackgroundColor3 = C.grape
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
