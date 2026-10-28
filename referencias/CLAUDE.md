# CLAUDE.md: O Livro de Natal (Roblox)

Jogo de corrida infinita natalina de 3 pistas para Roblox, para celular e PC, com 5 heróis, 3 capítulos (Vila de pão de mel, Fábrica de brinquedos, Polo Norte à noite), vilões, habilidades e loja. O Claude Code trabalha conectado ao Roblox Studio pelo servidor MCP embutido.

## Leia antes de qualquer trabalho

1. O documento de design do jogo (regras, personagens, pista, economia, arquitetura).
2. `docs/arte/ARTE-GERAL.md`: regras visuais de todos os capítulos.
3. `docs/arte/CAP1-vila-pao-de-mel.md`, `CAP2-fabrica-de-brinquedos.md` ou `CAP3-polo-norte.md`: o capítulo em que vai trabalhar.
4. `REFERENCIAS/README.md` e as imagens do capítulo. Abra e olhe as imagens.

Os caminhos acima são a proposta; ajuste ao que existe no repositório.

## Regras de trabalho

- Uma passada por vez: um capítulo e um aspecto (luz, pista, cenário, interface) por prompt.
- Antes de mudanças grandes, diga o plano em 3 a 5 linhas e espere o ok.
- Depois de toda mudança visual: `screen_capture` em 3 pontos (câmera de jogo, visão alta, close do herói), compare com as referências e com a checklist do guia, corrija e só então entregue, mostrando antes e depois.
- Referência é inspiração: traduza o clima, não copie detalhes nem textos.
- Não invente estilo. Valores do guia mandam; se calibrar um valor, atualize o guia no mesmo commit.
- Itens marcados como "Assumido" valem até o usuário mudar; itens "Em aberto" exigem pergunta antes.
- Em dúvida entre duas opções boas, recomende uma e explique em 2 linhas.
- Antes de apagar, reestruturar ou mexer em dados salvos (DataStore), peça confirmação.
- Commits pequenos, com capítulo e aspecto na mensagem (por exemplo, `cap1: iluminação do entardecer`).

## Ferramentas do Studio (MCP)

- Com mais de um Studio aberto, use `list_roblox_studios` e passe o `studio_id` certo em toda chamada.
- `screen_capture` para ver o resultado, `start_stop_play` e o subagente de playtest para testar, `get_console_output` para erros, `inspect_instance` e `search_game_tree` para checar a estrutura, `execute_luau` para ajustes rápidos.
- Para modelos mais complexos, `generate_mesh` e `generate_procedural_model` (com imagem de referência) podem ajudar; confira sempre o resultado na captura e o número de triângulos.

## Código

- Luau com tipagem estrita (`--!strict`), módulos pequenos de uma responsabilidade.
- Identificadores em inglês; comentários curtos em português só onde não for óbvio.
- Sem números mágicos: velocidades, durações, preços, dificuldades e perfis de luz vivem em módulos de configuração.
- Conteúdo novo (herói, habilidade, capítulo, chunk, conjunto de cenário) é uma linha de configuração, não código novo.
- Sem criar objetos a cada quadro: use reaproveitamento (pooling).
- O servidor é dono de moedas, compras, inventário e resultados. Nunca confie no cliente.

## Regras visuais essenciais (detalhes no guia de arte)

- Visual de brinquedo: formas simples, cores chapadas, `SmoothPlastic`, neve grossa em tudo, contraste quente contra frio.
- Nada de objeto sólido dentro do corredor da pista; cenário em 4 camadas.
- Perigo é vermelho com listras; recompensa é dourada; power-up é violeta. O cenário nunca imita esses códigos perto da pista.
- Herói opaco, com contorno, legível a 120 px de altura.
- Nenhum botão sem texto ou ícone; interface por escala, testada no emulador de celular.
- Peças de cenário: `Anchored`, sem colisão, `CastShadow` desligado nas pequenas.

## O que não fazer

- Usar propriedade intelectual de terceiros (Grinch, personagens de estúdios, músicas sem licença).
- Mudar luz, pista, cenário e interface na mesma entrega.
- Entregar sem olhar a captura de tela.

## Idioma

Conversar em português. Código em inglês. Idioma dos textos do jogo: em aberto, pergunte.
