--!strict
-- Textos do jogo. Idioma final em aberto (GDD seção 19): pt-BR é provisório.
-- Nomes dos heróis, vilões e capítulos também podem mudar.

local Strings = {
	Title = "O Livro de Natal",
	Run = "CORRER",
	RunAgain = "CORRER DE NOVO",
	Menu = "Menu",
	Loading = "Preparando a pista...",
	StartFailed = "Não deu para começar. Tente de novo.",
	ChapterBanner = "Capítulo %d · %s",
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
	HeroLabel = "Herói",
	ChapterLabel = "Capítulo (solo)",
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
	BookHint = "Pise no círculo dourado para entrar na corrida!",
	PadWaiting = "CORRIDA\n%d/%d no círculo",
	PadCountdown = "LARGADA EM %d s\n%s",
	PadRacing = "CORRIDA EM ANDAMENTO",

	EndReasons = {
		Crash = "Bateu!",
		Caught = "Pego!",
		Fall = "Caiu!",
	} :: { [string]: string },

	Leaderstats = {
		Coins = "Moedas",
		Best = "Recorde",
	},

	Heroes = {
		Elf = "Duende Corredor",
		Santa = "Papai Noel",
		Reindeer = "Rena Rudolfo",
		Snowman = "Boneco de Neve",
		IceFairy = "Fada do Gelo",
	} :: { [string]: string },

	Chapters = {
		Gingerbread = "Vila de Pão de Mel",
		ToyFactory = "Fábrica de Brinquedos",
		NorthPole = "Polo Norte",
	} :: { [string]: string },

	PowerUps = {
		Magnet = "Ímã",
		Shield = "Escudo",
		DoubleCoins = "Moedas x2",
		Skates = "Patins",
		NoseDash = "Dash",
		SnowballRoll = "Bola de neve",
		TimeFreeze = "Congelar",
	} :: { [string]: string },
}

return Strings
