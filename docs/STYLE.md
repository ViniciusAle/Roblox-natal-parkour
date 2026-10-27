# Guia de estilo: O Livro de Natal

Decidido em 27/10/2026, a partir da proposta do GDD (seção 15). Os dados ficam em
`src/shared/Config/Themes.luau` (luz, cores, cenário por capítulo) e `src/shared/Config/Props.luau` (receitas das peças).

## Regras gerais

- Formas simples (low-poly), feitas só com peças básicas: bloco, bola, cilindro e cunha.
- **Perigo x recompensa:** obstáculos têm cores fortes e silhueta clara; moedas são douradas e brilham (Neon); power-ups são esferas neon coloridas que flutuam.
- **Leitura da pista:** o piso é sempre mais calmo que os obstáculos, e as linhas das pistas ficam visíveis.
- O cenário lateral nunca entra na pista; os props ficam além das bordas.
- No celular: no máximo cerca de 3 props por lado por chunk, sem sombras nos props e poucas luzes (PointLight só no lobby).

## Capítulo 1: Vila de pão de mel

| Elemento | Escolha |
| --- | --- |
| Paleta | biscoito (186,112,56), glacê branco, vermelho bala, verde menta, dourado |
| Piso | biscoito com faixas de glacê a cada 12 studs |
| Obstáculos | Baixo = par de presentes; Alto = arco de bengala com viga rosa; Bloco = casa de pão de mel |
| Cenário | casinhas, bengalas, pirulitos, árvores de jujuba; colinas de biscoito ao fundo |
| Luz | fim de tarde quente (ClockTime 16.6), névoa pêssego, bloom leve |
| Partículas | neve leve |

## Capítulo 2: Fábrica de brinquedos (papel recortado)

| Elemento | Escolha |
| --- | --- |
| Paleta | vermelho, azul, amarelo e verde de papel, cada um com uma camada mais clara na frente |
| Piso | esteira azul-acinzentada com ripas a cada 4 studs e linhas amarelas |
| Obstáculos | Baixo = caixote + caixa de brinquedo; Alto = viga amarela com listras de perigo e luz vermelha embaixo; Bloco = torre de blocos de brinquedo |
| Cenário | árvores de papel em camadas, engrenagens, blocos, nuvens planas; colinas de papel ao fundo |
| Luz | dia claro e suave (ClockTime 13), saturação alta, contraste baixo |
| Partículas | confete de papel colorido |

## Capítulo 3: Polo Norte (noite de luzes, neon equilibrado)

| Elemento | Escolha |
| --- | --- |
| Paleta | azul-gelo, branco neve, ciano neon, com detalhes em vermelho, verde e dourado |
| Piso | gelo claro (legível no escuro), linhas das pistas em ciano neon |
| Obstáculos | Baixo = tronco de neve com luzinhas; Alto = viga de gelo com linha neon embaixo; Bloco = bloco de gelo com bordas neon |
| Cenário | pinheiros com bolas neon, cristais de gelo, iglus com porta acesa, postes; montanhas nevadas ao fundo |
| Luz | noite (ClockTime 0.5), bloom mais forte, aurora boreal animada no céu |
| Partículas | neve densa |
| Neon | só nos detalhes (bordas, enfeites, linhas); o piso e os volumes não brilham |

## Transição entre capítulos

Uma página de papel creme com moldura vermelha atravessa a tela, mostrando "Capítulo N · Nome". A luz muda suavemente (1,2 s).

## Vila do lobby

Praça nevada ao entardecer, com:

- um livro gigante aberto (a "porta" da corrida);
- um círculo dourado de fila;
- uma árvore de Natal gigante com presentes;
- casas de pão de mel e iglus em volta;
- postes com cordões de luz coloridos;
- neve caindo.

## Interface

| Elemento | Escolha |
| --- | --- |
| Painéis | papel creme com moldura vermelha e fita vermelha de título com borda dourada |
| Botões | gradiente verde (ação principal), vermelho (setas, poder) e papel (secundário) |
| HUD | "pílulas" escuras com borda dourada (🍬 moedas, 📖 distância) |
| Fontes | FredokaOne (títulos e números), GothamBold (legendas) |

## Ainda provisório

- Heróis e vilões montados com peças; os modelos finais virão do Creator Store ou de arte própria.
- Logo e tela inicial (pergunta aberta do GDD).
