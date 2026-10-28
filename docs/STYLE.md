# Guia de estilo: Brainrot Rush

Decidido em 28/10/2026, quando o tema mudou de anime para brainrot. Os dados ficam em
`src/shared/Config/Themes.luau` (luz, cores, cenário por fase), `src/shared/Config/Props.luau` (receitas das peças)
e `src/shared/Config/Rarities.luau` (cores das raridades).

## Regras gerais

- **Personagens:** os brainrots famosos dos memes, montados do zero com peças (nada copiado de outros jogos).
  Cenário, obstáculos, nome e logo são originais. Ver o risco em `docs/ASSETS.md`.
- **Fórmula brainrot:** bicho + objeto do dia a dia, nome de italiano inventado, olhos esbugalhados e, se couber, tênis.
- **Comida e objetos gigantes com olhos** nos obstáculos. Os olhos ficam virados para o jogador (+Z).
- **Perigo x recompensa:** obstáculos têm silhueta clara; moedas douradas brilham; power-ups são esferas neon.
- **Leitura da pista:** 5 pistas com linhas visíveis; o piso é mais calmo que os obstáculos.
- **Obstáculo alto** sempre mostra algo pendurado até a altura de colisão (espaguete, toalhas, raio do disco voador), para o jogador saber que deve deslizar.
- **Celular:** sem sombras nos props; luz pontual só no lobby.

## Personagens

Feitos de peças (bola, bloco, cilindro), com medidas em studs dentro da caixa do corredor (2,4 x 5 x 2).
A câmera vê as costas, então cada um tem algo marcante atrás: copa de folhas, xícara com espuma, taco no ombro, barbatana e rabo de tubarão, cauda de avião.
Ao correr, rebolam de um lado para o outro e balançam as pernas.

| Raridade | Personagem | Visual | Cor do rastro |
| --- | --- | --- | --- |
| Comum | Brr Brr Patapim | tronco de árvore com cara de macaco, narigão, galhos de braço, copa de folhas e pés enormes | verde |
| Raro | Ballerina Cappuccina | bailarina de tutu rosa com xícara de cappuccino (espuma e coração) no lugar da cabeça | rosa |
| Épico | Tung Tung Tung Sahur | tora de madeira de olhos arregalados, sorriso e taco no ombro | laranja-madeira |
| Lendário | Tralalero Tralala | tubarão azul deitado, com três pernas e tênis azuis | azul |
| Secreto | Bombardiro Crocodilo | crocodilo-bombardeiro com asas, hélices, cabine e bombas; voa sem pernas | verde-limão |

As cinco criaturas originais (Pollo Polpetto, Lumaca Lampadina, Granchio Gelatino, Gufo Sveglietta, Balena Mongolfiera)
continuam em `Config/Props` como reserva.

De Épico para cima, a aura de partículas fica sempre ligada. No modo brainrot (barra de caos cheia), qualquer personagem ganha aura forte, luz e contorno brilhante.

## Fase 1: Piazza Pizza

| Elemento | Escolha |
| --- | --- |
| Piso | pedra bege com faixas de terracota a cada 8 studs; trilhos creme com friso verde |
| Obstáculos | Baixo = pilhas de caixas de pizza (com olhos); Alto = arco de grissini com espaguete pendurado; Bloco = cafeteira moka gigante de bigode |
| Cenário | casas italianas coloridas, ciprestes, postes, lambretas, carrinho de sorvete, fonte; morros ao fundo |
| Luz | tarde dourada (ClockTime 15,5), saturação alta |
| Partículas | confete verde, branco e vermelho |

## Fase 2: Spiaggia Banana

| Elemento | Escolha |
| --- | --- |
| Piso | deque de madeira; trilhos brancos com friso rosa |
| Obstáculos | Baixo = castelo de areia com balde; Alto = banana gigante entre postes, com toalhas listradas penduradas; Bloco = coco gigante de canudinho e guarda-chuva |
| Cenário | casas de praia, palmeiras, guarda-sóis, barcos; morros ao fundo |
| Luz | meio-dia de sol forte |
| Partículas | maresia leve |

## Fase 3: Cosmo Caotico

| Elemento | Escolha |
| --- | --- |
| Piso | rocha roxa com faixas neon rosa; linhas das pistas em ciano neon |
| Obstáculos | Baixo = rochas com cristais; Alto = disco voador abduzindo uma pizza (o raio marca a altura); Bloco = foguete com escotilha de olhos |
| Cenário | cogumelos e plantas alienígenas, cristais, foguetes, asteroides e donuts flutuando; montanhas ao fundo |
| Luz | noite roxa, bloom forte, aurora ligada |
| Partículas | estrelinhas rosa, ciano e amarelas |

## Lobby (praça)

Praça italiana numa tarde dourada, com:

- avenida de tijolo com canais de água dos dois lados;
- arco gigante de espaguete na entrada;
- cafeteira moka gigante com a placa "Brainrot Rush" nas cores da Itália;
- círculo dourado de fila;
- ciprestes, casas coloridas, postes acesos, duas fontes, mesinhas de café, carrinhos de sorvete e lambretas;
- morros verdes ao longe e confete caindo.

## Interface

| Elemento | Escolha |
| --- | --- |
| Painéis | roxo-uva com borda amarela |
| Títulos | adesivo amarelo torto, contorno grosso escuro, sombra rosa e estrelinhas verde-limão |
| Botões | rosa-choque (ação principal e setas), roxo com borda amarela (secundário); crescem ao passar o mouse e encolhem ao tocar |
| HUD | pílulas escuras com ícones desenhados; barra de CAOS de verde-limão para rosa |
| Fontes | Luckiest Guy (títulos e números), Builder Sans Bold (textos), via FontFace |
| Logo | "BRAINROT" (verde-limão → amarelo) e "RUSH" (rosa), letras tortas com contorno grosso |

## Ainda provisório

- Nome do jogo, logo final e valores de luz (calibrar por captura de tela).
- Personagens de peças, até existirem modelos 3D próprios (`ReplicatedStorage.Assets.Characters`).
