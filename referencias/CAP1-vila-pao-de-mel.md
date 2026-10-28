# CAP1: Vila de pão de mel

## 1. Visão do capítulo

A Vila de pão de mel é a primeira página do livro: uma vila doce ao entardecer, onde tudo parece feito de biscoito, glacê e balas e as janelas acesas brilham contra um céu azul-acinzentado com horizonte pêssego.

- **Sentimento:** acolhedor, doce e seguro, o "era uma vez" do jogo.
- **Palavras-chave:** quentinho, brilhante, miniatura, glacê, neve grossa.
- **Referências:** ref 1 (fachadas recortadas e janelas acesas) e ref 2 (miniatura, neve grossa, postes com laço). Ver `REFERENCIAS/README`.
- **Vilões:** Krampus (perseguidor) e Ranzinza Verde (chefe).
- **Mecânica própria:** trampolins de bala de goma.

### A cena na câmera de jogo

O herói corre no centro de uma pista de biscoito com divisórias de glacê branco, entre trilhos vermelhos com topo de glacê. Dos dois lados, casas de pão de mel com telhado de neve grossa e janelas laranja, postes com laço vermelho, árvores pequenas enfeitadas e bengalas gigantes. Ao fundo, morros de biscoito com capa de neve e um prédio-marco com chaminé soltando fumaça. O céu vai de azul-acinzentado no alto a pêssego no horizonte, e cai uma neve leve.

### O que manter e o que mudar da primeira versão

| Manter | Mudar |
| --- | --- |
| Casas de pão de mel com janela acesa | Pista com ladrilhos de mesmo peso que as divisórias de faixa |
| Bengalas listradas e árvores com enfeites | Trilhos vermelhos enormes e chapados |
| Morros de biscoito com capa de neve | Chão de neve vazio e plano |
| Pista de biscoito em tom alaranjado | Telhados sem capa de neve grossa |
| Cartaz de contagem "JÁ!" no estilo da interface | Céu e luz genéricos, sem clima de entardecer |
| Disposição das casas ao longo da pista | Herói translúcido e sem contorno |

## 2. Paleta e materiais

O capítulo usa oito cores principais de confeitaria, mais neve e céu; qualquer cor fora desta tabela só pode aparecer em itens de gameplay (dourado, violeta e vermelho de perigo, ver `ARTE-GERAL`, seção 8).

| Nome | Código | Uso | Material |
| --- | --- | --- | --- |
| Biscoito claro | `#E3AE72` | Superfície da pista, paredes claras | SmoothPlastic |
| Biscoito médio | `#C98746` | Paredes das casas, morros, emendas da pista | SmoothPlastic |
| Biscoito escuro | `#8E5A2B` | Telhados, portas, base dos prédios | SmoothPlastic |
| Glacê branco | `#FFF8EE` | Contornos, divisórias de faixa, capas de neve dos telhados | SmoothPlastic |
| Vermelho bala | `#D8374B` | Trilhos, laços, bengalas, detalhes de porta | SmoothPlastic |
| Verde hortelã | `#6FCF97` | Árvores, gomas, detalhes | SmoothPlastic |
| Rosa algodão-doce | `#F7B8CB` | Pirulitos, toldos, detalhes de morro | SmoothPlastic |
| Amarelo janela | `#FFC857` | Janelas e lampiões acesos | Neon |
| Neve | `#F4F8FC` | Chão de neve do cenário | Snow (só no chão distante) |
| Sombra de neve | `#C9D6EE` | Sombras e relevos da neve | Snow ou SmoothPlastic |
| Céu alto | `#6F86B8` | Topo do céu | Atmosfera |
| Céu horizonte | `#FFC9A0` | Horizonte | Atmosfera |

### Regras de cor

- Os tons de biscoito vão do mais claro (pista) ao mais escuro (telhado) para dar volume sem textura: a pista é a superfície mais clara do capítulo depois da neve.
- O verde e o rosa são acentos: nunca mais de 15% da área visível cada.
- Janelas acesas são a **única** fonte de laranja vivo; não use laranja vivo em outro lugar.
- Pista e cenário não compartilham o mesmo tom exato: a pista usa o biscoito claro e as casas o médio ou o escuro.

## 3. Pista, divisórias e trilhos

A pista é uma placa de biscoito com divisórias de glacê bem visíveis e trilhos vermelhos lisos com topo de glacê; a medida e as regras gerais estão em `ARTE-GERAL`, seção 4, e valem aqui.

| Elemento | Especificação (proposta) |
| --- | --- |
| Superfície | Biscoito claro `#E3AE72`, SmoothPlastic, 24 studs de largura (3 faixas de 8), altura 0,8 acima do chão |
| Placas | Placas de 8 por 8 studs, com emendas finas (0,15 stud) em biscoito médio `#C98746`. As emendas são **bem mais sutis** que as divisórias: contraste baixo e sem passar pelo meio da faixa de modo marcante |
| Divisórias | Glacê branco `#FFF8EE`, 0,4 stud de largura, levemente elevadas (0,1), contínuas, com bom contraste contra a pista |
| Trilho lateral | Vermelho bala `#D8374B`, 2 studs de largura, 1,2 de altura, cantos arredondados (cilindros nas pontas) e **liso**, sem listras diagonais |
| Topo do trilho | Fio de glacê branco de 0,4 stud no meio do topo, como glacê espremido |
| Borda externa | Faixa de neve e glacê de 2 studs entre o trilho e o cenário, com pequenos montes |
| Mecânica: trampolim | Semiesfera de goma verde hortelã `#6FCF97` com pontinhos de açúcar brancos, 6 studs de diâmetro, ocupando uma faixa |

### Regras

- **Regra:** se a pista tiver desenho de placas, qualquer emenda tem menos contraste que a divisória de faixa. Teste na captura em tons de cinza.
- **Regra:** o trilho é a cor mais saturada do chão, mas não pode ser mais largo que 2 studs, para não dominar a tela (na primeira versão ele era grande demais).
- **Regra:** não colocar nada sobre as divisórias a não ser moedas e obstáculos.
- **Detalhe opcional:** pequenas "migalhas" de biscoito e gotas de glacê na borda externa, só de longe visíveis.

## 4. Catálogo de cenário

O cenário se faz em ordem de prioridade: primeiro os objetos P1 (obrigatórios para o capítulo parecer completo), depois P2 e P3; medidas em studs, no formato largura por profundidade por altura.

| Pri. | Objeto | Descrição | Medidas | Peças | Zona |
| --- | --- | --- | --- | --- | --- |
| P1 | Casa pequena de pão de mel | Paredes biscoito médio, telhado em cunha biscoito escuro com capa de neve grossa e ondulada, contorno de glacê nas quinas e janelas, 2 janelas Neon, porta escura, base de neve | 14 x 12 x 14 | até 45 | Meio |
| P1 | Casa grande de dois andares | Igual à pequena com segundo andar, chaminé e varanda de glacê | 20 x 16 x 24 | até 70 | Meio |
| P1 | Fachadas recortadas (ref 1) | Fileira de 3 a 5 fachadas finas coladas, frontão pontudo, janela em arco com grade de glacê, luz interna Neon laranja; parecem recortadas | 12 x 1,5 x 18 cada | até 25 cada | Meio e fundo |
| P1 | Poste com laço (ref 2) | Poste escuro, lanterna Neon amarela, laço vermelho e pequena guirlanda; a cada 20 studs, alternando lados | 1 x 1 x 9 | até 6 | Corredor próximo |
| P1 | Árvore pequena enfeitada | 3 cones verde hortelã com capa de neve, bolas vermelhas e douradas, estrela no topo | 5 x 5 x 9 | até 8 | Corredor próximo e meio |
| P1 | Bengala gigante | Listras vermelho e branco, gancho no topo, base de neve | 2 x 2 x 12 | até 8 | Corredor próximo |
| P1 | Morro de biscoito | Domo grande biscoito médio com capa de neve e granulado de glacê | 60 a 120 x 40 x 25 a 50 | até 4 | Fundo |
| P1 | Prédio-marco: casa-torre de pão de mel | Casa grande com torre, relógio ou estrela, chaminé com fumaça, guirlandas e presentes no telhado; visível a cada 300 a 400 studs | 40 x 30 x 50 | até 150 | Fundo e meio |
| P2 | Pirulito gigante | Haste branca e disco rosa e branco em espiral | 2 x 2 x 8 | até 6 | Corredor próximo |
| P2 | Cerca de biscoito | Estacas de biscoito com topo de glacê | 8 x 0,6 x 2 | até 10 por trecho | Calçada |
| P2 | Caixa de presente pequena | Caixa com fita e laço, cores da paleta | 2 x 2 x 2 | até 4 | Calçada |
| P2 | Ponte de biscoito arqueada (ref 2) | Ponte com mureta de glacê sobre uma vala de calda, como cenário ao lado da pista | 24 x 6 x 6 | até 30 | Meio (momento especial) |
| P2 | Montes de neve e pegadas | Montes baixos com sombra azulada `#C9D6EE`, preenchendo o chão | variável | até 3 por monte | Todas |
| P3 | Moinho de biscoito | Pás giratórias lentas | 14 x 10 x 26 | até 40 | Fundo |
| P3 | Boneco de biscoito gigante | Boneco de gengibre acenando ao fundo | 12 x 4 x 30 | até 30 | Fundo |
| P3 | Cordão de luzes entre postes | Fio com bolinhas coloridas Neon, rente aos postes, a 7 a 8 studs de altura (**não atravessa a pista**) | 20 de vão | até 12 | Corredor próximo |
| P3 | Trenó parado com presentes | Trenó vermelho com pilha de presentes | 8 x 4 x 5 | até 20 | Meio |

### Regras de construção

- **Capa de neve:** em todo telhado, poste e árvore. Um bloco branco levemente maior que o telhado, com 2 a 3 esferas brancas nas pontas para parecer ondulado. Espessura entre 0,6 e 1 stud.
- **Base de miniatura:** casas e marcos ficam sobre um disco ou bloco achatado de neve (0,5 stud de altura), como as peças da ref 2.
- **Janelas:** peça Neon `#FFC857` com moldura de glacê e arco no topo. Sem luz real por janela.
- **Mínimo por casa:** nenhuma casa é só uma caixa; todas têm pelo menos telhado com neve, janelas com moldura, porta e base.

## 5. Composição, conjuntos de chunk e ritmo

O capítulo é montado com cinco conjuntos de cenário sorteados chunk a chunk, seguindo as camadas e densidades de `ARTE-GERAL`, seção 5, para a rua parecer viva e nunca repetir igual.

| Conjunto | Lado esquerdo | Lado direito | Fundo | Peso no sorteio |
| --- | --- | --- | --- | --- |
| A. Rua das casas | Casa pequena, poste, árvore pequena | Fileira de fachadas recortadas, bengala gigante | Morros baixos | Alto |
| B. Praça de doces | Pirulitos gigantes, caixas de presente, árvore pequena | Casa grande, poste, cerca de biscoito | Morros e fachadas | Médio |
| C. Alameda de postes | Poste, bengala, árvore, cordão de luzes | Poste, bengala, árvore, cordão de luzes | Morros e prédio distante | Médio |
| D. Morros | Poucas casas pequenas, montes de neve | Morro próximo, bengalas | Morros grandes | Baixo |
| E. Marco | Prédio-marco (casa-torre) com fumaça e presentes no telhado | Árvores e postes | Céu aberto e morros | Fixo: a cada 300 a 400 studs |

### Momentos especiais (a cada 8 a 10 chunks)

- **Ponte:** ponte de biscoito arqueada e vala de calda ao lado da pista.
- **Árvore gigante:** árvore de 30 a 40 studs com enfeites, no meio do plano médio.
- **Trenó e presentes:** pilha de presentes e trenó parado.

### Regras de ordem

- O mesmo conjunto não aparece duas vezes seguidas.
- Alternar o lado do objeto maior de cada conjunto.
- Nunca dois objetos grandes iguais em sequência no mesmo lado.
- O conjunto E entra pelo contador de distância, não por sorteio.
- O último chunk antes da troca de página (ver `ARTE-GERAL`, seção 11) usa um conjunto aberto e sem props altos perto da pista.

### Chão e primeiro plano

- Chão de neve com relevo: montes baixos e pegadas, em tons de neve e sombra de neve, nunca plano.
- Primeiro plano: postes a cada 20 studs alternando lados, cercas baixas e caixas de presente na calçada.
- Pelo menos 75% da área visível do chão tem algum objeto, relevo ou sombra.

## 6. Luz, céu e efeitos

O capítulo é um entardecer dourado: sol baixo e quente, céu frio no alto e janelas acesas, para que o contraste entre quente e frio seja a assinatura do primeiro capítulo (ref 1).

### Perfil de luz

Use os valores da coluna "Cap. 1" da tabela em `ARTE-GERAL`, seção 7, como ponto de partida (`ClockTime` entre 17,5 e 18, `Brightness` 2, ambiente violeta suave, atmosfera pêssego). Calibre por captura de tela até que:

- o horizonte fique pêssego e o alto do céu, azul-acinzentado;
- as sombras longas e suaves caiam para o lado oposto ao sol, com tom azulado;
- as janelas Neon brilhem (Bloom) sem estourar a imagem;
- a pista continue sendo a superfície mais clara e legível.

### Efeitos específicos

| Efeito | Especificação (proposta) |
| --- | --- |
| Neve caindo | Flocos pequenos e lentos, 10 a 20 por segundo, seguindo a câmera |
| Fumaça das chaminés | Branca translúcida subindo devagar, só nos prédios-marco e casas grandes |
| Poças de luz | Disco Neon amarelo muito translúcido (transparência cerca de 0,85) no chão sob as janelas, sem colisão |
| Brilho de glacê | Pequenas faíscas brancas raras sobre telhados e pista (até 3 emissores ativos) |
| Nuvens | `Clouds` baixas e finas, cor `#FFD3B8` (proposta: `Cover` 0,35 e `Density` 0,4) |
| Linhas de vento | Só em velocidade alta, brancas e finas |

### Contorno do herói

Contorno azul-gelo (`#BFE6FF`) nesse capítulo, para separar o herói do biscoito alaranjado. Se o contorno padrão `#FFF1C2` ficar fraco contra a pista, use este.

## 7. Obstáculos, coletáveis e vilões

Os itens de gameplay seguem o código de cor e forma de `ARTE-GERAL`, seção 8, com a roupagem de confeitaria deste capítulo; a silhueta de cada tipo é a mesma nos três capítulos.

### Coletáveis

| Item | Aparência | Medidas e movimento |
| --- | --- | --- |
| Moeda de Natal | Bala embrulhada dourada `#FFC93C` com pontas brancas, Neon leve | 2 a 2,5 studs, gira devagar e flutua 0,5 stud |
| Bônus (vale 5 moedas) | Presente pequeno dourado com laço branco | 3 studs, aparece raramente |
| Power-ups | Esfera violeta `#B56BFF` dentro de um anel de glacê | 3 studs, pulsa |

### Obstáculos

| Tipo | Versão da Vila | Aparência | Medidas (proposta) |
| --- | --- | --- | --- |
| Baixo (pular) | Caixa de presente grande | Embrulho vermelho forte com fita azul-marinho em listras diagonais | 6 x 2 x 2 |
| Alto (deslizar) | Barra de biscoito suspensa | Barra entre dois postes, com placas de listras de perigo, a 3 studs do chão | 8 x 1,5 x 1,5 |
| Bloco inteiro (trocar de pista) | Casinha de biscoito | Bloco com base de listras de perigo e telhado de neve | 8 x 4 x 6 |
| Móvel (cronometrar) | Trenó cruzando | Trenó vermelho com listras escuras; sombra e listras no chão 20 studs antes | 8 x 4 x 4 |
| Piso especial | Trampolim de goma | Semiesfera verde hortelã; é uma ajuda, não um perigo | 6 de diâmetro |

**Regra:** os obstáculos têm contraste de brilho claro contra a pista de biscoito claro. Se necessário, escureça a parte de baixo e deixe o topo mais claro.

### Vilões do capítulo

#### Krampus (perseguidor)

- **Silhueta:** figura alta e escura, chifres curvos grandes, corpo peludo marrom-escuro `#4A2F27`, língua vermelha, correntes e um sino. Altura de cerca de 8 studs.
- **Tom:** engraçado e bravo, para crianças: dentes arredondados, olhos Neon vermelhos, nada de sangue nem sustos.
- **Comportamento visual:** surge atrás do herói e fora da câmera ao primeiro tropeço; chega perto com tremida leve de câmera e sombra grande; recua se o jogador correr limpo.
- **Origem:** figura do folclore, sem personagem de terceiros.

#### Ranzinza Verde (chefe)

- **Papel:** chefe do capítulo, evento de 20 a 30 s no fim da Vila, jogando bolas de glacê e neve em ondas com aviso no chão (círculo vermelho translúcido 1 s antes).
- **Design: em aberto e a aprovar com o usuário antes de modelar.** Direção proposta: criatura baixa e larga, pele lisa verde-azeitona `#7A8F3A` (sem pelo), orelhas de morcego, bigode grosso, chapéu amassado em forma de panela e saco de presentes roubados nas costas.
- **Regra:** o design precisa ser **claramente diferente do Grinch**: sem pelo verde, sem gorro de Papai Noel, sem coração, sem o sorriso torto característico, proporções e traje diferentes.

## 8. Hub: a vila inicial

O hub é uma pequena praça da Vila de pão de mel onde o jogador escolhe herói e capítulo, entra na corrida solo ou no círculo dourado do multiplayer, e vê a vitrine do jogo; ele usa o mesmo estilo do capítulo 1, em um crepúsculo um pouco mais tardio.

### Visual

- **Luz:** perfil do capítulo 1, com `ClockTime` um pouco maior (cerca de 18,3) para o céu ficar azul-arroxeado, com lua suave e janelas e lampiões bem acesos. A primeira versão estava escura e arroxeada demais: o chão e a pista de entrada precisam continuar legíveis.
- **Chão:** praça circular de cerca de 80 studs de diâmetro, em biscoito claro com bordas de glacê, e neve em volta com relevo e pegadas.
- **Moldura:** um anel de casas de pão de mel, cordões de luz entre postes, árvores, pirulitos e uma árvore de Natal grande, tudo do catálogo do capítulo 1.
- **Livro de Natal gigante:** cartaz em forma de livro aberto, capa vermelha, texto legível de longe (título "O Livro de Natal"), servindo de portal de capítulos.

### Zonas

| Zona | Função | Visual | Interação |
| --- | --- | --- | --- |
| Pedestal do herói | Mostrar o herói escolhido | Plataforma redonda de glacê, herói girando devagar, contorno ativo | Mudar o herói atualiza o modelo na hora |
| Livro de Natal | Escolher capítulo | Livro gigante aberto, páginas com miniaturas dos capítulos | Setas na interface trocam as páginas |
| Círculo dourado | Entrar na corrida multiplayer | Anel dourado Neon no chão, contador "0/N" sobre ele | Pisar no círculo entra na fila; sair cancela |
| Portal JOGAR | Corrida solo | Arco de bengalas com a pista de entrada ao fundo | Botão JOGAR da interface ou aproximar-se |
| Loja | Comprar heróis, ambientes e habilidades | Quiosque de biscoito com toldo listrado | Abre a tela de loja |
| Calendário | Recompensa do dia | Árvore ou poste com presentes numerados | Abre a tela do calendário |

### Interface do hub

- Painel no lado direito, **inteiro dentro da tela** (a primeira versão estava cortada), no kit visual de `ARTE-GERAL`, seção 10.
- Seletores de herói e capítulo com **setas visíveis** e nome legível; botão JOGAR verde com texto.
- Texto de dica no topo ("Pise no círculo dourado para correr com amigos") com contorno e fundo escuro translúcido.
- O painel não cobre o pedestal nem o livro: ao abrir a loja, a câmera pode se afastar.

### Regras

- **Regra:** o avatar do jogador nasce em pé, no centro, virado para o livro.
- **Regra:** letreiros do mundo usam `SurfaceGui` com fonte grande, cor clara e contorno.
- **Regra:** o hub respeita o mesmo orçamento de peças e luzes do restante (até 6 luzes reais, nos lampiões mais próximos).

## 9. Checklist de aceite do capítulo 1

O capítulo 1 só é dado como pronto quando todos os itens abaixo passam em capturas de tela da câmera de jogo, da visão alta e do close do herói, além da checklist global de `ARTE-GERAL`, seção 12.

### Clima

- [ ] A cena lembra a ref 1: janelas acesas laranja contra céu azul-acinzentado com horizonte pêssego.
- [ ] A neve dos telhados é grossa e ondulada, como na ref 2.
- [ ] Casas e marcos têm base de neve (efeito miniatura).
- [ ] Dá vontade de "comer" o cenário: biscoito, glacê e balas, sem textura realista.

### Pista e leitura

- [ ] As divisórias de faixa são claramente mais fortes que as emendas das placas.
- [ ] Os trilhos são lisos, no máximo 2 studs de largura, e não dominam a tela.
- [ ] Moedas são balas douradas separadas, sem linha contínua tipo laser.
- [ ] Obstáculos se destacam da pista e se distinguem pelo tipo.
- [ ] O herói se separa da pista (contorno azul-gelo) e é opaco.

### Cenário

- [ ] As quatro camadas existem; o chão vazio é menos de 25% da área visível.
- [ ] Todos os objetos P1 do catálogo estão no jogo e há pelo menos 2 itens P2.
- [ ] O prédio-marco aparece a cada 300 a 400 studs.
- [ ] Nenhum objeto sólido dentro do corredor da pista.
- [ ] Nenhuma cor de perigo (vermelho com listras diagonais) em decoração perto da pista.

### Hub e interface

- [ ] Nenhum botão vazio; painel do hub inteiro dentro da tela.
- [ ] O placar padrão do Roblox não cobre o HUD.
- [ ] Círculo dourado, livro e pedestal do herói funcionam e são legíveis.

### Desempenho

- [ ] Orçamento de peças e de luzes respeitado.
- [ ] Sem quedas visíveis de FPS no celular de entrada.

### Pergunta ao usuário antes de encerrar o capítulo

- Aprova o design do Ranzinza Verde e do Krampus?
- Quer mais doce (mais cor) ou mais aconchego (mais luz quente)?
