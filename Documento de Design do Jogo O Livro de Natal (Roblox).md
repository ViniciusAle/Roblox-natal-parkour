# Documento de Design do Jogo: O Livro de Natal (Roblox)

> **Atualização de 28/10/2026:** o tema mudou de Natal para anime e, no mesmo dia, de anime para brainrot (personagens originais, por causa de direitos autorais). O nome provisório agora é "Brainrot Rush", a pista tem 5 pistas e os perseguidores estão desligados por enquanto. Personagens, fases e estilo novos estão em `docs/STYLE.md` e `docs/STATUS.md`. As regras de jogo, justiça da pista, servidor autoritativo e arquitetura deste documento continuam valendo.

Oct 27, 2026 · @Euclides

## 1. Visão geral

O Livro de Natal é um runner infinito natalino de 3 pistas para Roblox, desenhado para ser satisfatório de jogar, fácil de rejogar e rentável com habilidades, personagens e ambientes vendidos dentro do jogo.

- **Gênero:** runner infinito em 3D, no estilo de Subway Surfers e Temple Run, com mecânicas de pulo variadas.
- **Plataformas:** celular primeiro, com suporte completo a PC (muitos streamers jogam no PC). Toque, teclado e, se possível, controle.
- **Público:** crianças e adolescentes. Visual, linguagem e monetização precisam ser adequados a essa faixa.
- **Modos:** solo e corrida multiplayer na mesma pista.
- **Meta de lançamento:** antes de 13/12/2026. O prazo é flexível e a qualidade vem antes da data.
- **Objetivo de negócio:** gerar receita vendendo personagens, ambientes e habilidades.
- **Mínimo no lançamento:** 5 personagens jogáveis, 3 ambientes, cerca de 8 habilidades e vilões perseguidores e chefes.

### Pilares de design

1. **Satisfatório ao toque:** cada ação responde na hora, com som, partículas e câmera.
2. **Fácil de aprender, difícil de dominar:** regras simples, velocidade crescente.
3. **Colecionar e personalizar:** personagens, ambientes e habilidades que o jogador quer ter.
4. **Natal com identidade própria:** o conceito de O Livro de Natal, sem copiar personagens de terceiros.
5. **Feito para crescer:** conteúdo novo entra como dados em tabelas de configuração, não como código novo.

## 2. Conceito: O Livro de Natal

Cada ambiente do jogo é um capítulo de um livro de histórias de Natal, e a troca de ambiente acontece com a página virando.

O conceito junta quatro linguagens visuais numa ideia só:

- **Vila de pão de mel:** casas de biscoito, glacê, bengalas doces. Capítulo 1.
- **Papel recortado:** camadas coloridas com sombras suaves. Capítulo 2, a fábrica de brinquedos.
- **Noite de luzes:** tudo brilha no escuro, com aurora e pisca-pisca. Capítulo 3, o Polo Norte.
- **Livro pop-up:** a moldura do jogo e a transição entre capítulos (a página vira e o próximo mundo aparece).

**Regra de unidade:** os três capítulos compartilham as mesmas formas simples e os mesmos modelos de personagem. O que muda por capítulo é paleta, material, iluminação e efeitos. Isso mantém o trabalho de arte viável no prazo.

**Monetização:** capítulos novos são ambientes novos e podem ser vendidos ou liberados em eventos.

**História (sugestão, a validar):** os presentes de Natal foram roubados pelos vilões e o jogador corre pelas páginas do livro para recuperá-los.

**Status:** decidido em 27/10/2026. Cada capítulo segue a proposta acima, e o Capítulo 3 usa neon equilibrado. O guia de estilo está em `docs/STYLE.md` (ver seção 15).

## 3. Loop principal e progressão

O jogador corre, coleta moedas, cai, gasta na loja e volta a correr; cada volta precisa deixá-lo um pouco mais forte ou com algo novo para desejar.

1. **Preparar:** escolher personagem, capítulo e habilidades iniciais.
2. **Correr:** desviar, pular, deslizar e coletar presentes e bengalas doces.
3. **Tropeçar:** o vilão se aproxima; no segundo tropeço seguido (ou sem vida extra) a corrida termina.
4. **Receber:** moedas, pontuação por distância e progresso de missões.
5. **Gastar:** loja de personagens, ambientes, habilidades e melhorias.
6. **Correr de novo:** voltar à pista com no máximo 1 toque.

### Progressão

- **Moeda principal:** Moedas de Natal, ganhas correndo.
- **Melhorias permanentes:** níveis 1 a 5 em habilidades (por exemplo, duração do ímã).
- **Missões e conquistas:** diárias e semanais, com recompensa em moedas.
- **Ranking global semanal:** por distância, com prêmio para o topo.
- **Moeda premium:** em aberto. A proposta é vender itens direto em Robux, sem moeda premium separada (ver seção 11).

## 4. Controles e mecânicas de movimento

O personagem avança sozinho e o jogador só troca de pista, pula, desliza e ativa a habilidade; os mesmos comandos precisam funcionar bem no toque e no teclado.

| Ação | Celular | PC |
| --- | --- | --- |
| Trocar de pista | Deslizar para esquerda ou direita | A e D, ou setas |
| Pular | Deslizar para cima | Espaço, W ou seta para cima |
| Deslizar (abaixar) | Deslizar para baixo | S, Ctrl ou seta para baixo |
| Habilidade ativa | Botão na tela | E ou Shift |

Controle (gamepad) é desejável, mas fica fora do MVP.

### Movimento

- A velocidade começa baixa e sobe de forma gradual durante a corrida, até um teto.
- Valores iniciais sugeridos, a ajustar em testes: 30 studs por segundo no começo, subindo até 70 em cerca de 3 minutos.
- Troca de pista suave (cerca de 0,12 s) com **buffer de entrada** de 0,15 s: se o jogador comandar um pouco antes, o comando vale.
- **Coyote time** de 0,1 s: o pulo ainda funciona logo após sair da borda.
- Câmera atrás e acima do personagem, com FOV que aumenta com a velocidade e tremida leve em impactos.

### Mecânicas de pulo

- **Altura variável:** toque curto pula baixo, toque longo pula alto. No MVP.
- **Pulo duplo:** melhoria permanente. No MVP.
- **Planar:** guarda-chuva ou balão, segura o personagem no ar por instantes. No MVP.
- **Trampolim de presente:** plataforma que lança o personagem para cima. No MVP.
- **Pulo na parede** e **gancho de bengala doce:** depois do lançamento.

## 5. Pista, geração e obstáculos

A pista é montada em tempo real a partir de blocos modulares (chunks) sorteados por uma seed, o que permite pista infinita, conteúdo novo só adicionando blocos e a mesma pista para todos na corrida multiplayer.

- **Chunk:** trecho de comprimento fixo (sugestão: 60 studs) com 3 pistas e encaixe padronizado na entrada e na saída.
- **Cada chunk tem:** id, ambiente (capítulo), nível de dificuldade de 1 a 5 e a lista de objetos (obstáculos, moedas, power-ups).
- **Gerador:** sorteia chunks conforme a distância percorrida e a dificuldade, usando um gerador de números aleatórios determinístico alimentado pela **seed**. Mesma seed gera a mesma pista.
- **Reciclagem (pooling):** manter cerca de 5 a 6 chunks à frente do jogador e reaproveitar os que ficaram para trás, em vez de criar e destruir.
- **Justiça:** toda sequência de chunks precisa ter pelo menos uma rota livre; nunca bloquear as 3 pistas sem saída. Cada chunk é validado ao ser cadastrado.
- **Transição de capítulo:** a cada marca de distância (sugestão: 1000 m) um chunk especial faz a página virar e muda o ambiente.

### Tipos de obstáculo

| Obstáculo | Como o jogador reage | Exemplo |
| --- | --- | --- |
| Baixo | Pular | Caixa de presente, tronco |
| Alto | Deslizar | Galho, viga de esteira |
| Bloco inteiro | Trocar de pista | Casa de biscoito, bloco de gelo |
| Móvel | Cronometrar a passagem | Trenó cruzando, engrenagem giratória |
| Piso especial | Adaptar o movimento | Gelo escorregadio, esteira da fábrica |

### Trechos especiais

Planar sobre vãos, tirolesa de luzes, trecho de trenó em alta velocidade e áreas de trampolim. Cada capítulo tem pelo menos um trecho especial próprio.

### Coletáveis

Bengalas doces e presentes (moedas), power-ups da corrida e, mais raramente, itens de evento.

## 6. Personagens jogáveis

O lançamento tem 5 heróis, cada um com um jeito diferente de jogar; o primeiro é gratuito e os outros são desbloqueados na loja.

| Herói | Papel | Habilidade |
| --- | --- | --- |
| Duende Corredor | Inicial, equilibrado | Passiva: pequeno bônus de moedas |
| Papai Noel | Resistente, mais pesado | Passiva: começa a corrida com 1 escudo; troca de pista um pouco mais lenta |
| Rena Rudolfo | Velocista | Ativa: dash com o nariz brilhando, acelera e fica invulnerável por pouco tempo |
| Boneco de Neve | Escorregador | Passiva: desliza por mais tempo. Ativa: rola como bola de neve e esmaga obstáculos baixos |
| Fada do Gelo | Aérea | Passiva: planar mais longo. Ativa: congela o tempo, deixando o mundo e o vilão mais lentos |

Reserva para atualização futura: **Quebra-Nozes**, com habilidade de quebrar obstáculos.

- Os valores de duração e recarga de cada habilidade ficam em tabela de configuração e são balanceados em testes (sugestão inicial: habilidade ativa de 1,5 a 3 s com recarga de 25 a 35 s).
- Cada herói tem **skins** cosméticas que podem ser vendidas à parte.
- Cada herói é uma linha na tabela de configuração: id, nome, modelo, passiva, ativa, preço. Adicionar herói novo não deve exigir código novo.
- Preços ficam na seção 11, Economia.

## 7. Vilões

Há dois tipos de vilão: perseguidores, que dão tensão durante toda a corrida, e chefes, que aparecem em momentos marcados como eventos curtos.

| Vilão | Tipo | Capítulo | Comportamento |
| --- | --- | --- | --- |
| Krampus | Perseguidor | Vila de pão de mel | Corre atrás do jogador e se aproxima a cada tropeço |
| Duende Rebelde | Perseguidor | Fábrica de brinquedos | Joga peças e caixas na pista enquanto persegue |
| Ranzinza Verde | Chefe | Vila de pão de mel | Tenta roubar os presentes; evento com padrão de ataques |
| Rei do Gelo | Chefe | Polo Norte | Lança blocos de gelo e fecha pistas em padrões |

Variante para o futuro: Boneco de Neve Maligno.

### Regras dos perseguidores

- O primeiro tropeço faz o jogador perder velocidade e o vilão chegar perto.
- Um segundo tropeço em até 10 s (sugestão) termina a corrida, a não ser que o jogador tenha escudo ou vida extra.
- Se o jogador corre limpo por um tempo, o vilão volta a ficar para trás.

### Regras dos chefes

- Aparecem no fim de cada capítulo ou a cada marca de distância, como evento de 20 a 30 s (sugestão).
- Não há combate: o jogador sobrevive a uma sequência de ataques sinalizados com aviso visual.
- Sobreviver dá recompensa extra em presentes e moedas.

### Regra de propriedade intelectual

Todos os vilões são originais ou vêm do folclore. **Não usar o Grinch** nem nada que lembre seu nome, rosto ou design: o Ranzinza Verde precisa ter visual próprio e claramente diferente. Conferir antes de publicar.

## 8. Ambientes (capítulos)

O lançamento tem 3 capítulos, cada um com visual, mecânicas de pista e vilões próprios; o visual abaixo é a proposta atual e continua em aberto.

| Capítulo | Tema | Visual proposto | Mecânicas próprias | Vilões |
| --- | --- | --- | --- | --- |
| 1. Vila de pão de mel | Casas de biscoito, glacê, doces | Pão de mel | Pista de biscoito, trampolins de bala de goma | Krampus, Ranzinza Verde |
| 2. Fábrica de brinquedos | Esteiras, engrenagens, caixas | Papel recortado | Esteiras que aceleram ou invertem, engrenagens giratórias | Duende Rebelde |
| 3. Polo Norte | Gelo, aurora boreal, luzes | Noite de luzes | Piso de gelo escorregadio, tirolesa de luzes, planar com correntes de ar | Rei do Gelo |

- O jogador escolhe o capítulo inicial na tela de preparo; durante a corrida a página vira e o próximo capítulo assume.
- **Personalização:** cada capítulo pode ter variações compráveis (decoração, paleta, efeitos), além de capítulos inteiros novos.
- **Ambientes futuros, para venda:** Floresta do Krampus, Cidade Enfeitada, Casa de Natal.
- Cada ambiente é uma linha de configuração: id, nome, paleta, conjunto de chunks, vilões, música, preço.

## 9. Habilidades e power-ups

O lançamento tem cerca de 8 habilidades em três grupos: 4 itens pegos na pista, 3 melhorias permanentes e 1 consumível forte. A lista é uma proposta inicial para discutir e balancear.

| Habilidade | Grupo | Efeito | Como obter |
| --- | --- | --- | --- |
| Ímã de Doces | Item da pista | Atrai moedas próximas por alguns segundos | Coletar na pista |
| Escudo de Gelo | Item da pista | Absorve 1 colisão | Coletar na pista |
| Moedas em Dobro | Item da pista | Dobra as moedas por alguns segundos | Coletar na pista |
| Patins de Gelo | Item da pista | Acelera e dá invulnerabilidade curta | Coletar na pista |
| Pulo Duplo | Melhoria permanente | Permite um segundo pulo no ar | Comprar uma vez |
| Vida Extra | Melhoria permanente | Revive uma vez por corrida; níveis mais altos dão mais revives | Comprar e subir de nível |
| Ímã Poderoso | Melhoria permanente | Aumenta duração e alcance do Ímã de Doces | Subir de nível (1 a 5) |
| Portal de Neve | Consumível forte | Teletransporta cerca de 150 m à frente, com invulnerabilidade | Comprar com moedas ou Robux |

- Durações, alcances e preços ficam em tabela de configuração e são ajustados em testes.
- Habilidades que afetam a jogabilidade também podem ser conquistadas jogando; o que é pago deve ser conveniência ou cosmético (ver seção 11).
- Ideias para depois: gancho de bengala doce, pulo na parede, companheiro (rena mascote).

## 10. Multiplayer

O jogo tem dois modos que usam o mesmo sistema de pista: solo e corrida multiplayer, em que todos os jogadores correm a mesma sequência de blocos.

- **Solo:** cada jogador corre na sua própria pista, com ranking global.
- **Corrida:** de 2 a 8 jogadores (sugestão) recebem a **mesma seed**, cada um numa pista paralela e separada, sem colisão entre jogadores. Vence quem chegar mais longe; o último vivo também pode valer como regra alternativa.
- **Lobby:** fila com contagem regressiva antes de cada corrida (sugestão: 30 s) e tela de resultados com recompensas.
- **Decidido em 27/10/2026:** o lobby é uma vila 3D em que dá para andar. Quem pisa no círculo dourado em frente ao livro gigante entra na fila. Todos correm a mesma seed, veem os rivais como fantasmas com nome e recebem o ranking no fim. A corrida multiplayer foi antecipada da fase 4.
- **Streamers:** os rivais aparecem com nome, há modo espectador e o ranking da partida fica visível.
- **Fora do MVP:** modo cooperativo.

### Divisão cliente e servidor

- O **cliente** simula o próprio movimento e a pista, para a resposta ser imediata.
- O **servidor** define a seed, inicia e encerra a corrida, valida distância, velocidade e moedas ganhas, e é dono dos resultados e dos prêmios.
- Para outros jogadores, o cliente mostra uma versão simplificada com posição e estado, atualizada algumas vezes por segundo.

## 11. Economia e monetização

O jogo ganha dinheiro vendendo personagens, ambientes, habilidades e cosméticos em Robux, com uma moeda gratuita (Moedas de Natal) que mantém o jogo justo para quem não paga.

| Produto | Tipo no Roblox | Exemplos |
| --- | --- | --- |
| Passes (compra única, permanente) | Game Pass | Moedas em dobro, ímã automático, pacote VIP de cosméticos |
| Consumíveis | Developer Product | Pacotes de moedas, reviver na hora, Portal de Neve, boosts |
| Personagens e skins | Item do jogo, comprado com moedas ou Robux | Heróis, skins, rastros |
| Ambientes e capítulos | Item do jogo | Variações de decoração, capítulos novos |

Preços e pacotes: **a definir**.

### Princípios

- **Nada de pay-to-win pesado:** o que é pago dá conveniência ou cosmético, e o resto também pode ser conquistado jogando.
- **Transparência para o público jovem:** preços claros, sem pressão agressiva nem contagens regressivas enganosas.
- **Itens aleatórios pagos** (caixas, sorteios) só com divulgação das chances e depois de conferir a política vigente do Roblox.
- **Servidor autoritativo:** compras, moedas e inventário são validados no servidor, nunca no cliente.

### A confirmar antes de implementar

As regras atuais do Roblox para taxa sobre vendas, resgate de Robux (DevEx), pagamentos por engajamento de usuários Premium e itens aleatórios mudam com o tempo. Conferir a documentação oficial antes de fechar esta seção.

## 12. Retenção e eventos

Para o jogador voltar todo dia, o jogo oferece uma recompensa diária, missões curtas e um evento de Natal com data marcada.

- **Calendário do Advento:** uma recompensa por dia, de 1 a 24 de dezembro. Se o lançamento for perto de 13/12, o calendário pode virar uma versão de 12 dias ou começar já com recompensas atrasadas liberáveis. Decisão em aberto.
- **Recompensa diária:** valor que cresce com dias seguidos.
- **Missões:** 3 diárias e 3 semanais, como "coletar 200 moedas" ou "correr 1000 m sem tropeçar".
- **Ranking global semanal:** por distância, com prêmio para o topo.
- **Conquistas:** metas de longo prazo (primeiro chefe derrotado, todos os heróis, todos os capítulos).
- **Depois do Natal:** o jogo continua como jogo de inverno, com eventos novos e capítulos extras, para não perder jogadores em 26/12.

## 13. UI e UX

A interface é pensada primeiro para celular, com poucos elementos durante a corrida e o caminho de volta ao jogo sempre de 1 toque.

| Tela | Conteúdo principal |
| --- | --- |
| Menu principal | Jogar solo, Corrida, Loja, Personagens, Missões, Calendário |
| Preparar corrida | Escolha de herói, capítulo e habilidades iniciais |
| HUD da corrida | Moedas, distância, power-up ativo, botão da habilidade, vidas extras |
| Fim de corrida | Distância, moedas, missões concluídas, botão "Correr de novo" |
| Loja | Abas de personagens, ambientes, habilidades e moedas |
| Calendário | Recompensa do dia e dias anteriores |

- Botões grandes e fáceis de tocar com o polegar, fora das bordas do aparelho (áreas seguras).
- Layout por escala (e não por pixels fixos), testado no emulador de dispositivos do Studio em telas pequenas e grandes.
- Texto legível a distância, em português, curto e sem rolagem durante a corrida.
- As telas são desenhadas primeiro como referência visual (por exemplo, no Claude Design) e implementadas depois no Studio.

## 14. Áudio e juice

O que faz esse tipo de jogo ser satisfatório são pequenos efeitos em cada ação, e eles entram no jogo desde o primeiro protótipo, não só no polimento final.

- **Moedas:** o som sobe de tom a cada moeda seguida, reiniciando ao errar.
- **Pulo e pouso:** poeira de neve e leve tremida de câmera ao pousar.
- **Velocidade:** o FOV aumenta e as linhas de vento aparecem à medida que a corrida acelera.
- **Quase-colisão:** bônus de pontos e um instante curto de câmera lenta.
- **Combos:** sequências de moedas e desvios mostram números flutuantes e multiplicador.
- **Resposta imediata:** nenhum comando pode demorar para dar retorno visual ou sonoro.
- **Neve e luzes:** partículas leves de neve e brilho nos itens, respeitando o limite de desempenho no celular.

### Áudio

- Música de fundo e efeitos precisam ter **licença clara**. Preferir áudio do Creator Store com uso permitido ou material próprio, e anotar a origem de cada arquivo.
- Evitar músicas de Natal famosas gravadas por terceiros, que podem dar problema de direitos autorais.
- Uma música por capítulo, com a troca acompanhando a virada de página.

## 15. Direção de arte (DECIDIDA)

**Decidido em 27/10/2026:** cada capítulo usa o estilo proposto abaixo: pão de mel, papel recortado e noite de luzes, com o livro pop-up na transição. O Capítulo 3 é **neon equilibrado**: luz nos detalhes, com piso e obstáculos legíveis. O guia de estilo para o Claude seguir está em `docs/STYLE.md`. Logo e tela inicial continuam em aberto.

| Estilo | Ideia | Viabilidade no Roblox |
| --- | --- | --- |
| Vila de pão de mel | Pista de biscoito, casas com glacê, doces | Alta: formas e cores simples, o Claude monta por script |
| Papel recortado | Camadas de papel com sombras suaves | Boa: peças finas, sombras e luz suave |
| Noite de luzes | Tudo brilha no escuro | Boa: material neon, Bloom e correção de cor; atenção ao desempenho no celular |
| Livro pop-up | Moldura do jogo e página virando entre capítulos | Média: é mais um efeito de transição do que um estilo de cenário |

### Regras que valem para qualquer estilo

- Formas simples (low-poly) e poucas peças, pensando em celulares fracos.
- Silhuetas legíveis: perigo e recompensa se distinguem por cor e forma de relance.
- Cada capítulo tem paleta, material, iluminação e efeitos próprios, mas compartilha as formas base e os modelos de personagem.
- O Claude monta cenário, efeitos e interface com peças básicas e script. Modelos 3D complexos, texturas pintadas, áudio e animações de personagem customizadas precisam vir do Creator Store, de ferramentas externas ou de quem produzir a arte.

### Como vamos decidir

1. Explorar o conceito no Claude Design (arte-chave por capítulo, telas, ícones, logo).
2. Escolher o estilo de cada capítulo.
3. Registrar aqui um guia de estilo (paleta, materiais, iluminação, efeitos) para o Claude Code seguir.

Perguntas abertas: quantos estilos distintos cabem no prazo? Capítulo 3 totalmente neon ou mais discreto? Qual a identidade do logo e da tela inicial?

## 16. Arquitetura técnica

O cliente simula o movimento e a pista para responder na hora, o servidor valida e guarda o que vale dinheiro, e as tabelas de configuração compartilhadas dizem aos dois o que existe no jogo.

&#91;embedded content: arquitetura técnica · cliente, compartilhado e servidor\]

As setas são os Remotes: o cliente pede (iniciar corrida, comprar, usar habilidade) e o servidor responde (seed, resultados, saldo).

- **Onde fica cada coisa:** Cliente em StarterPlayerScripts, Compartilhado em ReplicatedStorage e Servidor em ServerScriptService.
- **Config orientada a dados:** heróis, habilidades, ambientes, chunks, vilões, preços e missões são tabelas. Conteúdo novo é linha nova, não código novo.
- **Movimento (proposta a validar no protótipo):** movimento próprio e previsível, por CFrame, com colisão por verificação de sobreposição, em vez de depender da física do Humanoid.
- **Dados salvos:** progresso, moedas, itens e melhorias por jogador, com proteção contra gravação simultânea (como faz a biblioteca ProfileStore) e OrderedDataStore para o ranking.
- **Desempenho:** reaproveitar chunks e objetos (pooling), limitar peças por chunk e partículas, e testar em celular de entrada.
- **Testes:** play test do Studio com vários clientes para simular a corrida multiplayer.

## 17. Roadmap e escopo do MVP

O plano propõe cinco fases em sequência, com um gate no fim de cada uma, para chegar ao lançamento até 12/12, um dia antes do limite de 13/12.

&#91;embedded content: roadmap · 5 fases e 5 gates, de 27/10 a 12/12\]

O cronograma é uma proposta e o prazo é flexível. Cada gate precisa estar cumprido antes de começar a próxima fase.

- **Prazo apertado:** são cerca de 6,5 semanas para 5 heróis, 3 capítulos, loja, dados salvos e multiplayer. Se atrasar, o primeiro candidato a sair é a corrida multiplayer (fase 4), que pode virar atualização logo após o lançamento. A decisão é do usuário.
- **Congelamento de funcionalidades em 06/12:** depois dessa data só entram correções, polimento e testes.
- **Princípio:** um jogo pequeno e polido vence um jogo grande e quebrado. Cada fase termina com algo jogável.
- **Primeira entrega, o mais cedo possível:** uma versão feia mas jogável (fase 1) para sentir o movimento antes de investir em arte.
- **Atualizações depois do lançamento:** Quebra-Nozes, mais capítulos, modo cooperativo, pets e eventos de inverno.

## 18. Regras de trabalho para o Claude

Este documento é a fonte da verdade do projeto: o Claude o lê no começo de cada sessão, trabalha em passos pequenos e testáveis e pergunta antes de decidir qualquer coisa marcada como em aberto.

### Ferramentas e fluxo

- O Claude Code trabalha conectado ao Roblox Studio pelo servidor MCP embutido. Com mais de uma janela do Studio aberta, escolher a instância ativa antes de qualquer alteração.
- Um sistema por vez (por exemplo: movimento, depois pista, depois coleta). Ao fim de cada passo, rodar um play test, dizer o que foi testado e o que falhou.
- Antes de apagar, reestruturar ou mexer em dados salvos (DataStore), pedir confirmação e garantir uma cópia ou versão do lugar.
- Ao fim de cada sessão: resumo curto com o que foi feito, o que está quebrado e o próximo passo; atualizar o roadmap.

### Código

- Luau com tipagem estrita (`--!strict`), módulos pequenos e de uma responsabilidade só.
- Identificadores em inglês; comentários curtos em português só onde o código não for óbvio.
- Sem números mágicos: velocidades, durações, preços e dificuldades vivem em módulos de configuração.
- Conteúdo novo (herói, habilidade, ambiente, chunk) é uma linha de configuração, não código novo.
- Nada de criar objetos a cada quadro; usar reaproveitamento (pooling) e limitar o número de peças, pensando no celular.
- O servidor é dono de moedas, compras, inventário e resultados. Nunca confiar no que o cliente informa.

### Ativos e políticas

- Não usar propriedade intelectual de terceiros (Grinch, personagens de estúdios, músicas sem licença).
- Registrar a origem e a licença de cada ativo (modelo, som, imagem).
- Conteúdo adequado a crianças e adolescentes. Conferir a documentação oficial do Roblox antes de implementar compras, itens aleatórios e regras de monetização.

### Quando perguntar

- **Perguntar:** decisões de design (visual, nomes, preços, balanceamento), qualquer item marcado como em aberto e dúvidas sobre o que o usuário quer.
- **Não perguntar:** detalhes técnicos que este documento já cobre; nesses casos, seguir o documento e registrar a decisão.
- Quando houver duas opções boas, recomendar uma, explicar em duas linhas e esperar a resposta.

### Idioma

Conversar em português. Código em inglês. Idioma dos textos do jogo: em aberto (ver seção 19).

## 19. Decisões em aberto

O que ainda precisa ser decidido, em ordem de impacto; o Claude pergunta sobre estes itens antes de assumir qualquer valor.

- [x] **Direção de arte final** dos três capítulos (seção 15): proposta do GDD, Cap. 3 com neon equilibrado (27/10/2026)
- [ ] **Idioma dos textos do jogo:** português, inglês ou os dois (o Roblox é global)
- [ ] **Nome final do jogo** (o título atual é provisório)
- [ ] **Preços** de itens, pacotes de moedas, passes e Robux
- [ ] **Moeda premium separada** ou venda direta em Robux
- [ ] **Fórmula de pontuação** e regras de vitória da corrida
- [ ] **Jogadores por corrida** (a sugestão é de 2 a 8)
- [ ] **Calendário do Advento:** 24 dias ou versão de 12 dias, conforme a data de lançamento
- [ ] **História** dos presentes roubados: aprovar ou trocar
- [ ] **Origem da música e dos sons** (próprios, Creator Store ou outra)
- [ ] **Regras atuais do Roblox** para monetização, resgate de Robux e itens aleatórios
- [ ] **Quem testa o jogo** antes do lançamento (amigos, grupo fechado)
- [ ] **Depois do lançamento:** modo cooperativo, Quebra-Nozes, pets e capítulos novos
