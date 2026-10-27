--!strict
-- Ids de áudio. Vazio = ainda sem som (origem e licença em aberto, GDD seção 19).
-- Ao preencher um id, registrar origem e licença em docs/ASSETS.md.

local Sounds: { [string]: string } = {
	Coin = "",
	Jump = "",
	Land = "",
	Slide = "",
	LaneChange = "",
	Stumble = "",
	Crash = "",
	PowerUp = "",
	ShieldBreak = "",
	Trampoline = "",
	PageTurn = "",
}

return Sounds
