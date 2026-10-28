# ARTE-GERAL: regras visuais para todos os capítulos

Oct 27, 2026 · @Euclides

## 1. Como usar este guia

Este guia diz ao Claude Code como o jogo deve **parecer**; o documento de design diz como ele funciona. Para qualquer trabalho visual, leia os arquivos nesta ordem e só então mexa no Studio.

### Ordem de leitura

1. `CLAUDE.md` na raiz do repositório.
2. O documento de design do jogo (regras, personagens, pista, economia).
3. Este arquivo, `ARTE-GERAL`.
4. O guia do capítulo em que você vai trabalhar (`CAP1`, `CAP2` ou `CAP3`).
5. `REFERENCIAS/README` e as imagens da pasta do capítulo. **Abra e olhe as imagens**, não basta ler o nome.

### Convenção de marcação

- **Regra:** obrigatório. Só muda se o usuário mandar.
- **Proposta:** valor inicial. Calibre com captura de tela e playtest no celular, e registre o valor final aqui.
- **Assumido:** decisão provisória que o usuário ainda não confirmou. Siga, mas avise quando a decisão afetar o resultado.
- **Em aberto:** não decidido. Pergunte antes de escolher.

### Regras de trabalho

- **Uma passada por vez:** um capítulo e um aspecto por prompt (por exemplo, "Capítulo 1, só iluminação"). Não misture luz, pista, cenário e interface na mesma entrega.
- **Referência é clima, não cópia:** extraia silhueta, paleta, luz e ritmo. Não reproduza detalhes de ilustração nem use as imagens como textura.
- **Sempre veja o que fez:** depois de cada mudança visual, use `screen_capture` em pelo menos 3 pontos de vista (câmera de jogo atrás do herói, visão alta da pista, close do herói), compare com a referência e com a checklist, corrija e só depois entregue.
- **Mostre antes e depois** quando o usuário pedir correção de algo que ele apontou.
- **Não invente estilo:** se um valor não estiver aqui, proponha uma opção com recomendação e pergunte.
- **Registre decisões:** quando um valor da "Proposta" for calibrado, atualize este guia no mesmo commit.
- **Commits pequenos**, com mensagem dizendo capítulo e aspecto (por exemplo, `cap1: iluminação do entardecer`).

## 2. Decisões assumidas (a confirmar)

Estas decisões ainda não foram confirmadas pelo usuário e seguem a recomendação feita na conversa; o Claude Code deve segui-las e avisar se alguma gerar problema.

| Decisão | Valor assumido | Por quê |
| --- | --- | --- |
| Luz do capítulo 1 | Entardecer dourado | Janelas acesas aparecem contra o céu, mas o clima continua doce (ref 1) |
| Luz do capítulo 2 | Dia claro, interior iluminado | Contraste com os outros dois e paleta viva (ref 4) |
| Luz do capítulo 3 | Noite profunda azul-roxa | Cordões de luz e janelas quentes brilham mais (ref 5) |
| Capítulo 3: estilo | Híbrido: vila de Natal à noite com cordões de luz e janelas quentes; ciano só nas linhas das pistas e na aurora | A ref 5 é quente; o neon ciano da primeira versão foi o visual mais forte e fica como detalhe |
| Capítulo 2: espaço | Salão sem teto: paredes com janelas grandes nos lados; vigas e lâmpadas no alto, acima da câmera | O teto bloquearia a câmera |
| Progressão de luz | Entardecer, dia claro, noite | Dá sensação de passar páginas de um livro com momentos diferentes |
| Estilo de peças | Formas simples, cantos arredondados, cores chapadas, pouca textura | Roda bem em celular e combina com o diorama de brinquedo |
| Repositório | Cenário vive no lugar (place) do Studio; scripts no repositório. Se usarem Rojo, os scripts ficam em `src/` | Evita conflito de arquivo binário entre duas pessoas |

### Em aberto

- **Nome final do jogo** e logotipo (o título atual é provisório).
- **Estilo dos heróis:** modelos próprios feitos de peças ou personagens do Roblox ajustados com acessórios. Ver seção 9.
- **Música e sons:** origem e licença.

## 3. Princípios visuais e unidade entre capítulos

O jogo parece um livro de histórias de Natal montado como maquete de brinquedo; cada capítulo muda de cor e de luz, mas todos compartilham as mesmas formas, os mesmos heróis e a mesma linguagem de interface.

### Os seis princípios

1. **Brinquedo, não realismo:** formas simples e arredondadas, cores chapadas, acabamento liso. Nada de textura fotográfica.
2. **Calor contra frio:** janelas, luzes e itens acesos em tons quentes (amarelo, laranja) sobre fundos frios (azul, roxo, branco). É a marca do jogo.
3. **Neve grossa:** todo telhado, poste, árvore e prédio tem uma capa de neve branca, grossa e ondulada, nunca um fio fino.
4. **Miniatura:** objetos grandes ficam sobre uma base de neve, como peças de uma vila de coleção (ref 2).
5. **Legibilidade antes de beleza:** o jogador precisa ver faixas, obstáculos e moedas em menos de meio segundo. Cenário nunca compete com a pista.
6. **Poucas cores por capítulo:** poucas cores vivas por capítulo (a paleta de cada capítulo lista todas). Cor fora da paleta só em itens de gameplay.

### O que muda e o que fica igual

| Elemento | Muda por capítulo | Fica igual |
| --- | --- | --- |
| Paleta | Sim | Regra de poucas cores |
| Luz e céu | Sim | Contraste quente contra frio |
| Materiais | Parcialmente | Superfícies lisas, sem textura realista |
| Formas dos prédios | Sim (casa de biscoito, fábrica, vila) | Frontões, janelas arredondadas, capa de neve |
| Pista | Textura e cor da superfície | Largura, 3 faixas, trilhos nas bordas |
| Heróis e vilões | Não | Mesmos modelos nos três capítulos |
| Coletáveis e obstáculos | Aparência temática | Cores de perigo e recompensa (seção 8) |
| Interface | Não | Mesmo kit visual |

### O conceito O Livro de Natal

Cada capítulo é uma página. A moldura do jogo, a transição e algumas decorações (cantos de página, fitas de marcador) lembram um livro. Ver seção 11 para a transição.

## 4. Escala, pista e corredor livre

A pista é um corredor de largura fixa e o cenário se organiza em zonas de distância e de altura em volta dela, para que nada tape a visão do jogador. Todos os valores são **proposta**: confirme com captura de tela e playtest no celular.

### Medidas da pista (em studs)

| Item | Valor | Observação |
| --- | --- | --- |
| Largura de cada faixa | 8 | 3 faixas dão 24 de largura útil |
| Divisória entre faixas | 0,4 de largura, cor contrastante | Mais fina que o trilho; visível a 40 studs |
| Trilho lateral | 2 de largura, 1,2 de altura | Separa pista de cenário; cor forte do capítulo |
| Comprimento do chunk | 60 | Valor do documento de design |
| Altura livre acima da pista | 30 | Nada pendurado aqui, nem lâmpadas, exceto cordões acima de 18 (ver capítulo 3) |
| Altura do herói | 5 (referência) | Todo cenário é medido em relação a ele |

### Zonas laterais (a partir da borda externa do trilho)

| Zona | Distância | Altura máxima | O que pode ficar aqui |
| --- | --- | --- | --- |
| Calçada | 0 a 4 | 3 | Só detalhes baixos e leves: placas, luzinhas, bengalas curtas, neve acumulada |
| Corredor próximo | 4 a 14 | 12 | Postes, árvores pequenas, cercas, caixas de presente, trilhos secundários |
| Meio | 14 a 40 | 30 | Casas, vitrines, máquinas, árvores grandes. Aqui mora a maior parte do cenário |
| Fundo | 40 a 200 | Sem limite | Prédios-marco, morros, montanhas, silhuetas |

### Regras

- **Regra:** nunca colocar objeto sólido dentro do corredor da pista que não seja obstáculo de gameplay.
- **Regra:** o que fica a menos de 4 studs da pista precisa ser baixo ou transparente, para não cortar a visão das faixas.
- **Regra:** a câmera de jogo fica atrás e acima do herói; objetos entre a câmera e a pista não devem existir (verifique na captura de tela).
- **Proposta:** a câmera fica cerca de 12 studs atrás e 6 acima do herói, olhando um pouco para baixo. Ajuste e registre o valor final.
- **Regra:** a linha do horizonte fica no terço superior da tela na câmera de jogo, deixando 2/3 da imagem para a pista e o cenário próximo.

## 5. Camadas, ritmo e densidade do cenário

O cenário precisa de profundidade em camadas e de um ritmo repetido, porque a primeira versão tinha campos grandes e vazios de neve e poucos objetos; cada chunk de 60 studs deve parecer "cheio" de longe e de perto.

### Quatro camadas obrigatórias

1. **Primeiro plano:** pequenos detalhes rente à pista (luzes, bengalas, caixas, cercas baixas). Passam rápido e dão sensação de velocidade.
2. **Plano médio:** casas, árvores, máquinas e vitrines. É o cenário principal.
3. **Plano de fundo:** prédio-marco, morros, montanhas. Muda devagar.
4. **Céu e horizonte:** cor, estrelas, nuvens, luz do ambiente.

### Ritmo e densidade (propostas)

| Camada | Densidade por chunk de 60 studs, de cada lado | Observação |
| --- | --- | --- |
| Primeiro plano | 4 a 6 itens | Repetir um padrão (poste, bengala, caixa) e variar a cada 3 chunks |
| Plano médio | 2 a 3 objetos grandes e 3 a 4 pequenos | Nunca dois objetos grandes iguais seguidos |
| Plano de fundo | 1 elemento por chunk, repetido com variação | Em alturas e distâncias diferentes |
| Chão vazio | No máximo 25% da área visível | Preencher com neve em relevo, pegadas, montes |

### Variação

- Cada chunk usa um **conjunto de cenário** escolhido por sorteio entre 3 a 5 variantes, para a repetição não ser óbvia.
- Alterne o lado dos objetos maiores (esquerda e direita) para a pista ter ritmo.
- A cada 8 a 10 chunks entra um **momento especial** (grupo de presentes, ponte, trem, árvore gigante) para quebrar a repetição.
- Um **prédio-marco** visível ao fundo a cada 300 a 400 studs ajuda o jogador a sentir progresso.

### Regras

- **Regra:** o cenário se repete em ciclos, mas nunca com o mesmo objeto na mesma posição em dois chunks seguidos.
- **Regra:** o cenário dos dois lados não precisa ser simétrico; a simetria exata parece artificial.
- **Regra:** conteúdo de cenário usa tabelas de configuração (conjuntos por capítulo), como o resto do jogo.

## 6. Materiais e peças no Roblox

O visual de brinquedo vem de superfícies lisas, cores chapadas e poucas peças bem colocadas; o orçamento de peças é limitado porque a maior parte dos jogadores está em celular.

### Materiais

| Material | Use para | Evite |
| --- | --- | --- |
| SmoothPlastic | Quase tudo: casas, trilhos, caixas, postes, heróis, capas de neve dos telhados | Nada, é o padrão do jogo |
| Neon | Janelas acesas, luzes, moedas, linhas de pista, detalhes que brilham | Superfícies grandes (estoura o brilho) |
| Snow | Chão de neve do cenário distante | Em cima da pista ou em objetos pequenos (a textura vira ruído) |
| Ice | Pista de gelo do capítulo 3, blocos de gelo | Em muitos objetos ao mesmo tempo |
| Metal e DiamondPlate | Só no capítulo 2: engrenagens, braços, vigas | Fora da fábrica |
| Glass | Quase nunca; no capítulo 2 só se o desempenho permitir | Sobreposição de várias peças de vidro |
| WoodPlanks e Brick | Detalhes pontuais (portas, base de árvore); capítulo 3 pode usar tijolo em poucos prédios | Em prédios inteiros, para não parecer realista |
| Fabric | Toldos listrados do capítulo 3 | Fora disso |

### Como montar formas

- **Telhados:** peças em cunha (Wedge) com capa de neve em cima: um bloco branco levemente maior, com 2 a 3 esferas brancas nas pontas para parecer ondulado.
- **Contorno de glacê:** tiras brancas finas (0,2 a 0,4 de espessura) seguindo as bordas dos prédios e janelas.
- **Janelas:** peça Neon de cor quente, com moldura em outra cor e cantos de arco feitos com cilindro e esfera. Não use PointLight por janela.
- **Bengalas:** segmentos de cilindro alternando vermelho e branco, com o gancho feito por um arco de cilindros curtos.
- **Árvores:** cones empilhados (3 a 4 níveis) com enfeites esféricos coloridos e uma estrela ou bola no topo.
- **Base de miniatura:** disco ou bloco achatado de neve (SmoothPlastic branco) sob prédios e props grandes.
- **Formas complexas:** pode usar `generate_mesh` ou `generate_procedural_model` do MCP, sempre verificando o resultado na captura de tela e o número de triângulos.

### Orçamento de desempenho (propostas, medir no celular)

| Item | Limite |
| --- | --- |
| Casa ou prédio médio | até 60 peças |
| Árvore, poste ou bengala | até 8 peças |
| Prédio-marco | até 150 peças |
| Peças visíveis ao mesmo tempo, no total | cerca de 4000 |
| Luzes reais (PointLight, SpotLight) ativas na tela | até 6, só perto do herói ou nos marcos |
| Emissores de partículas ativos | até 10, com taxa baixa |

### Propriedades obrigatórias em todo cenário

- `Anchored = true`.
- `CanCollide = false`, `CanTouch = false` e `CanQuery = false`, a não ser que a peça seja de gameplay.
- `CastShadow = false` em peças pequenas (detalhes, enfeites, linhas finas).
- Evite `UnionOperation` (pesada); prefira peças simples ou malhas.
- Reaproveite objetos (pooling) em vez de criar e destruir a cada chunk, como diz o documento de design.
- Cores nunca em branco ou preto puro: use os tons da paleta (por exemplo, `#FFF8EE` em vez de `#FFFFFF`).

## 7. Luz e pós-processamento

Cada capítulo tem um perfil de iluminação próprio, guardado como configuração e aplicado com transição suave, porque a luz é o que mais separa um visual genérico de um visual com clima.

### Regras de luz

- **Regra:** hierarquia de brilho. A pista e os itens de gameplay são os mais claros e saturados; o plano médio tem brilho médio; o fundo é mais frio e menos contrastado.
- **Regra:** o herói nunca pode sumir contra a pista. Se o fundo atrás dele for escuro, ele precisa de contorno e de uma luz pequena (seção 9).
- **Regra:** brilho por Neon e Bloom, não por dezenas de luzes reais.
- **Regra:** perfis em módulo de configuração (`LightingProfiles`), aplicados por uma função que anima as propriedades em 1,5 a 2 s na troca de capítulo.
- **Proposta:** começar com a tecnologia de iluminação `ShadowMap`; testar `Future` só se o desempenho no celular de entrada permitir.

### Perfis iniciais (propostas, calibrar por captura de tela)

| Propriedade | Cap. 1 Vila (entardecer) | Cap. 2 Fábrica (dia claro) | Cap. 3 Polo Norte (noite) |
| --- | --- | --- | --- |
| `Lighting.ClockTime` | 17,5 a 18 | 13 | 0 |
| `Lighting.Brightness` | 2 | 3 | 1 |
| `Lighting.Ambient` | `#7B78A6` | `#A8B4C0` | `#2B2F66` |
| `Lighting.OutdoorAmbient` | `#B8A0A8` | `#C8D2C0` | `#4A4F9A` |
| `Lighting.ColorShift_Top` | `#FFC890` | `#FFF6DD` | `#6A6FCC` |
| `Lighting.ExposureCompensation` | 0,2 | 0 | 0,6 |
| `Atmosphere.Density` | 0,32 | 0,15 | 0,35 |
| `Atmosphere.Offset` | 0,15 | 0 | 0 |
| `Atmosphere.Color` | `#FFCFA6` | `#E6F2F7` | `#3A3F8F` |
| `Atmosphere.Decay` | `#FF9F6B` | `#CFE3EA` | `#101540` |
| `Atmosphere.Haze` | 1,2 | 0,4 | 2 |
| `BloomEffect.Intensity` | 0,4 | 0,25 | 0,9 |
| `BloomEffect.Size` | 20 | 16 | 32 |
| `BloomEffect.Threshold` | 1,2 | 1,4 | 0,8 |
| `ColorCorrectionEffect.Saturation` | 0,15 | 0,2 | 0,1 |
| `ColorCorrectionEffect.Contrast` | 0,08 | 0,05 | 0,1 |
| `ColorCorrectionEffect.TintColor` | `#FFF0E0` | `#FFFCEE` | `#E6EAFF` |
| `SunRaysEffect.Intensity` | 0,08 | 0,03 | 0 |
| `Sky.StarCount` | 0 a 200 | 0 | 3000 |

### Efeitos opcionais

- **DepthOfFieldEffect** com desfoque leve ao longe (proposta: `FarIntensity` 0,15, `FocusDistance` 60, `InFocusRadius` 40) dá efeito de miniatura. Meça o custo: desligue no celular de entrada se o FPS cair.
- **Luz do herói:** `PointLight` pequena no capítulo 3 (proposta: `Brightness` 1,2, `Range` 14, cor `#FFD9A0`).

### Céu

- Capítulo 1: horizonte pêssego `#FFC9A0` subindo para azul-acinzentado `#6F86B8` (ver ref 1).
- Capítulo 2: céu azul claro `#9ED8F0` visto pelas janelas e pelo topo aberto.
- Capítulo 3: topo `#101540`, meio `#3A3F8F`, horizonte rosado `#C7799A`, com estrelas e aurora (ver capítulo 3).
- Se não houver imagens de céu customizadas, obtenha o efeito com `ClockTime`, `Atmosphere` e `ColorShift`; céu customizado só se o usuário fornecer ou aprovar a imagem.

## 8. Legibilidade de jogo

O jogador precisa distinguir faixa, perigo e recompensa em menos de meio segundo, em qualquer capítulo; por isso a pista e os itens de gameplay têm um código de cor e de forma que vale para o jogo inteiro e que o cenário nunca imita.

### Código de cor e forma

| Tipo | Cor | Forma | Brilho | Movimento |
| --- | --- | --- | --- | --- |
| Recompensa (moedas) | Dourado `#FFC93C` com detalhes brancos | Bala embrulhada, estrela ou presente pequeno, arredondado | Neon leve | Gira e flutua |
| Perigo (obstáculo) | Vermelho forte e preto-azulado, listras diagonais | Blocos fechados, pontiagudos ou com listras | Sem brilho | Parado ou móvel com aviso |
| Power-up | Violeta `#B56BFF` com anel branco | Esfera ou estrela dentro de um anel | Neon forte | Pulsa |
| Faixa e divisória | Cor da pista do capítulo | Linhas finas e contínuas | Sem brilho | Nenhum |
| Trilho lateral | Cor forte do capítulo | Barra baixa | Sem brilho | Nenhum |

**Regra:** a cor de perigo (vermelho com listras) **nunca** aparece em decoração de cenário perto da pista. Se o capítulo usa vermelho em toldos ou postes, mantenha a mais de 14 studs e sem listras diagonais. Exceção: os trilhos laterais lisos, na cor do capítulo.

### Pista e faixas

- **Regra:** as divisórias das faixas têm mais contraste e peso visual que qualquer emenda de ladrilho ou textura da pista. Se a pista tem desenho de ladrilho, ele precisa ser bem mais sutil (menos contraste) que a divisória.
- A superfície da pista tem cor e brilho médios, de modo que dourado, vermelho e ciano apareçam sobre ela.
- Cada capítulo define a cor da divisória (ver guias dos capítulos).
- Trilho lateral numa cor viva do capítulo, com altura suficiente para o jogador ver os limites, mas sem tapar o cenário.

### Moedas (coletáveis)

- **Problema visto:** a linha amarela contínua no centro da pista parecia um laser. Moedas devem ser **objetos separados**, com formato reconhecível (bengala, presente, estrela), em fileiras com espaço entre elas (proposta: 4 studs).
- Tamanho proposto: 2 a 2,5 studs. Cada moeda gira devagar e flutua cerca de 0,5 stud.
- Moedas ficam a uma altura que o herói alcança sem pular (cerca de 2,5 studs do chão), e em arcos quando exigem pulo.
- Efeito ao coletar: faísca curta, som com tom subindo a cada moeda seguida (ver documento de design).

### Obstáculos

- Cada tipo de obstáculo tem formato **inconfundível** do tipo (documento de design, seção 5): baixo parece pequeno e largo, alto parece uma barra no alto, bloco inteiro parece um muro.
- **Aviso de obstáculo móvel:** sombra ou listras de alerta no chão uns 20 studs antes.
- Contraste mínimo: o obstáculo precisa se destacar da pista e do fundo na captura de tela (verificar no escuro do capítulo 3, onde a primeira versão falhou).
- Obstáculos têm a mesma silhueta nos três capítulos; só mudam o tema (caixa de presente, engrenagem, bloco de gelo).

### Teste de legibilidade

Tire uma captura da câmera de jogo, converta-a mentalmente para tons de cinza e pergunte: ainda dá para ver faixas, obstáculos e moedas? Se não, aumente o contraste de brilho, não de cor.

## 9. Heróis

O herói é o objeto mais olhado da tela e precisa ser reconhecível pela silhueta, ter contraste com a pista em qualquer capítulo e parecer parte do mesmo brinquedo; na primeira versão ele era translúcido, marrom sobre marrom ou sumia no escuro.

### Regras para todos os heróis

- **Regra:** corpo 100% opaco (`Transparency = 0`). Só asas, auras e efeitos podem ser translúcidos.
- **Regra:** silhueta reconhecível a 120 px de altura na tela do celular. Teste reduzindo a captura de tela.
- **Regra:** cada herói tem 3 traços marcantes (seção abaixo) e uma cor dominante que não se confunde com a pista nem com os outros heróis.
- **Regra:** proporções de brinquedo: cabeça grande (cerca de 40% da altura), corpo compacto, membros curtos, pés largos. Altura total de referência: 5 studs.
- **Regra:** rosto simples: dois olhos escuros com um ponto branco de brilho, boca mínima ou nenhuma.
- **Contorno:** instância `Highlight` no herói com `FillTransparency = 1`, `OutlineColor` `#FFF1C2` e `OutlineTransparency` em torno de 0,2. Ajuste a cor por capítulo se o contraste falhar (por exemplo, azul-gelo no capítulo 1). Limite de `Highlight` simultâneos no jogo: use só nos heróis dos jogadores da partida.
- **Sombra no chão:** disco achatado escuro e translúcido sob o herói, que encolhe e clareia quando ele pula. Dá noção de altura e de pista.
- **Rastro:** `Trail` curto na cor do herói (aparece mais com velocidade alta).
- **Luz própria:** no capítulo 3, `PointLight` pequena no herói (ver seção 7).

### Animação (procedural)

- **Correr:** balanço de braços e pernas por script (Motor6D) e leve sobe-e-desce do corpo, ritmo ligado à velocidade.
- **Pular, deslizar, trocar de pista:** inclinação do corpo para o lado da troca; alongar na subida e achatar ao pousar (valores pequenos, cerca de 8 a 12%).
- **Tropeçar:** tremida curta e perda de velocidade, com partículas de neve.
- Todos os números vão em configuração; a animação não pode depender de assets externos de animação.

### Os cinco heróis

| Herói | 3 traços marcantes | Cores principais | Cuidado |
| --- | --- | --- | --- |
| Duende Corredor | Chapéu pontudo com guizo, orelhas pontudas, cinto largo | Verde `#2E9E5B`, vermelho `#D8374B`, pele `#F2C9A0` | Não copiar os duendes desenhados da referência 4 |
| Papai Noel | Gorro com pompom, barba branca grande, barriga redonda com cinto dourado | Vermelho `#D8374B`, branco `#FFF8EE`, cinto `#2B2B33` | Branco da barba precisa de contorno contra a neve |
| Rena Rudolfo | Chifres grandes (silhueta principal), nariz vermelho brilhante (Neon), cachecol | Marrom `#9B6A44`, creme `#F3E0C2`, nariz `#FF3B3B` | Marrom sobre pista de pão de mel: o cachecol e o contorno precisam separar |
| Boneco de Neve | Três esferas, cartola preta, nariz de cenoura e cachecol vermelho | Branco `#FFF8EE`, preto `#2B2B33`, vermelho `#D8374B`, laranja `#FF8A3D` | Sumiu no escuro: contorno azul-claro e luz própria à noite |
| Fada do Gelo | Asas cristalinas, varinha com estrela ciano, cabelo prateado | Azul-gelo `#8FD3F0`, lilás `#C9B8FF`, ciano `#48E6FF` | Só as asas são translúcidas, corpo opaco |

### Em aberto

- **Como construir os heróis:** modelos próprios feitos de peças (recomendado, controle total de estilo) ou personagens do Roblox com acessórios. A proposta é começar pelos modelos próprios.
- **Skins:** cada herói terá variações de cor e acessórios vendáveis; o guia define as cores-base e as variações entram depois.

## 10. Interface (UI)

A interface segue um único kit visual, o mesmo da tela de fim de corrida da primeira versão (cartão creme com cabeçalho vermelho), e precisa funcionar no celular antes de funcionar no PC.

### Kit visual

| Elemento | Especificação (proposta) |
| --- | --- |
| Cartão (painel) | Fundo creme `#FFF0D6`, borda vermelha `#C8323F` de 4 px, cantos arredondados (`UICorner` de 16 a 20 px) |
| Cabeçalho | Faixa vermelha `#A8141F` com borda dourada `#F2B53C`, texto branco com contorno escuro |
| Texto do corpo | Marrom escuro `#5A2A18`, fonte arredondada e grossa (a mesma do título) |
| Botão principal | Verde `#3DB36B` com borda `#1E7A44`, brilho leve em cima, texto branco com contorno |
| Botão secundário | Creme com borda marrom, texto marrom escuro |
| Botão de perigo ou recusar | Vermelho `#D8374B` |
| Setas de seleção | Botões vermelhos com ícone de seta (`<` e `>`) visível |
| HUD de moedas | Pílula escura com borda dourada, ícone de bengala doce e número grande |
| HUD de distância | Pílula igual à de moedas, com "m" menor ao lado do número |

### Regras

- **Regra:** nenhum botão pode aparecer sem texto ou ícone. Na primeira versão, os botões verdes e vermelhos estavam vazios. Verifique cada botão na captura de tela e no Explorer (o texto precisa estar acima do fundo no `ZIndex`, com cor diferente do fundo e `Text` preenchido).
- **Regra:** tamanhos por escala (`UDim2` com `Scale`), com `UIAspectRatioConstraint` quando necessário. Nada cortado nas bordas; respeitar a área segura (`GuiService` / `ScreenInsets`). Teste com o emulador de dispositivos do Studio em celular pequeno, celular grande e tablet.
- **Regra:** alvo de toque mínimo de cerca de 48 px de altura equivalente, com espaço entre botões.
- **Regra:** desligar o placar padrão do Roblox ou reposicioná-lo, para não cobrir o HUD (`StarterGui:SetCoreGuiEnabled` para a lista de jogadores). Se o multiplayer exigir lista de jogadores, criar uma própria no mesmo kit.
- **Regra:** durante a corrida, só o HUD essencial: moedas, distância, power-up ativo, botão da habilidade, vidas extras. Nada de painel grande.
- **Regra:** texto em português, curto, com contorno para ler sobre qualquer fundo.
- **Regra:** todo botão tem estado de toque (escala 0,95 por 80 ms e brilho) e de passar o mouse no PC.

### Telas e o que cada uma precisa

| Tela | Obrigatório |
| --- | --- |
| Hub (preparar corrida) | Herói e capítulo com setas visíveis, botão JOGAR com texto, painel dentro da tela |
| HUD da corrida | Moedas, distância, botão de habilidade com ícone e recarga em círculo |
| Fim de corrida | Distância, moedas, recorde, botão CORRER DE NOVO com texto, botão VOLTAR À VILA |
| Loja | Abas, cartões de item com ícone, preço e estado (comprado, bloqueado) |
| Calendário | Dias com recompensa, dia atual destacado |

### Ícones

Ícones simples, de contorno grosso, com as cores do kit (bengala doce, presente, estrela, raio, coração, escudo). Podem ser feitos com formas de UI e texto, ou como imagens aprovadas (neste caso, o usuário envia ou aprova o arquivo).

## 11. Efeitos e transição de página

Os efeitos dão o toque satisfatório ao jogo e a transição de página amarra os três capítulos no conceito do livro; ambos respeitam o orçamento de desempenho do celular.

### Efeitos de partícula e câmera

| Efeito | Quando | Especificação (proposta) |
| --- | --- | --- |
| Neve caindo | Sempre, em volta da câmera | `ParticleEmitter` seguindo a câmera, taxa baixa (10 a 20 por segundo), tamanho pequeno, deriva lateral leve |
| Poeira de neve | Pouso, troca de pista, deslizar | Rajada curta (6 a 10 partículas) branca azulada |
| Faísca de moeda | Coleta | 4 a 6 partículas douradas, vida de 0,3 s |
| Fumaça das chaminés | Prédios-marco | Emissor lento, branco translúcido, subindo |
| Linhas de vento | Velocidade alta | Linhas finas nas bordas da tela ou em volta do herói |
| Tremida de câmera | Pouso forte, tropeço | Amplitude pequena (0,1 a 0,3 stud), 0,15 s |
| FOV | Cresce com a velocidade | Do valor base até +10 graus no máximo |
| Brilho pulsante | Moedas, power-ups, janelas acesas | Neon com variação lenta de brilho |

### Transição de página (troca de capítulo)

Quando o jogador passa a marca de distância de troca (documento de design: sugestão de 1000 m), a pista passa por um **trecho de transição** de um chunk, e a página "vira".

1. Alguns studs antes, aparecem **cantos de página** nas bordas da tela e um leve som de papel.
2. Uma **folha grande** de cor creme cruza a tela da direita para a esquerda em cerca de 0,6 s, cobrindo parcialmente a visão. Pode ser feita com um elemento de interface (um `Frame` ou imagem) animado por `TweenService`.
3. Enquanto a folha cobre a tela, o jogo aplica o novo perfil de luz (seção 7) e começa a gerar os chunks do próximo capítulo.
4. A folha sai revelando o novo capítulo. O título do capítulo aparece por 1,5 s (por exemplo, "Capítulo 2: Fábrica de Brinquedos") no estilo do cabeçalho vermelho do kit de interface.
5. A velocidade do herói **não muda** durante a transição, e nenhum obstáculo aparece no chunk de transição.

**Regra:** a transição nunca pode derrubar a taxa de quadros nem esconder obstáculos que apareçam logo depois dela.

### Detalhes do conceito de livro (opcionais)

- Fita de marcador vermelha no canto do hub.
- Moldura em forma de páginas empilhadas na tela de carregamento.
- No hub, um livro aberto gigante serve de placa (já existe na primeira versão).

## 12. Processo e checklist global

O trabalho visual avança em passadas curtas, uma por capítulo e por aspecto, e cada passada só termina quando passa na checklist com captura de tela e a validação do usuário.

### Ciclo de uma passada

1. Ler este guia, o guia do capítulo e olhar as imagens de referência.
2. Dizer em 3 a 5 linhas o que vai fazer e como (plano curto) e esperar um "ok" se a mudança for grande.
3. Implementar apenas o aspecto combinado.
4. Rodar o jogo e capturar a tela (`screen_capture`) em 3 pontos: câmera de jogo, visão alta e close do herói. Se o MCP permitir, também com o playtest simulando um minuto de corrida.
5. Comparar com as referências e com a checklist abaixo. Se algo falhar, voltar ao passo 3.
6. Entregar com as capturas e uma lista de "o que mudou" e "o que ainda falta".
7. O usuário valida com prints do celular. Só então o aspecto é dado como pronto e o commit é feito.

### Ordem das passadas (por capítulo)

| # | Passada | Pronto quando |
| --- | --- | --- |
| 1 | Bugs de interface e leitura básica | Nenhum botão vazio, nada cortado, nada sobreposto |
| 2 | Herói | Passa nas regras da seção 9 em todos os capítulos |
| 3 | Iluminação, céu e pós-processamento | Perfil da seção 7 aplicado e calibrado por captura |
| 4 | Pista, faixas, coletáveis e obstáculos | Seção 8 inteira |
| 5 | Cenário: marcos e plano médio | Props P1 do guia do capítulo, com densidade da seção 5 |
| 6 | Cenário: detalhes e props P2 e P3 | Checklist do capítulo |
| 7 | Efeitos e transição de página | Seção 11 |
| 8 | Polimento de interface | Kit da seção 10 completo |
| 9 | Desempenho | Orçamento da seção 6 respeitado no celular de entrada |

A ordem entre capítulos é 1, depois 2, depois 3. Cada capítulo só começa a passada 5 depois de as passadas 1 a 4 estarem aprovadas.

### Checklist global de aceite

- [ ] Dá para distinguir faixas, obstáculos e moedas em uma olhada (teste de tons de cinza).
- [ ] O herói se destaca da pista e do fundo, em qualquer capítulo.
- [ ] Nenhum botão ou painel vazio, cortado ou sobreposto no emulador de celular e no PC.
- [ ] As quatro camadas de cenário existem e o chão vazio é menos de 25% da área visível.
- [ ] A paleta do capítulo está respeitada (só as cores listadas, mais as cores de gameplay).
- [ ] O contraste quente contra frio está presente (janelas e luzes acesas contra fundo frio).
- [ ] A neve é grossa nos telhados e props (nada de fios finos).
- [ ] Nenhuma peça de cenário dentro do corredor da pista.
- [ ] Peças de cenário com `Anchored`, sem colisão e sem consulta, e `CastShadow` desligado nas pequenas.
- [ ] Orçamento de peças e de luzes respeitado.
- [ ] Nada de propriedade intelectual de terceiros (nomes, personagens, placas, texturas das referências).
- [ ] O jogo roda sem quedas visíveis no celular de entrada (ou o usuário aprovou a exceção).

## 13. Erros a evitar

Estes problemas apareceram na primeira versão jogável (hub e três capítulos) e não devem se repetir; use esta lista como revisão antes de entregar.

| Onde | Problema visto | Correção exigida |
| --- | --- | --- |
| Fim de corrida, hub, habilidade | Botões verdes e vermelhos sem texto nem ícone | Seção 10: texto e ícone em todo botão, `ZIndex` e cor corretos |
| Hub | Painel cortado na borda direita | Layout por escala e área segura; testar no emulador |
| HUD | Placar padrão do Roblox cobrindo a distância | Desligar ou reposicionar a lista de jogadores |
| Capítulo 1 | Herói translúcido, parecia fantasma | Corpo opaco; só asas e efeitos translúcidos |
| Capítulo 1 | Emendas de ladrilho com o mesmo peso das divisórias de faixa | Divisórias mais fortes e ladrilho sutil |
| Capítulos 1 e 3 | Linha amarela central parecendo um laser | Moedas como objetos separados (seção 8) |
| Capítulos 1 e 2 | Campos de neve vazios e poucas peças no cenário | Quatro camadas e densidade da seção 5 |
| Capítulo 2 | Cores primárias aleatórias, pinheiros e morros verde-menta genéricos | Paleta e props do guia do capítulo 2, nada de pinheiro de floresta numa fábrica |
| Capítulo 3 | Herói e obstáculos quase invisíveis no escuro | Contorno, luz própria e brilho de obstáculos (seções 7 a 9) |
| Geral | Iluminação plana e sem clima | Perfis da seção 7 |
| Geral | Herói marrom ou branco sumindo contra a pista | Contorno e cor dominante diferente da pista |

### Armadilhas gerais

- **Detalhe demais, leitura de menos:** peças pequenas e muitas luzes parecem bonitas numa captura parada e matam o desempenho e a clareza em movimento.
- **Copiar a referência em vez de traduzir:** referências de ilustração têm detalhes impossíveis de repetir com peças; traduza o clima.
- **Mudar tudo de uma vez:** mudanças misturadas escondem o que funcionou e o que quebrou.
- **Entregar sem olhar:** toda mudança visual exige captura de tela antes da resposta.
