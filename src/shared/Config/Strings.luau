--!strict
-- Textos do jogo. Idioma final em aberto: pt-BR é provisório.
-- Nome do jogo ("Anime Racers") e nomes dos personagens e biomas também são provisórios.

local Strings = {
	Title = "Anime Racers",
	TitleTagline = "Corra. Desvie. Seja lendário.",
	TapToStart = "TOQUE PARA COMEÇAR",
	Run = "CORRER",
	RunAgain = "CORRER DE NOVO",
	Menu = "Menu",
	Loading = "Preparando a pista...",
	StartFailed = "Não deu para começar. Tente de novo.",
	ChapterBanner = "Fase %d · %s",
	Meters = "%d m",
	Stumble = "Cuidado!",
	ShieldBroke = "Escudo quebrou!",
	Revived = "Vida extra!",
	ResultsTitle = "Fim da corrida",
	ResultDistance = "Distância: %d m",
	ResultCoins = "Moedas: +%d",
	ResultTotal = "Total: %d",
	ResultBest = "Recorde: %d m",
	NewBest = "Novo recorde!",
	Ability = "PODER",
	Solo = "JOGAR SOLO",
	BackToVillage = "VOLTAR À VILA",
	HeroLabel = "Personagem",
	ChapterLabel = "Fase (solo)",
	Go = "JÁ!",
	You = "Você",
	Spectating = "Assistindo: %s",
	WaitingOthers = "Esperando os outros terminarem...",
	RaceTitle = "Ranking da corrida",
	RacePlace = "%dº  %s  ·  %d m",
	RaceCoins = "Moedas: +%d",
	MatchWaiting = "Pise no círculo dourado para correr com amigos  ·  %d/%d",
	MatchCountdown = "Corrida em %d s  ·  %s",
	MatchRacing = "Corrida em andamento",
	PortalHint = "Pise no círculo dourado para entrar na corrida!",
	PadWaiting = "CORRIDA\n%d/%d no círculo",
	PadCountdown = "LARGADA EM %d s\n%s",
	PadRacing = "CORRIDA EM ANDAMENTO",

	EndReasons = {
		Crash = "Bateu!",
		Caught = "Tropeçou de novo!",
		Fall = "Caiu!",
	} :: { [string]: string },

	Leaderstats = {
		Coins = "Moedas",
		Best = "Recorde",
	},

	Heroes = {
		Riku = "Riku",
		Hana = "Hana",
		Gorou = "Gorou",
		Ryuga = "Ryuga",
		Akari = "Akari",
	} :: { [string]: string },

	Rarities = {
		Common = "Comum",
		Rare = "Raro",
		Epic = "Épico",
		Legendary = "Lendário",
		Secret = "Secreto",
	} :: { [string]: string },

	Chapters = {
		NinjaVillage = "Vila Ninja",
		HarborVillage = "Vila do Porto",
		AlienPlanet = "Planeta Verde",
	} :: { [string]: string },

	PowerUps = {
		Magnet = "Ímã",
		Shield = "Escudo",
		DoubleCoins = "Moedas x2",
		Skates = "Turbo",
		Dash = "Investida",
		Smash = "Esmagar",
		TimeSlow = "Câmera lenta",
	} :: { [string]: string },
}

return Strings
