# Guia de estilo: Anime Racers

Decidido em 28/10/2026, quando o tema mudou de Natal para anime. Os dados ficam em
`src/shared/Config/Themes.luau` (luz, cores, cenário por fase), `src/shared/Config/Props.luau` (receitas das peças)
e `src/shared/Config/Rarities.luau` (cores das raridades).

## Regras gerais

- Tudo original: personagens, lugares e símbolos não copiam nenhuma obra. As referências servem para clima, cor e proporção.
- Formas simples (low-poly) feitas com bloco, bola e cilindro. Telhados e cabelos usam blocos girados (`rot`), não cunhas.
- **Perigo x recompensa:** obstáculos têm silhueta clara; moedas douradas brilham; power-ups são esferas neon.
- **Leitura da pista:** 5 pistas com linhas visíveis; o piso é mais calmo que os obstáculos.
- **Obstáculo alto** sempre mostra algo pendurado até a altura de colisão (cortinas, vela, cipós), para o jogador saber que deve deslizar.
- No celular: cerca de 3 props por lado por chunk, sem sombras nos props, luz pontual só no lobby.

## Personagens (estilo anime de luta, cabeça grande, olhos grandes)

| Raridade | Cor | Personagem | Visual |
| --- | --- | --- | --- |
| Comum | cinza | Riku | jaqueta azul, cachecol vermelho, cabelo castanho espetado |
| Raro | azul | Hana | quimono verde, cabelo rosa curto, espada nas costas |
| Épico | roxo | Gorou | grandão, regata amarela, moicano roxo, faixas nos braços |
| Lendário | laranja | Ryuga | armadura escura com dourado, cabelo prateado, manto vermelho |
| Secreto | rosa | Akari | vestido branco e dourado, cabelo azul-gelo, auréola e asas de luz |

De Épico para cima, o personagem tem aura de partículas na cor da raridade.

## Fase 1: Vila Ninja

| Elemento | Escolha |
| --- | --- |
| Piso | pedra (Cobblestone) com faixas a cada 10 studs |
| Obstáculos | Baixo = barris amarrados; Alto = portal torii com cortinas; Bloco = casa japonesa de dois andares |
| Cenário | casas, cerejeiras, lanternas de pedra, bambuzal; pagode e montanhas ao fundo |
| Luz | fim de tarde dourado (ClockTime 16.8), névoa rosada |
| Partículas | pétalas de cerejeira |

## Fase 2: Vila do Porto

| Elemento | Escolha |
| --- | --- |
| Piso | deque de madeira com ripas a cada 4 studs |
| Obstáculos | Baixo = caixotes e corda; Alto = vela de barco entre mastros; Bloco = casa de pescador colorida |
| Cenário | casas turquesa e coral, palmeiras, barcos a remo; farol e ilhas ao fundo |
| Luz | meio-dia de sol forte, saturação alta |
| Partículas | maresia leve |

## Fase 3: Planeta Verde

| Elemento | Escolha |
| --- | --- |
| Piso | rocha clara com faixas neon verde-água |
| Obstáculos | Baixo = rochas com cristais; Alto = arco de pedra com cipós brilhantes; Bloco = torre-cogumelo |
| Cenário | plantas em espiral, cogumelos brilhantes, rochas flutuantes; torres de pedra ao fundo |
| Luz | céu verde-água, bloom médio; neon só nos detalhes |
| Partículas | esporos brilhantes |

## Vila do lobby

Vila japonesa ao entardecer, com:

- avenida de pedra com canais de água dos dois lados;
- portal torii gigante;
- templo (pagode) com a placa "Anime Racers";
- círculo dourado de fila;
- cerejeiras, casas e lanternas de pedra acesas;
- bambuzal em volta e montanhas ao longe;
- pétalas caindo.

## Interface

| Elemento | Escolha |
| --- | --- |
| Painéis | azul-noite com borda dourada; título num pergaminho ninja (papel, faixa vermelha, rolos de madeira) |
| Botões | laranja (ação principal e setas), escuro com borda dourada (secundário); crescem ao passar o mouse e encolhem ao tocar |
| HUD | pílulas escuras com ícones desenhados (moeda dourada, setas de velocidade) |
| Fontes | Luckiest Guy (títulos e números), Builder Sans Bold (textos), via FontFace |
| Animações | painéis deslizam ao abrir; contagem e avisos crescem com efeito "Back" |
| Logo | "ANIME" (branco → ciano) e "RACERS" (dourado → laranja), corte de luz e linhas de velocidade |

## Ainda provisório

- Personagens montados com peças, até existirem modelos 3D (`ReplicatedStorage.Assets.Characters`).
- Nome do jogo, logo final e valores de luz (calibrar por captura de tela).
