# Status do projeto

## Sessão 29/10/2026 (parte 4): o jogo congelava ao entrar

- **Causa (log do Studio):** `PropPool:168: Script timeout`. A pré-carga reescalava um modelo enorme (o Coliseu)
  e o script estourou o tempo; o Studio ficou travado.
- **Fundo só com montanhas:** saíram Coliseu, farol, galeão, Saturno, disco voador e torres alienígenas do fundo.
  Praça e praia usam `MountainGreen`; espaço usa a receita `MistyMountain`. Os modelos saíram de `Config/Models`.
- **Limite de peças:** modelo da loja com mais de `Scenery.MaxModelParts` (300) peças não entra; usa a receita de reserva
  e avisa no Output (`[ModelLibrary] ... peças`).
- Não testado no Studio.

## Sessão 29/10/2026 (parte 3): lag no celular e Bombardiro

- **Bombardiro continuava o antigo:** o `ImportModels.lua` pulava personagens que já existiam (e o arquivo estava vazio no disco;
  foi reescrito). Agora cada modelo importado guarda o atributo `AssetId`; se o id em `Config/Heroes` mudar, o modelo é trocado sozinho.
  O importador também avisa os modelos com mais de 150 peças.
- **Lag:**
  - Personagem: as transparências de todas as peças eram reescritas a cada frame; agora só quando o piscar muda.
  - Modelos da loja (personagem e cenário) ficam soldados numa raiz ancorada (`ModelLibrary.weldToRoot`): mover = mover uma peça.
  - A pré-carga pausa durante a corrida e já deixa cada modelo na escala de uso (`ScaleTo` é caro).
  - Menos cenário: 4 props por lado e decoração a cada 9 studs; em celular/tablet, 60% disso e 4 chunks à frente (`Scenery.Mobile`).
  - Medidor no Studio: frames acima de 33 ms aparecem no Output como `[Lag]`, com o tempo do script e o que a pista fez no frame.
- Não testado no Studio.

## Sessão 29/10/2026 (parte 2): travamentos nas trocas de tela e modelos dos brainrots

- **Travamento ao jogar de novo / voltar ao lobby / entrar no mapa:** cada corrida clonava todos os modelos da loja
  e destruía tudo no fim. Agora `PropPool.shared()` e os pools de peças da `Track` ficam em pastas que sobrevivem às
  corridas (`Workspace.PropCache`, `Workspace.TrackCache`); `Track.prewarm()` clona os modelos de todas as fases aos poucos
  enquanto o jogador está no lobby, e esconder o que saiu de uso também é feito aos poucos.
- **Frente dos modelos:** a direção vem da PrimaryPart (só o giro horizontal) ou da raiz do Humanoid; `rot` corrige o resto.
- **Tralalero ficava em pé ao deslizar:** modelos deitados (mais compridos que altos) agora encolhem ao deslizar.
- **Bombardiro:** trocado pelo 91327024837680 (F0g_02), o crocodilo-avião do meme.
- Não testado no Studio.

## Sessão 29/10/2026: travamentos, Coliseu e modelos prontos dos brainrots

- **Micro travamentos:** cada novo chunk montava ~35 props de cenário (modelos da loja com muitas peças) num frame só.
  Agora o cenário entra numa fila em `Track` e é montado com orçamento de 2 ms por frame; o início da corrida monta tudo de uma vez.
- **Coliseu deitado/torto:** `ModelLibrary` media a caixa pela PrimaryPart do modelo, que vinha girada. Agora mede nos eixos do mundo;
  se um modelo ainda vier torto, use o campo `rot` em `Config/Models`.
- **Modelos prontos dos brainrots:** a loja tem vários. Escolhi um de cada (sem scripts) no campo `model` de `Config/Heroes`;
  o `ImportModels.lua` agora também baixa esses para `Assets.Characters`. Modelos sem esqueleto quicam e rebolam por código.
  Se algum vier de costas ou deitado, use `model.rot` (ex.: `Vector3.new(0, 180, 0)`).
- Não testado no Studio.

## Sessão 28/10/2026 (parte 6): brainrots famosos

O usuário decidiu usar os brainrots famosos, sabendo do risco (pedido de marca do "Tralalero Tralala", remoção do
Tung Tung Tung Sahur no Steal a Brainrot, processo por cópia de arte). Detalhes em `docs/ASSETS.md`.

- Comum **Brr Brr Patapim**; Raro **Ballerina Cappuccina** (Pirueta turbo); Épico **Tung Tung Tung Sahur** (Tacada Sahur);
  Lendário **Tralalero Tralala** (Tralala lento); Secreto **Bombardiro Crocodilo** (Bombardeio).
- Montados do zero com peças (`HeroPatapim`, `HeroBallerina`, `HeroTung`, `HeroTralalero`, `HeroBombardiro` em `Config/Props`).
- As criaturas originais da parte 5 ficaram como reserva, para trocar rápido se algum famoso receber denúncia.
- Nome do jogo e logo continuam originais. Não testado no Studio.

## Sessão 28/10/2026 (parte 5): o jogo virou Brainrot Rush

O tema anime tinha problema de direitos autorais (o usuário queria personagens de Dragon Ball). O usuário pediu para
refazer tudo com tema brainrot. O motor da corrida (pistas, chunks, servidor, energia, poderes) ficou igual; mudou o tema.

### Decisões

- **Nome provisório:** Brainrot Rush ("Corra. Desvie. Fique maluco.").
- **Personagens originais**, no estilo brainrot (bicho + objeto, nome de italiano inventado). Ficaram de fora os memes
  existentes (Tralalero Tralala, Tung Tung Tung Sahur, Bombardiro Crocodilo, Lirilì Larilà, Frigo Camelo, Il Cacto Hipopotamo,
  Dragon Cannelloni etc.), porque têm donos e alguns viraram marca registrada. Também evitei combinações muito parecidas com eles.
  - Comum: **Pollo Polpetto**, almôndega com pernas de galinha e um garfo espetado.
  - Raro: **Lumaca Lampadina**, lesma de tênis com uma lâmpada acesa no lugar da concha (poder: Gosma turbo).
  - Épico: **Granchio Gelatino**, caranguejo com casquinha de três bolas de sorvete (poder: Pinça esmagadora).
  - Lendário: **Gufo Sveglietta**, coruja-despertador com sinos e chave de corda (poder: Soneca do tempo).
  - Secreto: **Balena Mongolfiera**, baleia-balão de coroa e cesto, de tênis rosa (poder: Jato d'água, destrói o obstáculo à frente).
- **Fases:**
  - **Piazza Pizza:** praça italiana. Obstáculos: caixas de pizza, arco de grissini com espaguete pendurado e cafeteira moka gigante de bigode.
  - **Spiaggia Banana:** praia. Obstáculos: castelo de areia, banana gigante com toalhas penduradas e coco de canudinho.
  - **Cosmo Caotico:** espaço roxo neon. Obstáculos: rochas de cristal, disco voador abduzindo uma pizza e foguete.
  - Todos os obstáculos grandes têm olhos esbugalhados virados para o jogador.
- **Lobby:** praça italiana com canais, cafeteira gigante com a placa do jogo, arco de espaguete, ciprestes, casas coloridas, fontes, mesinhas de café, lambretas e confete.
- **Interface:** roxo-uva, rosa-choque, verde-limão e amarelo; títulos em adesivo torto; logo "BRAINROT RUSH".
- **Textos:** a energia virou "CAOS" e a transformação virou "MODO BRAINROT".
- **Música:** acordeão italiano (lobby), tarantela, música praiana e techno (contas oficiais APM e DistroKid).

### Feito no código

- Personagens feitos de peças (`creature` em `Config/Props`), com rebolado e pernas que balançam ao correr (`swing`, em `RunnerView`).
- 6 obstáculos novos em receitas; 21 modelos novos da Creator Store em `Config/Models` (os da vila japonesa saíram).
- O fundo agora aceita `elevation` (Saturno e o disco voador flutuam).
- Ids internos trocados: personagens, fases (`PizzaPiazza`, `BananaBeach`, `ChaosCosmos`), nomes de GUI e o projeto Rojo (`BrainrotRush`).
- A sintaxe de todos os arquivos passou no `luau-compile`.

### Não testado

- Nada desta parte rodou no Studio.
- É preciso rodar `tools/ImportModels.lua` de novo para baixar os modelos novos.
- Os modelos antigos da vila japonesa podem ser apagados de `ReplicatedStorage.Assets.Props`, assim como os corpos R15 antigos de `Assets.Characters`.
- Algum modelo pode falhar ("not authorized"); nesse caso entra a receita reserva e eu troco o id.

## Sessão 28/10/2026 (parte 4): transformação, rajada e aura

O usuário decidiu seguir com os personagens originais e pediu poderes de "anime de luta".

### Feito

- **Energia:** enche com moedas (+2) e distância (+0,12 por metro) até 100 (`GameConfig.Energy`). Aparece numa barra embaixo das moedas.
- **Transformação** (botão TRANSFORMAR, ou teclas Q ou R, com a energia cheia):
  - 7 s mais rápido (x1,2), imune a batidas e puxando moedas (`Abilities.Transform`);
  - visual: aura forte, luz, contorno brilhante (Highlight) e rastro mais longo, na cor do personagem;
  - não multiplica moedas, para ficar dentro do limite que o servidor aceita.
- **Rajada de energia** (habilidade do Ryuga): destrói o primeiro obstáculo à frente na pista do personagem, até 70 studs, com explosão de partículas. Sem alvo à frente, a recarga não é gasta.
- **Rastro de energia** sempre ligado, em todos os personagens; aura sempre ligada a partir de Épico.
- **Sons novos:** Thunder Crack (transformação) e Blaster Burst (rajada).

### Não testado

- Nada desta parte rodou no Studio.


## Sessão 28/10/2026 (parte 3): ajustes depois do primeiro teste com modelos

Problemas que o usuário viu nos prints, e as correções:

- **Personagens com tamanho e posição diferentes.** A escala e os pés agora são medidos pela raiz e pela cabeça do corpo R15, e não pela caixa do modelo (cabelos e acessórios longos distorciam a medida).
- **Obstáculos amontoados nas bordas; dava para passar a fase parado no meio.**
  - Os 22 chunks foram refeitos com fileiras e zigue-zagues.
  - Regra nova no `ChunkValidator`: fora dos especiais, toda pista tem pelo menos um obstáculo.
  - Os blocos ficaram mais curtos (até 26 studs) para não virar fileira de casas.
- **Mapa "morto".**
  - 5 props por lado (eram 3);
  - decoração pequena a cada ~7 studs (arbustos, pedras, flores, lanternas, cogumelos brilhantes, cristais);
  - cerca japonesa contínua na Vila Ninja;
  - fundo dos dois lados.
  - São 15 modelos novos em `Config/Models`. É preciso rodar `tools/ImportModels.lua` de novo para baixar só os novos.
- **Personagens de Dragon Ball:** pedidos de novo; continuam originais.


## Sessão 28/10/2026 (parte 2): personagens R15 e cenário com modelos prontos

O usuário achou o visual de peças "parecendo jogo de 1990" e pediu assets prontos do Roblox.

### Feito

- **Personagens:**
  - corpos R15 montados pelo servidor (`CharacterBuilder`) com itens de avatar criados pelo Roblox (cabelo, camisa, calça, cor de pele, escala), definidos em `Heroes.avatar`;
  - animações padrão do Roblox de corrida, pulo, queda e parado;
  - continuam originais (o usuário pediu de novo os personagens de Dragon Ball; mantive a recusa pelo risco de direitos autorais).
- **Cenário:**
  - 22 modelos gratuitos da Creator Store (`Config/Models`), escolhidos pelas miniaturas;
  - usados no cenário lateral, no fundo e no lobby;
  - encaixados por escala uniforme na caixa de cada prop (`ModelLibrary`);
  - sem o modelo importado, cai na receita de peças.
- **Obstáculos:** continuam em receitas de peças, porque a forma precisa bater com a caixa de colisão.
- **Importação:** `tools/ImportModels.lua`, para colar uma vez na Command Bar do Studio.

### Não testado

- Nada rodou no Studio. Falta conferir:
  - a importação (`game:GetObjects`);
  - a escala e a orientação dos modelos;
  - se o corpo R15 anima com a raiz ancorada;
  - se `CreateHumanoidModelFromDescription` aceita todos os itens.

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
