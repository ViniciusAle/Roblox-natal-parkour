--!strict
-- Componentes visuais da interface (estilo "livro de Natal": papel creme, fita vermelha, dourado).
-- Layout por escala; textos com tamanho máximo para não estourar em telas grandes.

local UiKit = {}

UiKit.Colors = {
	paper = Color3.fromRGB(255, 248, 234),
	paperDark = Color3.fromRGB(240, 226, 200),
	ink = Color3.fromRGB(90, 45, 30),
	red = Color3.fromRGB(200, 36, 50),
	redDark = Color3.fromRGB(130, 20, 32),
	green = Color3.fromRGB(46, 160, 80),
	greenDark = Color3.fromRGB(24, 100, 50),
	gold = Color3.fromRGB(250, 196, 50),
	goldDark = Color3.fromRGB(190, 130, 20),
	night = Color3.fromRGB(28, 26, 52),
	white = Color3.fromRGB(255, 255, 255),
}

UiKit.Fonts = {
	title = Enum.Font.FredokaOne,
	body = Enum.Font.GothamBold,
}

local C = UiKit.Colors

function UiKit.corner(parent: Instance, scale: number?)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(scale or 0.18, 0)
	corner.Parent = parent
end

function UiKit.stroke(parent: Instance, color: Color3, thickness: number, border: boolean?)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness
	stroke.ApplyStrokeMode = if border then Enum.ApplyStrokeMode.Border else Enum.ApplyStrokeMode.Contextual
	stroke.Parent = parent
end

function UiKit.gradient(parent: Instance, top: Color3, bottom: Color3)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new(top, bottom)
	gradient.Rotation = 90
	gradient.Parent = parent
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

-- Texto branco com contorno escuro (legível sobre qualquer cenário)
function UiKit.text(parent: Instance, name: string, size: UDim2, text: string, maxSize: number, color: Color3?, font: Enum.Font?): TextLabel
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = size
	label.BackgroundTransparency = 1
	label.Font = font or UiKit.Fonts.title
	label.Text = text
	label.TextColor3 = color or C.white
	label.TextScaled = true
	label.TextWrapped = true
	label.Parent = parent
	UiKit.maxText(label, maxSize)
	if color == nil then
		UiKit.stroke(label, C.redDark, 2)
	end
	return label
end

-- Painel de papel com moldura
function UiKit.panel(parent: Instance, name: string, size: UDim2, position: UDim2, anchor: Vector2): Frame
	local panel = UiKit.frame(parent, name, size, position, anchor)
	panel.BackgroundTransparency = 0
	panel.BackgroundColor3 = C.paper
	UiKit.corner(panel, 0.06)
	UiKit.stroke(panel, C.red, 4, true)
	UiKit.gradient(panel, C.paper, C.paperDark)
	return panel
end

-- Fita vermelha de título, presa no topo de um painel
function UiKit.ribbon(panel: Frame, text: string)
	local ribbon = UiKit.frame(panel, "Ribbon", UDim2.fromScale(0.8, 0.14), UDim2.fromScale(0.5, 0), Vector2.new(0.5, 0.55))
	ribbon.BackgroundTransparency = 0
	ribbon.BackgroundColor3 = C.red
	ribbon.ZIndex = 3
	UiKit.corner(ribbon, 0.3)
	UiKit.stroke(ribbon, C.gold, 3, true)
	UiKit.gradient(ribbon, Color3.fromRGB(235, 70, 80), C.red)
	local label = UiKit.text(ribbon, "Title", UDim2.fromScale(0.92, 0.8), text, 40)
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.fromScale(0.5, 0.5)
	label.ZIndex = 4
end

export type ButtonStyle = "Green" | "Red" | "Gold" | "Paper"

local STYLES: { [ButtonStyle]: { top: Color3, bottom: Color3, stroke: Color3, text: Color3 } } = {
	Green = { top = Color3.fromRGB(80, 200, 110), bottom = C.green, stroke = C.greenDark, text = C.white },
	Red = { top = Color3.fromRGB(240, 80, 90), bottom = C.red, stroke = C.redDark, text = C.white },
	Gold = { top = Color3.fromRGB(255, 225, 110), bottom = C.gold, stroke = C.goldDark, text = C.redDark },
	Paper = { top = C.paper, bottom = C.paperDark, stroke = C.ink, text = C.ink },
}

function UiKit.button(parent: Instance, name: string, size: UDim2, text: string, style: ButtonStyle, onClick: () -> ()): TextButton
	local look = STYLES[style]
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = size
	button.BackgroundColor3 = C.white
	button.AutoButtonColor = true
	button.Font = UiKit.Fonts.title
	button.Text = text
	button.TextColor3 = look.text
	button.TextScaled = true
	button.Parent = parent
	UiKit.corner(button, 0.25)
	UiKit.stroke(button, look.stroke, 3, true)
	UiKit.gradient(button, look.top, look.bottom)
	UiKit.maxText(button, 36)
	local inner = Instance.new("UIPadding")
	inner.PaddingTop = UDim.new(0.18, 0)
	inner.PaddingBottom = UDim.new(0.18, 0)
	inner.PaddingLeft = UDim.new(0.06, 0)
	inner.PaddingRight = UDim.new(0.06, 0)
	inner.Parent = button
	button.Activated:Connect(onClick)
	return button
end

-- "Pílula" escura do HUD (moedas, distância)
function UiKit.pill(parent: Instance, name: string, size: UDim2, position: UDim2, anchor: Vector2, icon: string): TextLabel
	local pill = UiKit.frame(parent, name, size, position, anchor)
	pill.BackgroundTransparency = 0.2
	pill.BackgroundColor3 = C.night
	UiKit.corner(pill, 0.5)
	UiKit.stroke(pill, C.gold, 3, true)

	local iconLabel = UiKit.text(pill, "Icon", UDim2.fromScale(0.28, 0.8), icon, 40, C.white)
	iconLabel.AnchorPoint = Vector2.new(0, 0.5)
	iconLabel.Position = UDim2.fromScale(0.04, 0.5)

	local value = UiKit.text(pill, "Value", UDim2.fromScale(0.64, 0.72), "0", 40, C.white)
	value.AnchorPoint = Vector2.new(1, 0.5)
	value.Position = UDim2.fromScale(0.94, 0.5)
	value.TextXAlignment = Enum.TextXAlignment.Right
	return value
end

return UiKit
