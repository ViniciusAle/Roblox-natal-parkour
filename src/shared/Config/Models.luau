--!strict
-- Modelos prontos da Creator Store usados no cenário e no lobby (todos gratuitos e sem scripts).
-- O script tools/ImportModels.lua baixa cada um para ReplicatedStorage.Assets.Props.<nome>.
-- Enquanto o modelo não estiver no lugar, usa-se a receita de peças "fallback" (Config/Props).
-- Origem e autor de cada um em docs/ASSETS.md. Modelo novo = linha nova aqui + linha em ASSETS.md.

export type ModelDef = {
	id: number,
	fallback: string, -- receita de peças em Config/Props
	rot: Vector3?, -- correção em graus para deixar o modelo em pé e de frente para a pista (-Z), se ele vier torto
}

local Models: { [string]: ModelDef } = {
	-- Piazza Pizza (praça italiana)
	ItalianHouseYellow = { id = 8740234094, fallback = "FisherHouse" }, -- Italian House 1 (terg_turry)
	EuroBuilding = { id = 18854955642, fallback = "FisherHouseCoral" }, -- EuropeanStyleBuilding1 (suphorg)
	RedRoofHouse = { id = 7729679763, fallback = "FisherHouseCoral" }, -- Low Poly House (ShadowColorXD)
	ShopHouse = { id = 18144266950, fallback = "FisherHouseTeal" }, -- Low Poly House (Myzicx)
	CypressA = { id = 430282600, fallback = "Cypress" }, -- Low-Poly Cypress Tree (JDLENL)
	CypressB = { id = 9730622948, fallback = "Cypress" }, -- Low Poly tree/cypress (Benoxity)
	FountainModel = { id = 11423259371, fallback = "Fountain" }, -- Fountain (MR_MohamedTarek)
	ScooterOrange = { id = 5619856622, fallback = "Rock" }, -- classic scooter (fajnygosciu1234)
	ScooterWhite = { id = 10621992682, fallback = "Rock" }, -- Vespa Scooter Bike Mesh (Emett_68)
	GelatoCart = { id = 6863381075, fallback = "Rock" }, -- ice cream stand (g3rh2lhwt4k23rhgq413)
	CafeTable = { id = 5715358225, fallback = "Rock" }, -- Table with Umbrella (SilentDonuts)
	StreetLampModel = { id = 10708194655, fallback = "StreetLamp" }, -- VICTORIAN STREET LAMP (visionpsyche7)
	FlowerPlanter = { id = 4542793421, fallback = "Bush" }, -- Pink Flower Pot (TheOkayest)
	PizzaSlice = { id = 757899575, fallback = "Rock" }, -- Slice of Pizza (CocoaSpike)
	PizzaBoxModel = { id = 3028085134, fallback = "Rock" }, -- better pizza box (fart7up)

	-- Spiaggia Banana (praia)
	CrateModel = { id = 182451181, fallback = "CargoCrates" }, -- Wooden Crate (Quenty)
	BarrelsModel = { id = 145810052, fallback = "WoodBarrels" }, -- Wooden Barrels (GnomeCode)
	BeachHouse = { id = 16051754046, fallback = "FisherHouseTeal" }, -- beach house (exotic429)
	PalmTreeModel = { id = 4586726395, fallback = "PalmTree" }, -- Palm Tree (mikeyguzboy2)
	RowboatModel = { id = 639159447, fallback = "Rowboat" }, -- Rowboat (CharzardDAG)
	MountainGreen = { id = 15610270923, fallback = "IslandHill" }, -- Low-Poly Mountain (crazeejakob)

	-- Cosmo Caotico (espaço)
	CrystalCluster = { id = 427069937, fallback = "CrystalRocks" }, -- Crystal With Rocks (20builder07)
	AlienMushroomTree = { id = 13416843974, fallback = "SpiralPlant" }, -- Alien Mushroom tree (archelgarieltio)
	PurpleMushroom = { id = 16719762693, fallback = "GlowShrooms" }, -- Purple Alien Mushroom (PixYolk)
	AlienPlantModel = { id = 3690706990, fallback = "SpiralPlant" }, -- Alien Plant (ejr2d)
	RockArchModel = { id = 89546509, fallback = "FloatingRock" }, -- rock arch (NerdyGamer68)
	RocketModel = { id = 9658778741, fallback = "AlienSpire" }, -- Small Red Rocket Ship (logoffkid)
	AsteroidModel = { id = 9293040445, fallback = "FloatingRock" }, -- Asteroid (fribzi17)
	DonutPack = { id = 85230283197513, fallback = "Donut" }, -- Donut Collection [4 Pack] (ThePaparazziGamer)

	-- Decoração pequena junto à pista (todas as fases)
	BushA = { id = 5003870763, fallback = "Bush" }, -- Low-Poly Bush (Exp_p)
	BushB = { id = 14720410685, fallback = "Bush" }, -- Low poly big bush (Tanakob12345)
	RockA = { id = 7299047040, fallback = "Rock" }, -- Low Poly Rock (linktimehero)
	RockB = { id = 16098456067, fallback = "Rock" }, -- Low-Poly Rock (Jajkopko_XD)
	FlowerPink = { id = 8174229353, fallback = "Bush" }, -- Pink Flower Bush (Unlimitens)
	FlowerBush = { id = 8344171779, fallback = "Bush" }, -- Flower Bush (Woof_HDPlay)
	TallGrass = { id = 138382131, fallback = "Bush" }, -- Tall grass (aIohasun)
	GrassTuft = { id = 199054340, fallback = "Bush" }, -- Tall Grass (1Riblock1)
	TropicalBush = { id = 86978760303831, fallback = "Bush" }, -- Stylized Tropical Bush (MonkeycaveYT)
	BeachUmbrella = { id = 733589460, fallback = "Rock" }, -- Beach Umbrella (nhiclz10)
	GlowMushroomCyan = { id = 2986139359, fallback = "GlowShrooms" }, -- Glowing Mushroom (CaptainOwlin)
	GlowMushroomBlue = { id = 3350230927, fallback = "GlowShrooms" }, -- Glowing Mushroom (AddictedComputerGuy)
	AlienCrystal = { id = 10417124805, fallback = "CrystalRocks" }, -- brilliant alien crystals kit (Duxcomp)
}

return Models
