# CAP2: Fábrica de brinquedos

## 1. Visão do capítulo

A Fábrica de brinquedos é a segunda página do livro: um salão de dia claro, sem teto, com paredes de janelas grandes, esteiras e braços robóticos embalando presentes, tudo em formas planas e camadas de papel recortado.

- **Sentimento:** animado, cheio de ritmo, máquinas simpáticas, um "canteiro de obras" de brinquedo. Mais claro e mais colorido que os outros capítulos.
- **Palavras-chave:** papel recortado, camadas, cores chapadas, esteira, presentes, luz de janela.
- **Referências:** ref 4 (paleta, esteira, braços, lâmpadas, janelas) e ref 3 (prédio-marco com chaminés, presentes no telhado, bengalas gigantes, trenzinho). Ver `REFERENCIAS/README`.
- **Vilão:** Duende Rebelde (perseguidor). Este capítulo não tem chefe.
- **Mecânicas próprias:** esteiras que aceleram ou invertem e engrenagens giratórias.

### A cena na câmera de jogo

O herói corre sobre uma esteira azul-água com divisórias creme, entre guardas verdes. Dos dois lados, a 36 studs da pista, paredes verde-limão com grandes janelas de moldura creme que deixam entrar luz. Entre a pista e as paredes: braços robóticos vermelhos e verdes, esteiras laterais com presentes, pilhas de caixas e uma árvore enfeitada. No alto, vigas verdes em treliça e lâmpadas vermelhas penduradas ao lado da pista. O céu azul claro aparece acima das paredes, com a Oficina do Papai Noel e suas chaminés ao fundo.

### Estilo: papel recortado

Este capítulo é onde o estilo "papel recortado" aparece com mais força: formas planas, cores chapadas, camadas finas empilhadas com pequenas sombras entre elas. A seção 4 explica como montar isso com peças do Roblox.

### O que manter e o que mudar da primeira versão

| Manter | Mudar |
| --- | --- |
| Esteira azul com divisórias claras (legível) | Pinheiros de floresta e morros verde-menta, que não combinam com uma fábrica |
| Engrenagens azuis giratórias | Cores primárias soltas, sem paleta, e caixas isoladas |
| Caixas de presente coloridas | Falta de paredes, janelas, vigas e máquinas: não parece um salão |
| Boa legibilidade das faixas | Céu e nuvens genéricos |
| Trilhos amarelos como guias | Cenário esparso e herói em bloco marrom sem contorno |

## 2. Paleta e materiais

O capítulo usa cores vivas e chapadas (dez no total, contando os neutros de piso e metal), tiradas da ref 4, com uma mudança importante: o piso não é vermelho vivo, porque o vermelho vivo é a cor de perigo do jogo e não pode ocupar a área ao lado da pista.

| Nome | Código | Uso | Material |
| --- | --- | --- | --- |
| Verde-limão | `#C6DC4A` | Paredes laterais | SmoothPlastic |
| Verde pinheiro | `#1F7A4D` | Vigas, guardas da pista, braços, detalhes | SmoothPlastic |
| Vermelho brinquedo | `#D93A46` | Lâmpadas, braços robóticos, laços, detalhes (sempre a mais de 14 studs da pista e sem listras diagonais) | SmoothPlastic |
| Azul-água | `#8FD3E6` | Vidros das janelas | SmoothPlastic (sem transparência) |
| Azul esteira | `#2F7FA8` | Superfície da pista, esteiras laterais | SmoothPlastic |
| Mostarda | `#F2AA3C` | Base de máquinas, centros de engrenagem, detalhes | SmoothPlastic |
| Creme | `#FFF6DD` | Molduras de janela, divisórias, pinos da esteira | SmoothPlastic |
| Piso claro | `#EBC074` | Piso do salão (madeira clara) | SmoothPlastic |
| Cinza metal | `#8CA0B3` | Engrenagens, estruturas, tubos | Metal ou SmoothPlastic |
| Dourado | `#F6C945` | Estrelas e acabamentos (não é a moeda) | SmoothPlastic ou Neon leve |
| Céu | `#9ED8F0` | Visto acima das paredes | Atmosfera |

### Regras de cor

- **Regra:** a pista (azul esteira) é a única grande área azul saturada do capítulo; as janelas usam o azul-água, mais claro e menos saturado.
- **Regra:** o vermelho vivo fica a mais de 14 studs da pista (lâmpadas, braços, árvore) para não competir com os obstáculos. Os trilhos da pista são verdes, não vermelhos.
- **Regra:** a moeda dourada `#FFC93C` não pode se confundir com o dourado decorativo: acabamentos dourados ficam acima de 6 studs de altura ou longe da pista.
- **Regra:** cores chapadas, sem gradiente. Variação de tom só entre camadas (uma camada de fundo um pouco mais escura que a da frente).
- Diferença para a ref 4: o piso vermelho vira madeira clara; o resto da paleta é mantido.

## 3. Pista: esteira, divisórias e trilhos

A pista é uma esteira azul com ripas sutis, divisórias creme bem visíveis e guardas verdes, e é nela que ficam as mecânicas próprias do capítulo; medidas gerais em `ARTE-GERAL`, seção 4.

| Elemento | Especificação (proposta) |
| --- | --- |
| Superfície | Azul esteira `#2F7FA8`, SmoothPlastic, 24 studs de largura (3 faixas de 8), altura 0,8 |
| Ripas | Faixas transversais de 0,3 stud a cada 4 studs, em azul 10% mais escuro. Contraste **baixo**, bem menor que as divisórias |
| Divisórias | Creme `#FFF6DD`, 0,4 stud, contínuas. Contraste alto contra o azul (era o ponto forte da primeira versão: manter) |
| Pinos | Cilindros pequenos creme (0,5 de diâmetro) nas bordas da esteira, de 3 em 3 studs, como na ref 4 |
| Guarda lateral | Verde pinheiro `#1F7A4D`, 2 studs de largura e 1,2 de altura, com fio creme no topo. **Liso**, sem listras |
| Borda externa | Faixa de piso claro de 2 studs, com pequenos detalhes de parafuso |

### Mecânicas da esteira

| Trecho | Efeito no jogo | Visual |
| --- | --- | --- |
| Esteira rápida | Aumenta a velocidade por alguns segundos | Setas creme apontando para a frente sobre uma faixa verde-limão, ripas passando mais rápido |
| Esteira reversa | Reduz ou inverte o avanço | Setas mostarda apontando para trás, ripas passando em sentido contrário |
| Aviso | 20 studs antes de cada trecho | Faixa de setas piscando e sinal sonoro curto |

- **Efeito de movimento:** ripas transversais que deslizam por script, apenas visuais, com no máximo 40 peças animadas na tela. Se o desempenho cair, usar listras estáticas.
- **Regra:** os trechos de esteira rápida e reversa respeitam as medidas de faixa e nunca ocupam as 3 faixas com reversa ao mesmo tempo.
- **Regra:** nada da paleta de perigo (vermelho com listras escuras) aparece nos trechos de esteira.

## 4. Catálogo de cenário

O salão é montado com paredes de janelas a 36 studs da pista, máquinas e presentes entre elas e a pista, e vigas no alto; medidas em studs (largura por profundidade por altura), em ordem de prioridade.

| Pri. | Objeto | Descrição | Medidas | Peças | Zona |
| --- | --- | --- | --- | --- | --- |
| P1 | Parede de janelas | Parede verde-limão em camadas, com 4 janelas grandes por chunk, moldura creme de 0,8 stud, grade 2 por 3 em creme e vidro azul-água plano | 60 x 1 x 30 por chunk | até 40 | Meio (a 36 studs) |
| P1 | Viga em treliça | Viga verde pinheiro com diagonais, cruzando o salão a 34 studs de altura, a cada 120 studs | 90 x 2 x 3 | até 30 | Alto |
| P1 | Lâmpada pendurada | Campânula vermelha com fio fino e miolo Neon quente, nas vigas ao lado da pista, entre 16 e 22 studs de altura | 4 x 4 x 5 | até 5 | Corredor próximo e meio, nunca sobre a pista |
| P1 | Braço robótico | Base vermelha, segmentos verde pinheiro e vermelho, 3 articulações, garra segurando um presente. Balança devagar por script | 8 x 8 x 22 | até 40 | Meio |
| P1 | Esteira lateral com presentes | Esteira azul esteira com pinos creme, a cerca de 10 studs da pista, com até 6 presentes deslizando | 40 x 4 x 3 | até 50 | Corredor próximo |
| P1 | Pilha de presentes | Caixas coloridas com laço azul e dourado, empilhadas | 4 x 4 x 4 a 8 x 6 x 8 | até 12 | Calçada e corredor próximo |
| P1 | Engrenagem giratória | Cinza metal com centro mostarda, gira devagar na parede ou no chão | 12 a 18 de diâmetro | até 8 | Meio e fundo |
| P1 | Árvore de Natal enfeitada (ref 4) | 4 níveis, bolas coloridas, estrela dourada no topo | 10 x 10 x 16 | até 12 | Meio |
| P1 | Prédio-marco: Oficina do Papai Noel (ref 3) | Fachada simétrica com relógio central, 3 chaminés com fumaça, presentes coloridos no telhado, bengalas gigantes na entrada, guirlandas de luz Neon; visível acima da parede do fundo a cada 300 a 400 studs. Texto próprio no letreiro, nada copiado | 60 x 20 x 50 | até 150 | Fundo |
| P2 | Painel de controle com estrela (ref 4) | Caixa com tela, estrela dourada e luz vermelha em cima | 8 x 4 x 9 | até 15 | Meio |
| P2 | Estrela dourada pendurada | Estrelas de papel penduradas nas vigas | 3 x 0,6 x 3 | até 3 | Alto |
| P2 | Tubos e vapor | Tubos cinza metal na parede, com vapor branco em intervalos | 20 x 2 x 12 | até 10 | Meio |
| P2 | Fita de papel e laços | Fitas coloridas e laços penduradas nas paredes | 6 x 0,5 x 8 | até 6 | Meio |
| P3 | Saco de presentes gigante (ref 4) | Saco marrom com cordão dourado | 8 x 6 x 8 | até 10 | Meio |
| P3 | Relógio de parede | Relógio redondo com ponteiros que giram | 6 de diâmetro | até 6 | Meio |
| P3 | Trilhos de trenzinho | Trilho paralelo à pista para o trenzinho de brinquedo (ver seção 7) | 60 x 3 x 0,5 | até 12 | Corredor próximo |

### Como montar o papel recortado

- **Camadas finas:** cada objeto grande é feito de 2 a 3 camadas de 0,4 a 0,8 stud de espessura, com afastamento de 0,4 a 0,6 stud entre elas (parede, depois moldura, depois detalhe).
- **Sombra de papel:** peça escura (`#000000` não, use `#1B3B2B`) com transparência cerca de 0,8, igual ao recorte, deslocada 0,3 stud para baixo e para o lado, **atrás** de paredes, marcos e máquinas grandes. Em peças pequenas, não.
- **Cores chapadas, bordas retas:** sem arredondar demais; recortes têm cantos vivos ou levemente arredondados.
- **Sem textura:** nada de aparência metálica realista; metal é cor cinza chapada com um destaque claro numa borda.
- **Janelas:** vidro é cor plana azul-água, sem transparência, com um reflexo diagonal creme (2 tiras finas).

### Regras

- **Regra:** nada de pinheiro de floresta nem morro verde-menta neste capítulo. As árvores são árvores de Natal enfeitadas de salão.
- **Regra:** o vermelho vivo das máquinas e lâmpadas fica a mais de 14 studs da pista.
- **Regra:** a linha de visão do herói não pode ser bloqueada por vigas: vigas só a 34 studs de altura.

## 5. Composição, conjuntos de chunk e ritmo

O capítulo usa cinco conjuntos de cenário sorteados chunk a chunk, sempre com paredes de janelas dos dois lados; as camadas e densidades gerais estão em `ARTE-GERAL`, seção 5.

| Conjunto | Lado esquerdo | Lado direito | Alto e fundo | Peso no sorteio |
| --- | --- | --- | --- | --- |
| A. Linha de montagem | Braço robótico, pilha de presentes | Esteira lateral com presentes, engrenagem | Viga e 2 lâmpadas | Alto |
| B. Praça das caixas | Pilhas de presentes grandes, árvore enfeitada | Painel de controle, pilhas pequenas | Estrelas penduradas | Médio |
| C. Oficina de máquinas | Engrenagens grandes, tubos e vapor | Braço robótico, tubos | Viga com lâmpadas | Médio |
| D. Corredor de janelas | Poucas props, feixes de luz | Poucas props, fitas de papel | Céu e fundo abertos | Baixo |
| E. Marco | Parede com arco e vista da Oficina | Árvore enfeitada e pilhas | Oficina do Papai Noel ao fundo | Fixo: a cada 300 a 400 studs |

### Momentos especiais (a cada 8 a 10 chunks)

- **Trenzinho de brinquedo** passando em trilho ao lado da pista (ver seção 7).
- **Chuva de presentes:** presentes caindo de uma calha na parede, só visual, sem tocar a pista.
- **Árvore gigante:** árvore de 30 a 40 studs com enfeites entre os braços robóticos.

### Regras de ordem

- O mesmo conjunto não aparece duas vezes seguidas, e o lado do objeto maior alterna.
- Um braço robótico e uma engrenagem nunca ficam no mesmo lado em dois chunks seguidos.
- Paredes de janelas são contínuas: o conjunto muda o que fica entre a parede e a pista, não a parede em si (exceto o conjunto E, que abre um arco).
- O último chunk antes da troca de página usa o conjunto D, sem props altos perto da pista.

### Fundo

- No horizonte, o corredor do salão se perde na atmosfera clara (`Atmosphere` do perfil do capítulo 2), com a silhueta da Oficina do Papai Noel e das chaminés.
- O piso entre a pista e a parede fica 90% ocupado por esteiras laterais, pilhas e máquinas, nunca vazio.

## 6. Luz, céu e efeitos

O capítulo é um dia claro e limpo dentro de um salão aberto: luz alta e neutra, cores vivas e feixes de luz entrando pelas janelas, em contraste com o entardecer do capítulo 1 e a noite do capítulo 3.

### Perfil de luz

Use a coluna "Cap. 2" da tabela em `ARTE-GERAL`, seção 7, como ponto de partida (`ClockTime` 13, `Brightness` 3, atmosfera limpa e clara). Calibre até que:

- as cores da paleta apareçam vivas, sem ficarem lavadas pelo brilho;
- as sombras sejam curtas e suaves, e a sombra de papel entre camadas (seção 4) seja visível sem pesar;
- o céu azul claro acima das paredes dê sensação de salão aberto;
- a pista (azul esteira) continue sendo a área mais saturada do chão.

### Efeitos específicos

| Efeito | Especificação (proposta) |
| --- | --- |
| Feixes de luz | 2 a 3 planos inclinados por chunk, amarelo claro Neon com transparência cerca de 0,92, saindo das janelas até o chão. Sem colisão |
| Poeira e glitter | Partículas douradas minúsculas flutuando devagar no ar (taxa baixa) |
| Vapor | Sopros brancos nos tubos, em intervalos de 4 a 6 s |
| Faíscas de engrenagem | Raras, amarelas, só em engrenagens grandes |
| Fumaça das chaminés | Brancas translúcidas nas chaminés da Oficina |
| Neve | Muito leve (cerca de 5 a 8 por segundo), só para manter o clima de Natal; o salão é aberto |
| Movimento mecânico | Braços robóticos balançam, engrenagens giram, presentes deslizam, tudo lento e previsível |
| Linhas de vento | Só em velocidade alta, finas e claras |

### Contorno do herói

O contorno padrão `#FFF1C2` funciona sobre o azul esteira. Se o herói for creme ou claro, use contorno escuro `#1B3B2B`.

### Regras

- **Regra:** movimento mecânico é só decoração de fundo e nunca invade as faixas.
- **Regra:** os feixes de luz não podem cobrir a pista a ponto de reduzir o contraste das moedas e obstáculos.

## 7. Obstáculos, coletáveis e vilão

Os itens de gameplay seguem o código de cor e forma de `ARTE-GERAL`, seção 8, com a roupagem de fábrica; moedas e power-ups são os mesmos do capítulo 1, para o jogador reconhecê-los em qualquer lugar.

### Coletáveis

| Item | Aparência | Medidas e movimento |
| --- | --- | --- |
| Moeda de Natal | Bala embrulhada dourada `#FFC93C` com pontas brancas, Neon leve (igual ao capítulo 1) | 2 a 2,5 studs, gira e flutua |
| Bônus (vale 5 moedas) | Presente pequeno dourado com laço branco | 3 studs |
| Power-ups | Esfera violeta `#B56BFF` dentro de um anel | 3 studs, pulsa |

O violeta contrasta bem com a esteira azul; mantenha o anel branco fino para reforçar a leitura.

### Obstáculos

| Tipo | Versão da Fábrica | Aparência | Medidas (proposta) |
| --- | --- | --- | --- |
| Baixo (pular) | Caixa de brinquedo | Caixa vermelha forte com fita azul-marinho em listras diagonais | 6 x 2 x 2 |
| Alto (deslizar) | Braço mecânico baixo | Barra horizontal com placas de listras de perigo, a 3 studs do chão | 8 x 1,5 x 1,5 |
| Bloco inteiro (trocar de pista) | Pilha de caixas grande | Caixas empilhadas com base de listras de perigo | 8 x 4 x 6 |
| Móvel (cronometrar) | Trenzinho de brinquedo (ref 3) | Locomotiva e vagões coloridos cruzando a pista; sombra e listras de aviso no chão 20 studs antes | 14 x 4 x 4 |
| Móvel (cronometrar) | Engrenagem giratória | Engrenagem grande rolando na pista, com listras de perigo no dente | 6 de diâmetro |
| Piso especial | Esteira rápida e esteira reversa | Ver seção 3 | por faixa |

**Regra:** a caixa vermelha do obstáculo baixo é a única grande peça vermelha perto da pista. O vermelho do cenário (lâmpadas, braços) fica a mais de 14 studs.

### Vilão: Duende Rebelde (perseguidor)

- **Silhueta:** duende baixo e ágil, chapéu pontudo amassado, orelhas grandes, macacão com bolsos e uma chave inglesa.
- **Cores:** chapéu roxo `#6B4FA3`, macacão mostarda escuro `#B8862B`, camisa laranja `#E8772E`. **Diferente do Duende Corredor** (verde e vermelho) e dos duendes desenhados da ref 4.
- **Tom:** travesso e engraçado, com sorriso torto e olhos pequenos.
- **Comportamento visual:** persegue por trás do herói; enquanto persegue, joga caixas e peças pequenas na pista com aviso de sombra 1 s antes (cada peça é um obstáculo baixo); recua se o jogador correr limpo.
- **Sem chefe neste capítulo.** Uma variante: um evento curto de "linha de montagem descontrolada" a cada 1000 m, com mais esteiras rápidas e mais caixas.

## 8. Checklist de aceite do capítulo 2

O capítulo 2 só é dado como pronto quando todos os itens abaixo passam em capturas de tela da câmera de jogo, da visão alta e do close do herói, além da checklist global de `ARTE-GERAL`, seção 12.

### Clima e estilo

- [ ] Parece um salão de fábrica de brinquedos de dia claro, como na ref 4, e não uma floresta.
- [ ] O estilo é de papel recortado: cores chapadas, camadas finas e sombra de papel visíveis nas paredes e marcos.
- [ ] A paleta do capítulo está respeitada; nenhum pinheiro de floresta nem morro verde-menta.
- [ ] O prédio-marco (Oficina do Papai Noel) aparece ao fundo a cada 300 a 400 studs, com texto próprio no letreiro.

### Pista e leitura

- [ ] Divisórias creme claramente mais fortes que as ripas da esteira.
- [ ] Guardas verdes lisos, no máximo 2 studs de largura.
- [ ] Esteira rápida e esteira reversa distinguíveis e sempre avisadas 20 studs antes.
- [ ] Moedas, bônus e power-ups legíveis sobre o azul esteira.
- [ ] O herói se separa da esteira (contorno) e é opaco.

### Cenário

- [ ] Paredes de janelas a 36 studs, contínuas, com grade e reflexo.
- [ ] Todos os objetos P1 do catálogo estão no jogo e há pelo menos 3 itens P2.
- [ ] O piso lateral está 90% ocupado por máquinas, esteiras e pilhas.
- [ ] Nenhuma peça sólida dentro do corredor da pista; vigas só a 34 studs de altura.
- [ ] Vermelho vivo só a mais de 14 studs da pista (exceto o obstáculo baixo).
- [ ] Movimento mecânico (braços, engrenagens, esteiras) lento e sem invadir as faixas.

### Desempenho

- [ ] Orçamento de peças e de luzes respeitado, com até 40 peças animadas de esteira.
- [ ] Sem quedas visíveis de FPS no celular de entrada.

### Pergunta ao usuário antes de encerrar o capítulo

- Aprova o visual do Duende Rebelde?
- O estilo de papel recortado está claro o bastante ou prefere mais volume nas peças?
