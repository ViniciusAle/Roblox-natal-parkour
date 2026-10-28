--!strict
-- Ids de áudio (Creator Store do Roblox). Vazio = sem som.
-- Origem e licença de cada um em docs/ASSETS.md. Escolhidos pelo nome e descrição: ouvir no Studio e trocar à vontade.

local function id(number: number): string
	return `rbxassetid://{number}`
end

local Sounds = {
	-- Efeitos (pacote gratuito "Daily Sounds", sintetizados pelo autor)
	Effects = {
		Coin = id(130378474223829), -- Coin Pickup
		Jump = id(133564751966469), -- Platformer Jump
		Land = "rbxasset://sounds/action_jump_land.mp3", -- som embutido do Roblox
		Slide = id(89056149423727), -- Swift Swoosh
		LaneChange = id(80984744279155), -- Fast Whoosh
		Stumble = id(106984966606682), -- Cartoon Pop
		Crash = id(94978851787238), -- Deep Impact Boom
		PowerUp = id(82669989135278), -- Power Surge
		ShieldBreak = id(96795857757261), -- Power Down
		Trampoline = id(91645115774690), -- Retro Jump
		PageTurn = id(94077390731779), -- Cinematic Riser (troca de fase)
		UiClick = id(138409154614452), -- Toggle Click
	} :: { [string]: string },

	-- Volume de cada efeito (1 = original)
	Volumes = {
		Coin = 0.5,
		LaneChange = 0.35,
		Slide = 0.5,
		Crash = 0.8,
		UiClick = 0.4,
	} :: { [string]: number },

	-- Música em loop: uma por fase e uma da vila (licenciadas para uso no Roblox)
	Music = {
		Lobby = id(103415687572371), -- Skybreaker Drums | Anime Taiko Festival (Zevirael)
		NinjaVillage = id(78774174469261), -- Dojo (World Instrumentals)
		HarborVillage = id(113350352864218), -- Adventure Island (FreeMind619)
		AlienPlanet = id(78137697592534), -- Soft Echoes (Mylesxiety)
	} :: { [string]: string },

	MusicVolume = 0.35,
	MusicFadeSeconds = 1.2,
}

return Sounds
