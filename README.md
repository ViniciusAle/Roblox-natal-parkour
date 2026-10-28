# Brainrot Rush (Roblox), nome provisório

Runner infinito de 5 pistas com tema brainrot: criaturas originais (bicho + objeto, nomes de italiano inventado)
com raridade, três biomas cheios de comida gigante com olhos esbugalhados e corrida multiplayer na mesma pista.
O projeto nasceu como "O Livro de Natal", virou anime e, em 28/10/2026, virou brainrot por causa de direitos autorais
(ver [docs/STATUS.md](docs/STATUS.md)). O [Documento de Design](Documento%20de%20Design%20do%20Jogo%20O%20Livro%20de%20Natal%20(Roblox).md)
continua valendo para as regras de jogo (movimento, justiça da pista, servidor autoritativo).

## Como abrir no Roblox Studio

O código fica em arquivos `.luau` e é sincronizado com o Studio pelo [Rojo](https://rojo.space).

1. Instale o [Rokit](https://github.com/rojo-rbx/rokit) e rode `rokit install` nesta pasta (instala o Rojo e o Luau das versões fixadas em `rokit.toml`).
2. No Studio, instale o plugin do Rojo (Plugins → Manage Plugins, ou `rojo plugin install`).
3. Nesta pasta, rode:

```bash
rojo serve
```

4. Abra um lugar vazio (Baseplate) no Studio, clique em **Connect** no plugin do Rojo e depois em **Play**.
5. Só na primeira vez: com o Rojo conectado (fora do Play), cole `tools/ImportModels.lua` na Command Bar (View → Command Bar) para baixar os modelos do cenário e salve o lugar.

Se preferir gerar um arquivo de lugar sem o plugin:

```bash
rojo build -o BrainrotRush.rbxlx
```

> No Studio todos os personagens e fases ficam liberados para teste (`GameConfig.Dev`).

## Controles

| Ação | Celular | PC |
| --- | --- | --- |
| Trocar de pista | Deslizar para esquerda/direita | A/D ou setas |
| Pular (segurar = mais alto; segurar na queda = planar) | Deslizar para cima | Espaço, W ou seta para cima |
| Deslizar (no ar: cai rápido) | Deslizar para baixo | S, Ctrl ou seta para baixo |
| Habilidade do personagem | Botão PODER | E ou Shift |
| Modo brainrot (barra de caos cheia) | Botão MODO BRAINROT | Q ou R |

## Estrutura

```
src/
  shared/   -> ReplicatedStorage.Shared   (cliente e servidor)
    Config/      dados: números, personagens, raridades, fases, temas, receitas, chunks, habilidades, textos, sons
    PropAssembler    monta modelos a partir de receitas de peças
    ChunkGeometry, ChunkValidator, ChunkLibrary   chunks validados (rota livre garantida)
    TrackGenerator   seed -> sequência de chunks (determinístico)
    SpeedCurve, Remotes, Types
  server/   -> ServerScriptService.Server
    LobbyBuilder   praça italiana do lobby
    MatchService   fila, contagem e corrida multiplayer
    PlayerData     perfis (em memória por enquanto)
    RunSessions    seed, início/fim da corrida, validação de distância e moedas
  client/   -> StarterPlayer.StarterPlayerScripts.Client
    Main           logo -> praça -> corrida -> resultado
    RunSession     regras da corrida (colisão, coleta, efeitos, vida extra)
    Runner         movimento por coordenadas (sem física do Humanoid)
    Track, Pool, PropPool   pista com reaproveitamento de peças
    Hud, UiKit     interface (logo, cartão do lobby, HUD, resultados)
    Music, Juice   música por fase e efeitos sonoros
    Input, CameraRig, RunnerView, GhostManager, ChaserView, AmbientFx, ChapterAmbience
```

## Como adicionar conteúdo (sem código novo)

- **Chunk:** nova entrada em `src/shared/Config/Chunks.luau` (pistas 1 a 5). Se for injusto, o `ChunkValidator` recusa e avisa no Output.
- **Personagem:** linha em `Heroes.luau` (com a raridade) + receita em `Props.luau` (função `creature`, medidas em studs; `swing` nas pernas) + nome em `Strings.luau`. Nunca copie modelos ou artes de outros jogos (ver o risco em `docs/ASSETS.md`).
- **Modelo 3D de personagem:** coloque um `Model` com o id do personagem (ex.: `TungTungSahur`) em `ReplicatedStorage.Assets.Characters`. O jogo usa o modelo no lugar da receita de peças. Registre origem e licença em `docs/ASSETS.md`.
- **Fase:** linha em `Chapters.luau` + tema em `Themes.luau` + nome em `Strings.luau` + música em `Sounds.Music`.
- **Som:** id em `Sounds.luau` + linha em `docs/ASSETS.md`.
- **Balanceamento:** todos os números ficam em `GameConfig.luau`.
