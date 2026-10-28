# Registro de ativos

Todo modelo, som, imagem ou música usado no jogo entra aqui, com origem e licença.
Personagens brainrot são originais e montados com peças por script (nenhum personagem de meme existente); cenário usa modelos gratuitos da Creator Store; obstáculos e logo são feitos por script.

## Sons (efeitos)

Pacote "Daily Sounds" (@DailySoundsFX) na Creator Store. A descrição diz que são sintetizados do zero, sem samples nem IA, e gratuitos.

| Uso | Nome na loja | Id | Autor | Licença | Data |
| --- | --- | --- | --- | --- | --- |
| Coin | Coin Pickup - Daily Sounds | 130378474223829 | @DailySoundsFX | Gratuito (Creator Store) | 28/10/2026 |
| Jump | Platformer Jump - Daily Sounds | 133564751966469 | @DailySoundsFX | Gratuito (Creator Store) | 28/10/2026 |
| Slide | Swift Swoosh - Daily Sounds | 89056149423727 | @DailySoundsFX | Gratuito (Creator Store) | 28/10/2026 |
| LaneChange | Fast Whoosh - Daily Sounds | 80984744279155 | @DailySoundsFX | Gratuito (Creator Store) | 28/10/2026 |
| Stumble | Cartoon Pop - Daily Sounds | 106984966606682 | @DailySoundsFX | Gratuito (Creator Store) | 28/10/2026 |
| Crash | Deep Impact Boom - Daily Sounds | 94978851787238 | @DailySoundsFX | Gratuito (Creator Store) | 28/10/2026 |
| PowerUp | Power Surge - Daily Sounds | 82669989135278 | @DailySoundsFX | Gratuito (Creator Store) | 28/10/2026 |
| ShieldBreak | Power Down - Daily Sounds | 96795857757261 | @DailySoundsFX | Gratuito (Creator Store) | 28/10/2026 |
| Trampoline | Retro Jump - Daily Sounds | 91645115774690 | @DailySoundsFX | Gratuito (Creator Store) | 28/10/2026 |
| PageTurn (troca de fase) | Cinematic Riser - Daily Sounds | 94077390731779 | @DailySoundsFX | Gratuito (Creator Store) | 28/10/2026 |
| UiClick | Toggle Click - Daily Sounds | 138409154614452 | @DailySoundsFX | Gratuito (Creator Store) | 28/10/2026 |
| Transform (modo brainrot) | Thunder Crack - Daily Sounds | 93488774972627 | @DailySoundsFX | Gratuito (Creator Store) | 28/10/2026 |
| Blast (jato d'água) | Blaster Burst - Daily Sounds | 111344440939396 | @DailySoundsFX | Gratuito (Creator Store) | 28/10/2026 |
| Land | action_jump_land.mp3 | rbxasset://sounds/action_jump_land.mp3 | Roblox (vem com o cliente) | Uso no Roblox | 28/10/2026 |

## Músicas

Faixas das contas oficiais de distribuidoras na Creator Store (@APMOfficial, @DistrokidOfficial), liberadas para uso em experiências Roblox.
Nenhuma faixa usa nome ou voz de memes brainrot existentes.

| Uso | Faixa | Id | Conta | Licença | Data |
| --- | --- | --- | --- | --- | --- |
| Praça (lobby) | Italian Accordion | 1839408249 | APM Music | Creator Store, uso no Roblox | 28/10/2026 |
| Piazza Pizza | Today Tarantella | 9043154320 | APM Music | Creator Store, uso no Roblox | 28/10/2026 |
| Spiaggia Banana | funny bouncy upbeat sunny positive | 105930077937035 | DistroKid | Creator Store, uso no Roblox | 28/10/2026 |
| Cosmo Caotico | Techno Vibe | 1843075656 | APM Music | Creator Store, uso no Roblox | 28/10/2026 |

## Fontes

| Fonte | Uso | Origem |
| --- | --- | --- |
| Luckiest Guy | títulos, logo, números | Fonte embutida do Roblox (`rbxasset://fonts/families/LuckiestGuy.json`) |
| Builder Sans | legendas e textos | Fonte embutida do Roblox |

## Personagens

Os 5 personagens jogáveis são brainrots famosos dos memes do TikTok (2025): Brr Brr Patapim, Ballerina Cappuccina,
Tung Tung Tung Sahur, Tralalero Tralala e Bombardiro Crocodilo.

Visual: modelo pronto da Creator Store (campo `model` em `Config/Heroes`, importado pelo `tools/ImportModels.lua` para
`ReplicatedStorage.Assets.Characters`). Enquanto o modelo não for importado, entra a versão de peças feita do zero em `Config/Props`.
Escolhidos em 29/10/2026 pelas miniaturas; o importador apaga qualquer script:

| Personagem | Id | Modelo na loja | Autor |
| --- | --- | --- | --- |
| Brr Brr Patapim | 100538198930997 | brr brr patapim | Haxcyc_LDC |
| Ballerina Cappuccina | 132021456717690 | Ballerina Cappuccina | vexqty |
| Tung Tung Tung Sahur | 138151705692565 | Tung Tung Tung Sahur | ATMnou |
| Tralalero Tralala | 113095126725171 | Tralalero Tralala | capuchin_queso |
| Bombardiro Crocodilo | 91327024837680 | Bombardiro Crocodilo [Working] | F0g_02 (scripts removidos na importação) |

**Atenção:** quem publicou esses modelos na loja pode não ser o autor da arte (muitos são cópias de outros jogos, como o
Steal a Brainrot). Esse é justamente o risco do processo citado abaixo. Para ficar só com arte própria, apague o campo `model`
do personagem e a pasta dele em `Assets.Characters`.

**Risco aceito pelo dono do jogo em 28/10/2026.** Os memes não têm um autor único, mas não são livres:

- a Officina Comunicazione S.R.L. pediu, no fim de 2025, o registro da marca "TRALALERO TRALALA" em vários países;
- o Steal a Brainrot removeu o Tung Tung Tung Sahur em 13/09/2025, segundo uma reportagem por direitos autorais;
- o estúdio do Steal a Brainrot processou um jogo do Fortnite por copiar as artes 3D dos brainrots dele.

Regras: não pôr nome de meme no título do jogo nem no logo.
Se um personagem receber denúncia, troque o campo `recipe` (e o nome) em `Config/Heroes` por uma das criaturas
originais de reserva em `Config/Props` (Pollo Polpetto, Lumaca Lampadina, Granchio Gelatino, Gufo Sveglietta, Balena Mongolfiera).

## Modelos de cenário (Creator Store)

Gratuitos e sem scripts, escolhidos em 28/10/2026 pelas miniaturas da loja. São importados pelo `tools/ImportModels.lua` para `ReplicatedStorage.Assets.Props`.

| Nome no jogo | Id | Modelo na loja | Autor |
| --- | --- | --- | --- |
| **Piazza Pizza** | | | |
| ItalianHouseYellow | 8740234094 | Italian House 1 | terg_turry |
| EuroBuilding | 18854955642 | EuropeanStyleBuilding1 | suphorg |
| RedRoofHouse | 7729679763 | Low Poly House | ShadowColorXD |
| ShopHouse | 18144266950 | Low Poly House | Myzicx |
| CypressA | 430282600 | Low-Poly Cypress Tree | JDLENL |
| CypressB | 9730622948 | Low Poly tree/cypress | Benoxity |
| FountainModel | 11423259371 | Fountain | MR_MohamedTarek |
| ScooterOrange | 5619856622 | classic scooter | fajnygosciu1234 |
| ScooterWhite | 10621992682 | Vespa Scooter Bike Mesh | Emett_68 |
| GelatoCart | 6863381075 | ice cream stand | g3rh2lhwt4k23rhgq413 |
| CafeTable | 5715358225 | Table with Umbrella (1) | SilentDonuts |
| StreetLampModel | 10708194655 | VICTORIAN STREET LAMP | visionpsyche7 |
| FlowerPlanter | 4542793421 | Pink Flower Pot | TheOkayest |
| PizzaSlice | 757899575 | Slice of Pizza | CocoaSpike |
| PizzaBoxModel | 3028085134 | better pizza box | fart7up |
| **Spiaggia Banana** | | | |
| CrateModel | 182451181 | Wooden Crate | Quenty |
| BarrelsModel | 145810052 | Wooden Barrels | GnomeCode |
| BeachHouse | 16051754046 | beach house | exotic429 |
| PalmTreeModel | 4586726395 | Palm Tree | mikeyguzboy2 |
| RowboatModel | 639159447 | Rowboat | CharzardDAG |
| MountainGreen | 15610270923 | Low-Poly Mountain | crazeejakob |
| **Cosmo Caotico** | | | |
| CrystalCluster | 427069937 | Crystal With Rocks | 20builder07 |
| AlienMushroomTree | 13416843974 | Alien Mushroom tree | archelgarieltio |
| PurpleMushroom | 16719762693 | Purple Alien Mushroom | PixYolk |
| AlienPlantModel | 3690706990 | Alien Plant | ejr2d |
| RockArchModel | 89546509 | rock arch | NerdyGamer68 |
| RocketModel | 9658778741 | Small Red Rocket Ship | logoffkid |
| AsteroidModel | 9293040445 | Asteroid | fribzi17 |
| DonutPack | 85230283197513 | Donut Collection [4 Pack] | ThePaparazziGamer |
| **Decoração (todas as fases)** | | | |
| BushA | 5003870763 | Low-Poly Bush | Exp_p |
| BushB | 14720410685 | Low poly big bush | Tanakob12345 |
| RockA | 7299047040 | Low Poly Rock | linktimehero |
| RockB | 16098456067 | Low-Poly Rock | Jajkopko_XD |
| FlowerPink | 8174229353 | Pink Flower Bush | Unlimitens |
| FlowerBush | 8344171779 | Flower Bush | Woof_HDPlay |
| TallGrass | 138382131 | Tall grass | aIohasun |
| GrassTuft | 199054340 | Tall Grass | 1Riblock1 |
| TropicalBush | 86978760303831 | Stylized Tropical Bush - Jungle Foliage | MonkeycaveYT |
| BeachUmbrella | 733589460 | Beach Umbrella | nhiclz10 |
| GlowMushroomCyan | 2986139359 | Glowing Mushroom | CaptainOwlin |
| GlowMushroomBlue | 3350230927 | Glowing Mushroom | AddictedComputerGuy |
| AlienCrystal | 10417124805 | brilliant alien crystals kit | Duxcomp |

Os modelos da vila japonesa do tema anime (torii, casas japonesas, cerejeiras, lanternas, bambu, pagode, cerca, lanterna de papel) saíram do jogo em 28/10/2026. O Coliseu, o farol, o galeão, Saturno e o disco voador do fundo saíram em 29/10/2026 (pesados demais; o fundo agora é só montanha).

Modelos gratuitos da Creator Store podem ser usados em experiências Roblox. Antes de lançar, abra cada um e confirme que não traz marca ou personagem de terceiros.

## Imagens de referência

As imagens em `referencias/` servem só de inspiração interna; nada delas entra no jogo.
