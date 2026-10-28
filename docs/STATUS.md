# Status do projeto

## Sessão 28/10/2026: mudança de tema para "Anime Racers" (nome provisório)

Decisões do usuário:
- tema de anime no lugar do Natal;
- 5 pistas em vez de 3;
- perseguidores removidos por enquanto;
- um personagem por raridade (Comum, Raro, Épico, Lendário, Secreto);
- 3 biomas originais (vila ninja, vila do porto, planeta verde);
- ícone do menu em forma de pergaminho ninja;
- logo temporário.

Os personagens pedidos (de Dragon Ball) não foram usados. São de terceiros: usá-los arrisca DMCA e a retirada do jogo, e os modelos deles na Creator Store também não têm licença. No lugar, entraram 5 personagens originais com as mesmas raridades. O jogo aceita modelos 3D próprios em `ReplicatedStorage.Assets.Characters`.

### Feito

- **5 pistas:** `GameConfig.Track.LaneCount`, com largada na pista do meio. Os 19 chunks foram refeitos para 5 pistas e todos passam no validador (conferido por script). A câmera ficou um pouco mais alta e aberta.
- **Perseguidor desligado** por `GameConfig.Chaser.Enabled = false`; o código fica para voltar depois. O tropeço continua: o segundo tropeço em 10 s encerra a corrida.
- **Personagens:** Riku (Comum), Hana (Raro), Gorou (Épico), Ryuga (Lendário) e Akari (Secreto), em `Config/Heroes` + `Config/Rarities`.
  - Montados com peças em estilo anime: cabeça e olhos grandes, cabelo espetado com blocos girados.
  - Aura de partículas a partir de Épico.
  - Se existir um `Model` com o id do personagem em `ReplicatedStorage.Assets.Characters`, ele é usado no lugar das peças (escala automática, deita ao deslizar).
- **Biomas:** Vila Ninja, Vila do Porto e Planeta Verde, cada um com obstáculos, cenário, fundo, luz e partículas próprios (`Config/Themes`, `Config/Props`).
- **Lobby:**
  - vila japonesa com templo, placa "Anime Racers", portal torii gigante, canais, cerejeiras, lanternas acesas, bambuzal e pétalas;
  - o círculo dourado da fila continua.
- **Sons:**
  - 11 efeitos da Creator Store e 1 embutido, com volume ajustável;
  - música em loop na vila e em cada fase, com troca suave (`Music`);
  - clique nos botões.
  - Origem e licença de cada um estão em `docs/ASSETS.md`.
- **Interface:**
  - fontes por FontFace (Luckiest Guy e Builder Sans);
  - ícones desenhados no lugar dos emojis;
  - títulos em pergaminho ninja;
  - botões que crescem e encolhem ao toque;
  - painéis que deslizam ao abrir;
  - raridade colorida no cartão;
  - tela de logo na entrada (2,5 s, ou toque para pular).
- **Ferramentas:** o Luau (luau-lang/luau 0.744) foi adicionado ao `rokit.toml`. Todos os arquivos passam no `luau-compile` (checagem de sintaxe).

### Não testado

- Nada desta parte rodou no Studio. Falta conferir:
  - visual dos personagens e do lobby;
  - telhados em prisma;
  - tela de logo;
  - volume dos sons;
  - se as músicas tocam (os ids foram escolhidos pelo nome e descrição; ainda não ouvi nenhuma).
- A checagem de tipos (`--!strict`) só roda no Studio: o analisador fora dele não conhece os tipos do Roblox.

### Em aberto (para o usuário)

- Nome final do jogo e logo definitivo.
- Ícones em imagem: hoje são desenhados com frames. Para imagens de verdade, é preciso subir as imagens no Roblox e passar os ids.
- Modelos 3D dos personagens (Blender ou Creator Store com licença).
- Calibrar a luz das fases por captura de tela.

## Sessão 27/10/2026 (parte 2): cenários, vila do lobby e corrida multiplayer

Decisões: arte da proposta do GDD, Capítulo 3 com neon equilibrado, lobby em vila 3D com corrida multiplayer.

### Feito

- **Arte por dados:** `PropAssembler` monta receitas de peças em qualquer tamanho e orientação. São cerca de 30 receitas em `Config/Props` (obstáculos, cenário, 5 heróis, 2 vilões) e `Config/Themes` define piso, faixas, bordas, chão lateral, props, fundo, luz e partículas de cada capítulo. O guia está em [STYLE.md](STYLE.md).
- **Pista temática:** obstáculos com a cara de cada capítulo (blocos longos viram uma fileira de casas ou torres), cenário lateral sorteado pela seed (igual para todos na corrida), linhas das pistas, faixas no piso, power-ups flutuando e trampolim neon.
- **Ambiente:** atmosfera, bloom e correção de cor por capítulo, com transição suave. Neve ou confete, aurora animada no Polo Norte e linhas de vento com a velocidade. A página que vira entre capítulos ficou mais bonita.
- **Heróis e vilões** montados com peças (Duende, Papai Noel, Rena, Boneco de Neve, Fada; Krampus e Duende Rebelde). Eles quicam ao correr, achatam ao deslizar e inclinam na troca de pista.
- **Vila do lobby** (`LobbyBuilder`, servidor): praça ao entardecer, livro gigante, círculo dourado de fila com placa, árvore gigante com presentes, casas, iglus, pinheiros, postes com cordões de luz e neve.
- **Corrida multiplayer** (`MatchService`):
  - Fila no círculo e contagem (30 s; 8 s no Studio).
  - Mínimo de 2 jogadores (1 no Studio) e máximo de 8.
  - Mesma seed para todos, largada sincronizada com 3-2-1.
  - Posição dos rivais validada e repassada cerca de 8x/s; fantasmas com nome e placar ao vivo.
  - Quem cai assiste o líder; ranking no fim.
- **Interface nova** (`UiKit`): papel creme, fita vermelha, botões com gradiente, pílulas de HUD, cartão de preparo na vila e banner da fila.

### Não testado

- Nada desta parte rodou no Studio ainda. Falta conferir principalmente a orientação das cunhas (telhados, pinheiros, chapéus) e o multiplayer com 2 clientes (Teste → Clientes e servidores).

### Em aberto (para o usuário)

- Mínimo de jogadores por corrida, fórmula de vitória (hoje: maior distância) e prêmio por colocação.
- Logo e tela inicial.

## Sessão 27/10/2026: Fase 1, protótipo jogável ("feio mas jogável")

### Feito

- Projeto Rojo (`default.project.json`) com a divisão cliente / compartilhado / servidor da seção 16.
- **Configuração orientada a dados:** `GameConfig` (todos os números), `Heroes` (5), `Chapters` (3), `Abilities` (4 power-ups, 3 melhorias, 1 consumível e 3 habilidades ativas), `Villains`, `Chunks` (17), `Strings`, `Sounds`.
- **Movimento** (`Runner`): 3 pistas com troca suave de 0,12 s, buffer de entrada de 0,15 s (separado para lateral e vertical), coyote time de 0,1 s, pulo de altura variável, pulo duplo (melhoria), planar (segurar o pulo na queda), deslizar e queda rápida, trampolim. A velocidade vai de 30 a 70 studs/s em 3 min.
- **Pista** (`TrackGenerator`, `Track`): chunks de 60 studs sorteados por seed determinística, dificuldade que sobe com a distância, sem repetir chunk em seguida, 6 chunks à frente, pooling de peças e virada de página a cada 1000 m (troca capítulo, iluminação e vilão).
- **Justiça** (`ChunkValidator`): margens de encaixe, vãos de até 14 studs, sem sobreposição e com rota livre garantida; chunk inválido é recusado ao iniciar.
- **Regras** (`RunSession`): tropeço (perde velocidade e o vilão chega perto), segundo tropeço em 10 s encerra; bater de frente num bloco encerra (configurável); cair num vão encerra; escudo; vida extra (revive no próximo chunk); efeitos ímã, moedas x2 e patins; habilidades ativas da Rena (dash), do Boneco de Neve (esmaga obstáculos baixos) e da Fada (câmera lenta); passivas dos 5 heróis.
- **Servidor** (`RunSessions`): sorteia a seed, confere a posse de herói e capítulo, tem cooldown para iniciar, limita a distância pelo tempo real e as moedas pelas que existem na pista (recalculadas pela mesma seed). Credita moedas e recorde (leaderstats).
- **Juice:** FOV pela velocidade, tremida de câmera, poeira ao pousar, inclinação na troca de pista, moedas girando, tom da moeda subindo em sequência (os sons já estão ligados no código, mas sem ids ainda).
- **UI** provisória por escala: lobby (herói e capítulo), HUD, resultado com "Correr de novo" (1 toque).

### Não testado

- **Nada foi rodado no Studio ainda.** Não havia Rojo, Luau nem o MCP do Studio nesta máquina. Os dados dos chunks foram conferidos com uma cópia do validador; o resto precisa de um play test.
- Teste no emulador de celular (toque) e com 2 clientes ou mais.

### Limitações conhecidas (intencionais nesta fase)

- Perfis só em memória: moedas e recorde somem ao sair (falta ProfileStore; só ligar depois da sua confirmação).
- Sem loja, sem missões, sem calendário, sem chefes, sem multiplayer, sem obstáculos móveis e sem pisos especiais (gelo, esteira).
- Visual de blocos, sem sons (ids vazios) e textos em pt-BR provisórios.
- No trampolim, quem troca de pista no ar e cai dentro de um bloco bate como se fosse de frente.

### Próximos passos sugeridos

1. Play test da fase 1 no Studio e ajuste de `GameConfig` (velocidade, pulo, janela de tropeço).
2. Obstáculos móveis e pisos especiais por capítulo (esteira, gelo) + chunks próprios de cada capítulo.
3. Dados salvos (ProfileStore) + loja de heróis e melhorias.
4. Chefes (Ranzinza Verde e Rei do Gelo) como eventos com padrões de ataque.
5. Corrida multiplayer com a mesma seed (o gerador já está pronto para isso).
