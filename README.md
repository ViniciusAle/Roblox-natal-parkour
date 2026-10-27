# O Livro de Natal (Roblox)

Runner infinito natalino de 3 pistas. A fonte da verdade do design é o
[Documento de Design](Documento%20de%20Design%20do%20Jogo%20O%20Livro%20de%20Natal%20(Roblox).md).
O andamento está em [docs/STATUS.md](docs/STATUS.md).

## Como abrir no Roblox Studio

O código fica em arquivos `.luau` e é sincronizado com o Studio pelo [Rojo](https://rojo.space).

1. Instale o [Rokit](https://github.com/rojo-rbx/rokit) e rode `rokit install` nesta pasta (instala o Rojo da versão fixada em `rokit.toml`).
2. No Studio, instale o plugin do Rojo (Plugins → Manage Plugins, ou `rojo plugin install`).
3. Nesta pasta, rode:

```bash
rojo serve
```

4. Abra um lugar vazio (Baseplate) no Studio, clique em **Connect** no plugin do Rojo e depois em **Play**.

Se preferir gerar um arquivo de lugar sem o plugin:

```bash
rojo build -o LivroDeNatal.rbxlx
```

> No Studio todos os heróis e capítulos ficam liberados para teste (`GameConfig.Dev`).

## Controles

| Ação | Celular | PC |
| --- | --- | --- |
| Trocar de pista | Deslizar para esquerda/direita | A/D ou setas |
| Pular (segurar = mais alto; segurar na queda = planar) | Deslizar para cima | Espaço, W ou seta para cima |
| Deslizar (no ar: cai rápido) | Deslizar para baixo | S, Ctrl ou seta para baixo |
| Habilidade do herói | Botão PODER | E ou Shift |

## Estrutura

```
src/
  shared/   -> ReplicatedStorage.Shared   (cliente e servidor)
    Config/      tabelas de dados: números, heróis, capítulos, chunks, habilidades, vilões, textos, sons
    ChunkGeometry, ChunkValidator, ChunkLibrary   chunks validados (rota livre garantida)
    TrackGenerator   seed -> sequência de chunks (determinístico)
    SpeedCurve, Remotes, Types
  server/   -> ServerScriptService.Server
    PlayerData     perfis (em memória por enquanto)
    RunSessions    seed, início/fim da corrida, validação de distância e moedas
  client/   -> StarterPlayer.StarterPlayerScripts.Client
    Main           lobby -> corrida -> resultado
    RunSession     regras da corrida (colisão, coleta, efeitos, vilão, vida extra)
    Runner         movimento por coordenadas (sem física do Humanoid)
    Track, Pool    montagem da pista com reaproveitamento de peças
    Input, Hud, CameraRig, RunnerView, ChaserView, Juice, ChapterAmbience
```

## Como adicionar conteúdo (sem código novo)

- **Chunk:** nova entrada em `src/shared/Config/Chunks.luau`. Se for injusto (bloqueia as 3 pistas, invade a margem, sobrepõe obstáculos), o `ChunkValidator` recusa e avisa no Output.
- **Herói:** linha em `Heroes.luau` + nome em `Strings.luau`.
- **Capítulo:** linha em `Chapters.luau` + entrada em `Chapters.Order` + nome em `Strings.luau`.
- **Power-up:** linha em `Abilities.PowerUps` (efeito como dados: velocidade, invulnerável, ímã, multiplicador...).
- **Balanceamento:** todos os números ficam em `GameConfig.luau`.
