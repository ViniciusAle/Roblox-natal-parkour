# CAP3: Polo Norte à noite

## 1. Visão do capítulo

O Polo Norte à noite é a terceira página e o clímax do livro: uma vila de Natal sob um céu azul-roxo cheio de estrelas e aurora, com janelas quentes, cordões de luzes coloridas atravessando a rua e uma pista de gelo cortada por linhas finas de luz ciano.

- **Sentimento:** mágico, aconchegante e brilhante, a noite de Natal. O contraste entre o frio da noite e o calor das janelas é o coração do capítulo.
- **Palavras-chave:** noite, luzes, cordões, janelas quentes, gelo, aurora, neve grossa.
- **Referências:** ref 5 (cordões de luz, janelas quentes, toldos listrados, árvore enfeitada, neve grossa). Ver `REFERENCIAS/README`.
- **Chefe:** Rei do Gelo. O perseguidor deste capítulo está em aberto (ver seção 7).
- **Mecânicas próprias:** piso de gelo escorregadio, tirolesa de luzes e planar com correntes de ar sobre fendas.

### Decisão assumida: híbrido

A ref 5 mostra uma vila quente, sem o gelo e o neon que a primeira versão tinha. O capítulo une as duas coisas: **a vila quente da ref 5 como cenário** e **o ciano e a aurora da primeira versão como assinatura da pista e do céu**. O ciano aparece só em linhas finas e na aurora, nunca em barras largas.

### A cena na câmera de jogo

O herói corre no centro de uma pista de gelo azul com divisórias de luz ciano, entre guardas escuras com um fio ciano no topo. Dos dois lados, casas de madeira e tijolo com telhado de neve grossa, janelas laranja e toldos listrados; postes com guirlandas; pinheiros com luzinhas; uma árvore de Natal enorme enfeitada. Cordões de luzes coloridas cruzam a rua em arco a cada 60 studs. Ao fundo, montanhas facetadas azul-noite, a Casa do Papai Noel como marco e uma aurora verde e violeta no céu.

### O que manter e o que mudar da primeira versão

| Manter | Mudar |
| --- | --- |
| Linhas ciano na pista, que deram o visual mais forte | Barras ciano largas nas bordas, que dominavam a tela |
| Montanhas facetadas azul-noite | Pista escura e pouco contrastada |
| Postes de luz amarelos, iglu iluminado | Herói (boneco de neve) quase invisível |
| Céu estrelado | Obstáculos de gelo azul sobre azul, quase invisíveis |
| Pinheiros escuros com luzinhas | Cenário pobre: sem casas, sem janelas quentes, sem cordões |
| Ícone de bala no HUD de moedas | Falta de contraste quente contra frio; imagem escura demais |

## 2. Paleta e materiais

O capítulo é feito de azuis e violetas frios para a noite e de laranja e amarelo quentes para tudo que está aceso; os cordões de luz trazem as outras cores como acento.

| Nome | Código | Uso | Material |
| --- | --- | --- | --- |
| Azul-noite | `#101540` | Topo do céu, montanhas ao fundo, guardas da pista | Atmosfera, SmoothPlastic |
| Violeta | `#3A3F8F` | Meio do céu, montanhas, sombras | Atmosfera, SmoothPlastic |
| Rosado horizonte | `#C7799A` | Horizonte | Atmosfera |
| Gelo da pista | `#6F8FE3` | Superfície da pista | Ice ou SmoothPlastic com leve reflexo |
| Gelo polido | `#BFE0FF` | Trechos escorregadios | SmoothPlastic com reflexo |
| Ciano luz | `#48E6FF` | Linhas finas da pista e detalhes de gelo | Neon |
| Neve azulada | `#DCE8FA` | Chão e capas de neve | SmoothPlastic, Snow só no chão distante |
| Sombra azulada | `#8FA6D6` | Relevos e sombras da neve | SmoothPlastic |
| Janela quente | `#FFB347` | Janelas, lampiões, poças de luz | Neon |
| Madeira escura | `#5B3A29` | Paredes de casas, postes, bancos | SmoothPlastic |
| Tijolo | `#8C4A3C` | Bases, alguns prédios, vaso da árvore | SmoothPlastic |
| Verde noturno | `#1F5A4A` | Pinheiros, guirlandas | SmoothPlastic |
| Toldo | `#D8374B` e `#FFF8EE` | Toldos listrados (a mais de 14 studs da pista) | Fabric |
| Aurora | `#3DF0B0` e `#8A63FF` | Aurora no céu | Neon em feixes |

### Cordões de luz (acento)

Bolinhas Neon nas cores vermelho `#FF4D4D`, verde `#46D38A`, azul `#4DA3FF` e amarelo `#FFD84A`, pequenas (0,6 stud) e alternadas. Só aparecem nos cordões, guirlandas e enfeites de árvore.

### Regras de cor

- **Regra:** quente contra frio. Todo objeto aceso é quente (laranja, amarelo) e todo o resto é frio. Isso é o que faz as janelas "brilharem".
- **Regra:** o ciano é de uso restrito: linhas finas (máximo de 0,4 stud) da pista, pequenos detalhes de gelo e a aurora. Nunca barras largas nem grandes superfícies.
- **Regra:** a pista deve ficar cerca de 20% mais clara que a neve ao redor na captura de tela, mesmo à noite; ajuste a cor medindo na captura, não só no Explorer.
- **Regra:** o toldo vermelho listrado fica a mais de 14 studs da pista e nunca com listras diagonais.
- **Regra:** o violeta de power-up (`#B56BFF`, ver `ARTE-GERAL`, seção 8) não pode aparecer em decoração de cenário.

## 3. Pista de gelo, linhas ciano e trilhos

A pista é gelo azul com linhas finas de luz ciano, que foram o ponto mais forte da primeira versão, mas agora com guardas escuras discretas e muito mais contraste com o resto da imagem; medidas gerais em `ARTE-GERAL`, seção 4.

| Elemento | Especificação (proposta) |
| --- | --- |
| Superfície | Gelo `#6F8FE3`, 24 studs de largura (3 faixas de 8), altura 0,8. Leve reflexo, sem textura granulada forte |
| Divisórias | Neon ciano `#48E6FF`, 0,35 stud, contínuas, com um halo: faixa mais larga (1,2 stud) em Neon muito translúcido (transparência cerca de 0,85) logo abaixo |
| Guarda lateral | Azul-noite `#1B2466`, 2 studs de largura e 1,2 de altura, lisa, com um **fio ciano de 0,4 stud** no topo. Na primeira versão a guarda era uma barra ciano larga: não repetir |
| Borda externa | Faixa de neve azulada de 2 studs, com pequenos montes |
| Brilho do gelo | Pequenas faíscas brancas raras sobre a pista (até 3 emissores ativos) |

### Trechos especiais

| Trecho | Visual | Observação |
| --- | --- | --- |
| Gelo escorregadio | Faixa de gelo polido `#BFE0FF`, mais clara, com reflexo e rachaduras finas | Avisada 20 studs antes por quadros de luz ciano piscando no chão |
| Fenda de gelo | Vão com bordas de gelo e fundo azul-noite escuro; correntes de ar subindo (partículas brancas verticais) | O jogador planeja por cima; a fenda nunca ocupa as 3 faixas sem correntes de ar |
| Tirolesa de luzes | Cabo de luzinhas Neon amarelas a 10 studs de altura, com plataformas de embarque de madeira com neve | Substitui os cordões de arco no trecho |

### Regras

- **Regra:** a divisória de faixa é a linha mais forte da pista; guardas e halos não podem competir com ela.
- **Regra:** o halo ciano não pode escurecer nem lavar as moedas douradas sobre a pista.
- **Regra:** nos trechos especiais, a divisória continua visível.
- **Regra:** teste a pista na captura em tons de cinza: faixas, moedas e obstáculos precisam continuar distintos.

## 4. Catálogo de cenário

O cenário é uma vila de Natal à noite, no estilo de miniatura do jogo, com ênfase em janelas quentes e luzes; medidas em studs (largura por profundidade por altura), em ordem de prioridade.

| Pri. | Objeto | Descrição | Medidas | Peças | Zona |
| --- | --- | --- | --- | --- | --- |
| P1 | Casa de madeira e tijolo (ref 5) | Paredes de madeira escura ou tijolo, telhado em cunha com neve grossa, 3 janelas Neon `#FFB347` com moldura, guirlanda de pinheiro com laço na porta, base de neve | 16 x 14 x 18 | até 60 | Meio |
| P1 | Loja com toldo listrado (ref 5) | Vitrine com luz quente fraca, toldo vermelho e branco em Fabric, placa de madeira, neve no toldo | 18 x 14 x 14 | até 70 | Meio |
| P1 | Cordão de luzes atravessando a rua (ref 5) | Fio de poste a poste, em arco leve (cai 2 studs no meio), a 22 studs de altura, com bolinhas Neon coloridas a cada 3 studs; 1 a cada 60 studs | 40 de vão | até 25 | Alto (acima de 18) |
| P1 | Poste com guirlanda | Poste escuro, lanterna Neon amarela, guirlanda verde com laço; a cada 20 studs, alternando lados | 1 x 1 x 10 | até 6 | Corredor próximo |
| P1 | Árvore de Natal gigante enfeitada (ref 5) | Árvore em 4 níveis com neve, bolas vermelhas, laços, estrela Neon no topo, em vaso de tijolo | 14 x 14 x 20 | até 25 | Meio |
| P1 | Pinheiro noturno | Verde noturno com neve e 4 a 6 luzinhas Neon | 6 x 6 x 12 | até 8 | Corredor próximo e meio |
| P1 | Montanha facetada | Poliedros azul-noite com topo de neve e luz fraca nas faces | 80 a 150 x 60 x 50 a 100 | até 6 | Fundo |
| P1 | Prédio-marco: Casa do Papai Noel | Casa grande de madeira com varanda, 2 chaminés com fumaça, trenó e presentes no telhado, guirlandas de luzes, janelas muito brilhantes; a cada 300 a 400 studs | 40 x 28 x 40 | até 150 | Fundo e meio |
| P2 | Iglu iluminado | Cúpula de neve com abertura de luz quente (já existia na primeira versão: manter) | 10 x 10 x 6 | até 8 | Corredor próximo |
| P2 | Banco e placa de madeira | Bancos com neve, placas de direção | 4 x 2 x 3 | até 6 | Calçada |
| P2 | Caixas de presente com neve | Caixas com laço e neve em cima | 2 x 2 x 2 | até 4 | Calçada |
| P2 | Cerca com luzinhas | Estacas escuras com fio de luzinhas | 8 x 0,5 x 2 | até 10 | Calçada |
| P2 | Poças de luz | Disco Neon quente translúcido (transparência cerca de 0,85) sob janelas e lampiões | 8 de diâmetro | 1 | Chão |
| P3 | Lago congelado | Superfície de gelo polido ao lado da pista, com luminárias e silhuetas de patinadores | 30 x 20 | até 40 | Meio (momento especial) |
| P3 | Trenó com presentes | Trenó parado com pilha de presentes | 8 x 4 x 5 | até 20 | Meio |
| P3 | Chaminés fumegantes extras | Fumaça lenta em casas grandes | variável | até 4 | Meio |

### Regras de construção

- **Janelas quentes são o foco:** peça Neon `#FFB347` com moldura de cor escura, sem luz real por janela. O brilho vem do Bloom (ver seção 6).
- **Cordões:** o fio é fino e escuro; as bolinhas são Neon de 0,6 stud com `CastShadow` desligado. O cordão só existe acima de 18 studs, e só nos trechos sem tirolesa.
- **Neve grossa:** telhados e toldos têm capa de neve branco-azulada de 0,6 a 1 stud, ondulada, com 2 a 3 esferas nas pontas.
- **Miniatura:** casas e marcos sobre base de neve.
- **Tijolo e madeira:** só como cor e forma simples; nada de textura realista (diferente da ref 5).
- **Regra:** nenhuma casa tem mais de 2 cores principais na parede.
- **Regra:** nunca mais de 25% da área visível do cenário em tons quentes acesos; o contraste só funciona se o quente for minoria.

## 5. Composição, conjuntos de chunk e ritmo

O capítulo usa cinco conjuntos de cenário e cordões de luz a cada 60 studs para dar ritmo de rua iluminada; camadas e densidades gerais em `ARTE-GERAL`, seção 5.

| Conjunto | Lado esquerdo | Lado direito | Alto e fundo | Peso no sorteio |
| --- | --- | --- | --- | --- |
| A. Rua das lojas | Casa de madeira, loja com toldo, poste | Loja com toldo, casa de tijolo, poste | Cordão de luzes, montanhas | Alto |
| B. Praça da árvore | Árvore gigante enfeitada, bancos, poste | Casa e pinheiros, caixas de presente | Cordão de luzes, montanhas | Médio |
| C. Floresta nevada | Pinheiros com luzinhas, iglu | Pinheiros, cerca com luzinhas | Montanhas e aurora, sem cordão | Médio |
| D. Lago | Lago congelado com luminárias | Casas pequenas e pinheiros | Cordão de luzes, aurora | Baixo |
| E. Marco | Casa do Papai Noel | Árvores e postes | Aurora e montanhas | Fixo: a cada 300 a 400 studs |

### Momentos especiais (a cada 8 a 10 chunks)

- **Tirolesa de luzes:** trecho com cabo de luzes sobre a pista (substitui cordões de arco).
- **Fendas com correntes de ar:** trecho de planar.
- **Chefe:** o Rei do Gelo no fim do capítulo (ver seção 7).

### Regras de ordem

- O mesmo conjunto não aparece duas vezes seguidas, e o lado do objeto maior alterna.
- Cordões de luz: 1 por chunk (a cada 60 studs), mas nunca em dois chunks seguidos com a mesma cor dominante.
- Cada chunk deve ter pelo menos 4 a 6 janelas acesas visíveis (exceto o conjunto C), para o contraste quente contra frio nunca sumir.
- O último chunk antes da troca de página (ver `ARTE-GERAL`, seção 11) é um trecho aberto: sem cordões e sem props altos perto da pista.

### Chão e primeiro plano

- Neve azulada com relevo, pegadas e montes; nunca chão plano nem escuro demais.
- Primeiro plano: postes a cada 20 studs, cercas com luzinhas e caixas de presente na calçada.
- Menos de 25% do chão visível pode ficar sem objeto, relevo ou luz.

## 6. Luz, céu, aurora e efeitos

O capítulo é uma noite profunda, mas legível: o céu e a neve têm tons azul-violeta visíveis, e todo o brilho forte vem das janelas, dos cordões, das linhas da pista e da aurora, não de iluminação real.

### Perfil de luz

Use a coluna "Cap. 3" da tabela em `ARTE-GERAL`, seção 7, como ponto de partida (`ClockTime` 0, `Brightness` 1, `ExposureCompensation` 0,6, atmosfera azul, `Bloom` forte). Calibre até que:

- a imagem **não** fique preta: pista, chão, herói e obstáculos se leiam facilmente na captura (a primeira versão estava escura demais);
- as janelas e cordões brilhem (Bloom) sem estourar a tela;
- o céu mostre o gradiente de azul-noite a rosado no horizonte;
- a pista fique cerca de 20% mais clara que a neve ao redor.

### Aurora

- 3 a 5 **feixes** (`Beam`) entre `Attachment`s altos no céu, cada um com `LightEmission` 1, `Segments` 20 ou mais e curva diferente, em verde `#3DF0B0` e violeta `#8A63FF` com transparência entre 0,5 e 0,75.
- Balanço lento por script (ondas de 8 a 12 s), nunca rápido nem piscante.
- Ficam bem ao fundo, acima do horizonte e das montanhas, nunca no meio da tela em cima do herói.

### Efeitos específicos

| Efeito | Especificação (proposta) |
| --- | --- |
| Estrelas | `Sky.StarCount` alto (cerca de 3000), brilho leve |
| Neve caindo | Flocos brancos pequenos, 20 a 30 por segundo, com leve brilho |
| Pisca-pisca dos cordões | As bolinhas acendem em ondas lentas e sequenciais (2 a 4 s), nunca todas ao mesmo tempo |
| Poças de luz | Discos Neon quentes translúcidos sob janelas e lampiões |
| Fumaça das chaminés | Branca azulada, subindo devagar, nos marcos e casas grandes |
| Brilho do gelo | Faíscas brancas raras sobre a pista |
| Linhas de vento | Só em velocidade alta, finas e claras |

### Contorno e luz do herói

- Luz própria: `PointLight` com `Brightness` 1,2, `Range` 14 e cor `#FFD9A0`.
- Contorno quente `#FFE9B0`, mais visível que o padrão, para o herói se separar da pista e do chão azuis.
- O Boneco de Neve (branco) precisa de contorno e luz mais fortes, porque sumiu neste capítulo na primeira versão.

### Regras

- **Regra:** `DepthOfFieldEffect` fica desligado neste capítulo.
- **Regra:** no máximo 6 luzes reais ativas (a do herói e as dos postes mais próximos); o resto do brilho é Neon e Bloom.
- **Regra:** o brilho da aurora nunca reduz a legibilidade da pista nem de obstáculos.

## 7. Obstáculos, coletáveis, vilões e chefe

À noite, o maior risco é o jogador não enxergar o perigo; por isso todo obstáculo tem brilho próprio de alerta, e os itens de gameplay seguem o código de `ARTE-GERAL`, seção 8.

### Coletáveis

| Item | Aparência | Medidas e movimento |
| --- | --- | --- |
| Moeda de Natal | Bala embrulhada dourada `#FFC93C` com pontas brancas, Neon um pouco mais forte que de dia | 2 a 2,5 studs, gira e flutua |
| Bônus (vale 5 moedas) | Presente pequeno dourado com laço branco | 3 studs |
| Power-ups | Esfera violeta `#B56BFF` dentro de um anel branco, brilhando | 3 studs, pulsa |

### Obstáculos

| Tipo | Versão do Polo | Aparência | Medidas (proposta) |
| --- | --- | --- | --- |
| Baixo (pular) | Bloco de gelo com fita de alerta | Bloco azul-gelo escuro com faixa vermelha forte e listras azul-marinho, quinas com fio Neon vermelho fraco | 6 x 2 x 2 |
| Alto (deslizar) | Estalactite ou viga de gelo | Barra de gelo suspensa a 3 studs do chão, com placas de alerta e Neon vermelho fraco | 8 x 1,5 x 1,5 |
| Bloco inteiro (trocar de pista) | Muro de gelo | Parede de gelo escuro com luzes de alerta vermelhas no topo | 8 x 4 x 6 |
| Móvel (cronometrar) | Bola de neve gigante ou trenó de gelo | Rolando ou deslizando pela pista; sombra e listras de aviso no chão 20 studs antes | 6 a 8 x 4 x 4 |
| Piso especial | Gelo escorregadio e fenda com correntes de ar | Ver seção 3 | por faixa |

**Regra:** nunca azul sobre azul. O obstáculo é sempre mais escuro que a pista e tem uma borda de alerta vermelha visível.

### Chefe: Rei do Gelo

- **Papel:** chefe do capítulo, evento de 20 a 30 s no fim do Polo Norte, lançando blocos de gelo e fechando faixas em padrões, sempre com aviso (círculo vermelho translúcido no chão 1 s antes).
- **Silhueta:** figura alta e larga (cerca de 14 studs), coroa de cristais pontuda, manto longo, barba de gelo e um cetro de cristal.
- **Cores:** azul-marinho `#1B2466` e branco, com cristais ciano `#48E6FF`. É pesado e largo, **diferente da Fada do Gelo** (herói), que é leve, clara e delicada.
- **Tom:** imponente e cômico, para crianças; olhos ciano brilhando, sem sustos nem violência.
- **Recompensa:** ao fim do evento, chuva de presentes e moedas, e a página final do livro.

### Perseguidor do capítulo

- **Em aberto:** perguntar ao usuário. Sugestão: o **Boneco de Neve Maligno** (variante prevista no documento de design), com chapéu rachado, olhos vermelhos e uma vassoura. Também é possível reaproveitar o Krampus.

## 8. Checklist de aceite do capítulo 3

O capítulo 3 só é dado como pronto quando todos os itens abaixo passam em capturas de tela da câmera de jogo, da visão alta e do close do herói, além da checklist global de `ARTE-GERAL`, seção 12.

### Clima

- [ ] A cena lembra a ref 5: janelas quentes e cordões de luz coloridos contra um céu azul-roxo.
- [ ] O contraste quente contra frio é imediato; o quente é minoria (menos de 25% do cenário).
- [ ] Aurora verde e violeta ao fundo, lenta, sem competir com a pista.
- [ ] A imagem não é escura demais: pista, chão, herói e obstáculos legíveis.
- [ ] A neve dos telhados é grossa e as casas têm base de neve.

### Pista e leitura

- [ ] Linhas ciano finas (no máximo 0,4 stud); nenhuma barra ciano larga.
- [ ] Guardas escuras com fio ciano no topo.
- [ ] A pista está cerca de 20% mais clara que a neve ao redor na captura.
- [ ] Obstáculos têm borda de alerta vermelha e nunca são azul sobre azul.
- [ ] Moedas douradas e power-ups violeta legíveis sobre o gelo.
- [ ] O herói (principalmente o Boneco de Neve) tem contorno e luz própria e se destaca.

### Cenário

- [ ] Todos os objetos P1 do catálogo estão no jogo e há pelo menos 3 itens P2.
- [ ] Cordões de luz a cada 60 studs, a 22 studs de altura, nunca em trechos de tirolesa.
- [ ] A Casa do Papai Noel aparece a cada 300 a 400 studs.
- [ ] Nenhuma peça sólida dentro do corredor da pista.
- [ ] Toldos vermelhos e qualquer vermelho de cenário a mais de 14 studs da pista.

### Desempenho

- [ ] Máximo de 6 luzes reais; brilho por Neon e Bloom.
- [ ] Aurora com no máximo 5 feixes; orçamento de peças respeitado.
- [ ] Sem quedas visíveis de FPS no celular de entrada.

### Pergunta ao usuário antes de encerrar o capítulo

- Aprova o visual do Rei do Gelo?
- Quem é o perseguidor deste capítulo (Boneco de Neve Maligno, Krampus ou outro)?
- Mais frio e mágico (mais ciano e aurora) ou mais aconchegante (mais luz quente)?
