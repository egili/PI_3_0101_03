import '../models/dialogue.dart';

// Mapa central de todos os diálogos do jogo.
// Chave: ID do nó | Valor: DialogueNode
// Missões concluídas via onSelect nos nós finais de cada arco.
final Map<String, DialogueNode> gameScript = {

  // ══════════════════════════════════════════════════════════════════════════
  // H15 — Dr. Garibaldo P. Pingulino
  // Missão ativada: m1_bibliotecario
  // ══════════════════════════════════════════════════════════════════════════

  'h15_intro_1': DialogueNode(
    id: 'h15_intro_1',
    characterName: 'Dr. Garibaldo',
    text:
        'Você acordou! Excelente! Quer dizer… dentro de uma margem aceitável… talvez nem tanto… eu já estava considerando uma falha no protocolo o que seria ruim. Muito ruim. Deve ter sido algum erro no coeficiente neural… ou no criogênico… depois eu vejo isso. Isso não importa agora! Como você está se sentindo?',
    choices: [
      DialogueChoice(text: 'O que aconteceu aqui?', nextNodeId: 'h15_intro_2a'),
      DialogueChoice(text: 'Quem são vocês?', nextNodeId: 'h15_intro_2b'),
      DialogueChoice(text: 'Eu vou embora daqui.', nextNodeId: 'h15_intro_2c'),
    ],
  ),

  // Opção 2 — Quem são vocês?
  'h15_intro_2b': DialogueNode(
    id: 'h15_intro_2b',
    characterName: 'Dr. Garibaldo',
    text:
        'Ah! Sim, apresentações! Eu sou o Dr. Garibaldo Pingulino, cientista-chefe deste laboratório! E ele é o Bibliotecário… que claramente não deveria estar aqui.',
    choices: [
      DialogueChoice(text: 'O que aconteceu aqui?', nextNodeId: 'h15_intro_2a'),
      DialogueChoice(text: 'Eu vou embora daqui.', nextNodeId: 'h15_intro_2c'),
    ],
  ),

  // Opção 3 — Eu vou embora
  'h15_intro_2c': DialogueNode(
    id: 'h15_intro_2c',
    characterName: 'Dr. Garibaldo',
    text:
        'Não recomendo. Lá fora está… instável. E perigoso. Você precisa entender o que está acontecendo antes.',
    choices: [
      DialogueChoice(text: 'O que aconteceu aqui?', nextNodeId: 'h15_intro_2a'),
      DialogueChoice(text: 'Quem são vocês?', nextNodeId: 'h15_intro_2b'),
    ],
  ),

  // Opção 1 — Correta: O que aconteceu aqui?
  'h15_intro_2a': DialogueNode(
    id: 'h15_intro_2a',
    characterName: 'Dr. Garibaldo',
    text:
        'Direto ao ponto! Ótimo! Quer dizer… não ótimo, porque a situação não é ótima… mas eficiente. A ilha foi atacada. Por um indivíduo, ou entidade, ainda não descartei essa possibilidade, com capacidades… anômalas. Ele não apenas destruiu coisas… ele… reorganizou tudo. De forma errada.',
    nextNodeId: 'h15_intro_3',
  ),

  'h15_intro_3': DialogueNode(
    id: 'h15_intro_3',
    characterName: 'Dr. Garibaldo',
    text:
        'Você está no H15… meu laboratório… ou pelo menos o que restou dele. A ilha… bem… ela foi estruturalmente comprometida. Não completamente destruída, mas funcionalmente… caótica. Nem sabemos mais há quanto tempo isso aconteceu. O tempo ficou… impreciso depois do evento.',
    nextNodeId: 'h15_intro_4',
  ),

  'h15_intro_4': DialogueNode(
    id: 'h15_intro_4',
    characterName: 'Sr. Niyagi',
    text: 'A sociedade da forma que conhecemos, ruiu…',
    nextNodeId: 'h15_intro_5',
  ),

  'h15_intro_5': DialogueNode(
    id: 'h15_intro_5',
    characterName: 'Dr. Garibaldo',
    text:
        'E tem outra coisa… a comida. Toda a comida. Ela não foi simplesmente levada. Ela foi… drenada. Como se alguém tivesse isolado e extraído a essência energética dos alimentos. Eu ainda estou tentando modelar isso matematicamente, mas… não está fechando.',
    nextNodeId: 'h15_intro_6',
  ),

  'h15_intro_6': DialogueNode(
    id: 'h15_intro_6',
    characterName: 'Dr. Garibaldo',
    text:
        'Ele não causou só a destruição física… ele interferiu na organização do espaço… ou das pessoas… ou de ambos. Indivíduos foram deslocados de seus pontos de origem e redistribuídos de forma aleatória. Ou pior… intencional. Veja ele! O Bibliotecário deveria estar na Biblioteca, mas está aqui. Isso quebra completamente qualquer lógica de sistema!',
    nextNodeId: 'h15_intro_7',
  ),

  'h15_intro_7': DialogueNode(
    id: 'h15_intro_7',
    characterName: 'Sr. Niyagi',
    text:
        'E-eu… eu não consigo lembrar… Eu estava organizando as estantes, como sempre… e então… tudo ficou escuro… vazio… e quando percebi… eu estava aqui…',
    nextNodeId: 'h15_intro_8',
  ),

  'h15_intro_8': DialogueNode(
    id: 'h15_intro_8',
    characterName: 'Dr. Garibaldo',
    text:
        'E… tem os rumores… que eu não gosto de considerar, mas também não posso ignorar… Dizem que ele não está sozinho. Que ele faz parte de uma organização… uma sociedade secreta… os chamados Illuminati dos mares. Ninguém sabe ao certo quem ou o que eles são. Mas uma coisa eu garanto… Ele é… CRUEL. METODICAMENTE CRUEL. E PODEROSO de um jeito que eu não consigo quantificar ainda… o que é… preocupante. Quando ele voltar… eu não sei se estaremos preparados.',
    nextNodeId: 'h15_intro_9',
  ),

  'h15_intro_9': DialogueNode(
    id: 'h15_intro_9',
    characterName: 'Dr. Garibaldo',
    text:
        'Precisamos corrigir isso. Rapidamente. Antes que o sistema entre em colapso total… se já não entrou, o que é possível. Sem o Bibliotecário na Biblioteca, nós perdemos acesso aos registros, aos dados, às referências… e sem dados… eu não consigo pensar direito.',
    choices: [
      DialogueChoice(text: 'Eu posso ajudar.', nextNodeId: 'h15_intro_10a'),
      DialogueChoice(text: 'E quem disse que isso é problema meu?', nextNodeId: 'h15_intro_10b'),
      DialogueChoice(text: 'Por que eu?', nextNodeId: 'h15_intro_10c'),
    ],
  ),

  // Opção 2 — não é problema meu
  'h15_intro_10b': DialogueNode(
    id: 'h15_intro_10b',
    characterName: 'Dr. Garibaldo',
    text:
        'Infelizmente, agora é sim. Você acordou no meio disso tudo. E talvez seja o único capaz de ajudar.',
    choices: [
      DialogueChoice(text: 'Eu posso ajudar.', nextNodeId: 'h15_intro_10a'),
      DialogueChoice(text: 'Por que eu?', nextNodeId: 'h15_intro_10c'),
    ],
  ),

  // Opção 3 — Por que eu?
  'h15_intro_10c': DialogueNode(
    id: 'h15_intro_10c',
    characterName: 'Dr. Garibaldo',
    text:
        '1. Porque você está aqui… o que já é estatisticamente improvável. 2. Porque eu não posso sair do laboratório. 3. Porque ele precisa de ajuda… e 4. porque, no momento, você é o único elemento funcional fora do sistema desorganizado.',
    choices: [
      DialogueChoice(text: 'Eu posso ajudar.', nextNodeId: 'h15_intro_10a'),
    ],
  ),

  // Opção 1 — Correta: Eu posso ajudar
  'h15_intro_10a': DialogueNode(
    id: 'h15_intro_10a',
    characterName: 'Dr. Garibaldo',
    text: 'Excelente! Finalmente alguém racional! Leve-o de volta à Biblioteca.',
    nextNodeId: 'h15_intro_11',
  ),

  'h15_intro_11': DialogueNode(
    id: 'h15_intro_11',
    characterName: 'Sr. Niyagi',
    text: 'E-eu vou com você… acho que é melhor do que ficar aqui…',
    nextNodeId: 'h15_intro_12',
  ),

  'h15_intro_12': DialogueNode(
    id: 'h15_intro_12',
    characterName: 'Dr. Garibaldo',
    text:
        'Leve isto. Um comunicador. Ele deve ser suficiente para te orientar… assumindo que o sistema de localização ainda esteja minimamente funcional… o que eu espero que esteja… eu acho que está.',
    nextNodeId: 'h15_intro_13',
  ),

  'h15_intro_13': DialogueNode(
    id: 'h15_intro_13',
    characterName: 'Dr. Garibaldo',
    text:
        'E… tome cuidado. Ele não apenas destrói… ele observa… aprende… adapta. E eu prefiro não descobrir qual é o próximo passo dele, embora precise.',
    nextNodeId: null,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // BIBLIOTECA / DOJOTECA — Sr. Niyagi
  // Missão ativada: m2_pistas → m3_enfermeira
  // ══════════════════════════════════════════════════════════════════════════

  'biblio_intro_1': DialogueNode(
    id: 'biblio_intro_1',
    characterName: 'Sr. Niyagi',
    text: 'É aqui… finalmente… eu…',
    nextNodeId: 'biblio_intro_2',
  ),

  'biblio_intro_2': DialogueNode(
    id: 'biblio_intro_2',
    characterName: 'Sr. Niyagi',
    text:
        'O caos fora da mente não deve criar caos dentro da mente. O equilíbrio retorna.',
    nextNodeId: 'biblio_intro_3',
  ),

  'biblio_intro_3': DialogueNode(
    id: 'biblio_intro_3',
    characterName: 'Sr. Niyagi',
    text:
        'Lá fora, a desordem ofuscou minha visão. Eu era apenas um pinguim assustado. Mas aqui dentro… eu sou o Sr. Niyagi. Guardião da Dojoteca.',
    nextNodeId: 'biblio_intro_4',
  ),

  'biblio_intro_4': DialogueNode(
    id: 'biblio_intro_4',
    characterName: 'Sr. Niyagi',
    text:
        'Agora… a névoa se dissipa. Lembro-me do momento do ataque. Alguém passou por aqui… uma figura veloz como uma página virada pelo vento. Eu me fundi ao silêncio para não ser visto. Mas não estava sozinho.',
    nextNodeId: 'biblio_intro_5',
  ),

  'biblio_intro_5': DialogueNode(
    id: 'biblio_intro_5',
    characterName: 'Sr. Niyagi',
    text:
        'A Enfermeira Joycelina… ela também estava aqui. O medo a consumiu. Ela fugiu para o fundo das estantes, buscando segurança nas sombras.',
    nextNodeId: 'biblio_intro_6',
  ),

  'biblio_intro_6': DialogueNode(
    id: 'biblio_intro_6',
    characterName: 'Sr. Niyagi',
    text:
        'Ela disse que não se sentia segura na luz… O medo sempre busca o escuro, mas ela tem pavor da escuridão total. Ela deve ter buscado o caminho do meio. Encontre-a, jovem gafanhoto da lógica.',
    choices: [
      DialogueChoice(text: 'Investigar a estante próxima à entrada (bem iluminada)', nextNodeId: 'biblio_busca_errada1'),
      DialogueChoice(text: 'Investigar a estante central (livros espalhados)', nextNodeId: 'biblio_busca_errada2'),
      DialogueChoice(text: 'Investigar o fundo da Dojoteca (região mais escura)', nextNodeId: 'biblio_busca_errada3'),
      DialogueChoice(text: 'Investigar uma área parcialmente iluminada entre as estantes', nextNodeId: 'biblio_encontrou'),
    ],
  ),

  // Buscas erradas
  'biblio_busca_errada1': DialogueNode(
    id: 'biblio_busca_errada1',
    characterName: 'Narrador',
    text:
        'Você examina a estante próxima à entrada. Tudo parece normal… organizado demais para alguém estar escondido ali.',
    nextNodeId: 'biblio_dica1',
  ),
  'biblio_dica1': DialogueNode(
    id: 'biblio_dica1',
    characterName: 'Sr. Niyagi',
    text: 'A presa ferida nunca descansa na entrada da caverna…',
    choices: [
      DialogueChoice(text: 'Investigar a estante central (livros espalhados)', nextNodeId: 'biblio_busca_errada2'),
      DialogueChoice(text: 'Investigar o fundo da Dojoteca (região mais escura)', nextNodeId: 'biblio_busca_errada3'),
      DialogueChoice(text: 'Investigar uma área parcialmente iluminada entre as estantes', nextNodeId: 'biblio_encontrou'),
    ],
  ),

  'biblio_busca_errada2': DialogueNode(
    id: 'biblio_busca_errada2',
    characterName: 'Narrador',
    text:
        'Livros estão espalhados pelo chão, como se alguém tivesse saído às pressas… mas não há ninguém ali.',
    nextNodeId: 'biblio_dica2',
  ),
  'biblio_dica2': DialogueNode(
    id: 'biblio_dica2',
    characterName: 'Sr. Niyagi',
    text: 'A desordem é uma distração. Os olhos enganam, busque com a mente…',
    choices: [
      DialogueChoice(text: 'Investigar a estante próxima à entrada (bem iluminada)', nextNodeId: 'biblio_busca_errada1'),
      DialogueChoice(text: 'Investigar o fundo da Dojoteca (região mais escura)', nextNodeId: 'biblio_busca_errada3'),
      DialogueChoice(text: 'Investigar uma área parcialmente iluminada entre as estantes', nextNodeId: 'biblio_encontrou'),
    ],
  ),

  'biblio_busca_errada3': DialogueNode(
    id: 'biblio_busca_errada3',
    characterName: 'Narrador',
    text:
        'A escuridão domina o fundo da Dojoteca. Você sente um arrepio… mas não há sinais de ninguém.',
    nextNodeId: 'biblio_dica3',
  ),
  'biblio_dica3': DialogueNode(
    id: 'biblio_dica3',
    characterName: 'Sr. Niyagi',
    text: 'O breu total é o inimigo dela. Ela não iria tão fundo nas sombras…',
    choices: [
      DialogueChoice(text: 'Investigar a estante próxima à entrada (bem iluminada)', nextNodeId: 'biblio_busca_errada1'),
      DialogueChoice(text: 'Investigar a estante central (livros espalhados)', nextNodeId: 'biblio_busca_errada2'),
      DialogueChoice(text: 'Investigar uma área parcialmente iluminada entre as estantes', nextNodeId: 'biblio_encontrou'),
    ],
  ),

  // Encontrou a enfermeira
  'biblio_encontrou': DialogueNode(
    id: 'biblio_encontrou',
    characterName: 'Narrador',
    text:
        'Você caminha entre estantes parcialmente iluminadas. Há um leve movimento… quase imperceptível. Tem alguém ali.',
    nextNodeId: 'biblio_joycelina_1',
  ),

  'biblio_joycelina_1': DialogueNode(
    id: 'biblio_joycelina_1',
    characterName: 'Enfermeira Joycelina',
    text:
        'N-não chegue perto! Eu não sei o que você é… ninguém é confiável depois do que aconteceu…',
    choices: [
      DialogueChoice(text: 'Eu vim ajudar.', nextNodeId: 'biblio_joycelina_2a'),
      DialogueChoice(text: 'Você precisa sair daqui.', nextNodeId: 'biblio_joycelina_2b'),
      DialogueChoice(text: 'Vamos logo, não temos tempo pra isso.', nextNodeId: 'biblio_joycelina_2c'),
    ],
  ),

  'biblio_joycelina_2b': DialogueNode(
    id: 'biblio_joycelina_2b',
    characterName: 'Enfermeira Joycelina',
    text: 'Eu sei que preciso… mas eu não consigo sair… não sozinha…',
    choices: [
      DialogueChoice(text: 'Eu vim ajudar.', nextNodeId: 'biblio_joycelina_2a'),
      DialogueChoice(text: 'Vamos logo, não temos tempo pra isso.', nextNodeId: 'biblio_joycelina_2c'),
    ],
  ),

  'biblio_joycelina_2c': DialogueNode(
    id: 'biblio_joycelina_2c',
    characterName: 'Enfermeira Joycelina',
    text: 'Então vá embora! Eu não vou sair daqui!',
    choices: [
      DialogueChoice(text: 'Eu vim ajudar.', nextNodeId: 'biblio_joycelina_2a'),
      DialogueChoice(text: 'Você precisa sair daqui.', nextNodeId: 'biblio_joycelina_2b'),
    ],
  ),

  'biblio_joycelina_2a': DialogueNode(
    id: 'biblio_joycelina_2a',
    characterName: 'Enfermeira Joycelina',
    text:
        'Ajudar…? Você… você trouxe o Sr. Niyagi de volta… então… talvez…',
    nextNodeId: 'biblio_joycelina_3',
  ),

  'biblio_joycelina_3': DialogueNode(
    id: 'biblio_joycelina_3',
    characterName: 'Enfermeira Joycelina',
    text:
        'Eu… eu preciso voltar… para o hospital… eu sei disso… mas… Eu não consigo lembrar como chegar lá… está tudo… embaralhado…',
    nextNodeId: 'biblio_joycelina_4',
  ),

  'biblio_joycelina_4': DialogueNode(
    id: 'biblio_joycelina_4',
    characterName: 'Sr. Niyagi',
    text:
        'A árvore da cura só cresce onde a terra permite. O refúgio dos enfermos fica na região dos jardins, onde a natureza ainda resiste ao caos. Onde a folhagem for mais densa, o caminho se revelará. A jornada até lá não é uma linha reta, assim como a lombada de um livro muito lido. Confie em seus passos.',
    nextNodeId: null,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // HOSPITAL — Enfermeira Joycelina + Truffles
  // Missão ativada: m4_registros → m5_pecas
  // ══════════════════════════════════════════════════════════════════════════

  'hosp_intro_1': DialogueNode(
    id: 'hosp_intro_1',
    characterName: 'Enfermeira Joycelina',
    text:
        'Esse lugar… está pior do que eu imaginava… eu preciso colocar tudo em ordem… mas… Você ouviu isso?',
    nextNodeId: 'hosp_intro_2',
  ),

  'hosp_intro_2': DialogueNode(
    id: 'hosp_intro_2',
    characterName: 'Narrador',
    text:
        'Você encontra uma máquina desmontada… ao lado dela, quatro pequenos "anões" bagunçados discutem entre si, sem conseguir trabalhar juntos.',
    nextNodeId: 'hosp_truffles_1',
  ),

  'hosp_truffles_1': DialogueNode(
    id: 'hosp_truffles_1',
    characterName: 'Truffles',
    text: 'Ótimo… mais alguém pra atrapalhar. Se não for ajudar, já pode ir embora.',
    choices: [
      DialogueChoice(text: 'Talvez eu possa ajudar.', nextNodeId: 'hosp_truffles_2a'),
      DialogueChoice(text: 'O que vocês estão fazendo?', nextNodeId: 'hosp_truffles_2b'),
      DialogueChoice(text: 'Isso parece inútil.', nextNodeId: 'hosp_truffles_2c'),
    ],
  ),

  'hosp_truffles_2b': DialogueNode(
    id: 'hosp_truffles_2b',
    characterName: 'Truffles',
    text: 'Estamos tentando consertar a máquina… o que não está funcionando… claramente.',
    choices: [
      DialogueChoice(text: 'Talvez eu possa ajudar.', nextNodeId: 'hosp_truffles_2a'),
      DialogueChoice(text: 'Isso parece inútil.', nextNodeId: 'hosp_truffles_2c'),
    ],
  ),

  'hosp_truffles_2c': DialogueNode(
    id: 'hosp_truffles_2c',
    characterName: 'Truffles',
    text: 'Então vá ser inútil em outro lugar.',
    choices: [
      DialogueChoice(text: 'Talvez eu possa ajudar.', nextNodeId: 'hosp_truffles_2a'),
      DialogueChoice(text: 'O que vocês estão fazendo?', nextNodeId: 'hosp_truffles_2b'),
    ],
  ),

  'hosp_truffles_2a': DialogueNode(
    id: 'hosp_truffles_2a',
    characterName: 'Truffles',
    text:
        'Ajudar? Hm… improvável. Mas já que insistiu… talvez seja necessário.',
    nextNodeId: 'hosp_truffles_3',
  ),

  'hosp_truffles_3': DialogueNode(
    id: 'hosp_truffles_3',
    characterName: 'Truffles',
    text:
        'Escuta. Essa máquina não é qualquer coisa. É um sistema de reorganização… calibragem fina. Foi feita para ajustar estruturas… físicas… desalinhadas. Como nós. Dificilmente um meio cérebro igual você consegue mexer nisso.',
    nextNodeId: 'hosp_truffles_4',
  ),

  'hosp_truffles_4': DialogueNode(
    id: 'hosp_truffles_4',
    characterName: 'Enfermeira Joycelina',
    text:
        'Se ela voltar a funcionar… talvez possamos ajudar eles… e também tratar os outros pacientes…',
    nextNodeId: 'hosp_truffles_5',
  ),

  'hosp_truffles_5': DialogueNode(
    id: 'hosp_truffles_5',
    characterName: 'Truffles',
    text:
        'Sem essa máquina, nós continuamos assim… desorganizados… inúteis. E sem nós funcionando, ninguém conserta nada nesta ilha. Então sim. Consertar essa máquina é importante.',
    nextNodeId: 'hosp_maquina_1',
  ),

  // Puzzle da máquina
  'hosp_maquina_1': DialogueNode(
    id: 'hosp_maquina_1',
    characterName: 'Narrador',
    text:
        'A máquina apresenta falhas. Peças desalinhadas, cabos soltos e um sistema travado. O que você faz?',
    choices: [
      DialogueChoice(text: 'Reorganizar os componentes', nextNodeId: 'hosp_maquina_2a'),
      DialogueChoice(text: 'Ligar a máquina imediatamente', nextNodeId: 'hosp_maquina_2b'),
      DialogueChoice(text: 'Ignorar o problema', nextNodeId: 'hosp_maquina_2c'),
    ],
  ),

  'hosp_maquina_2b': DialogueNode(
    id: 'hosp_maquina_2b',
    characterName: 'Narrador',
    text: 'Você tenta ligar a máquina… ela emite um ruído forte e desliga.',
    nextNodeId: 'hosp_maquina_2b_truffles',
  ),
  'hosp_maquina_2b_truffles': DialogueNode(
    id: 'hosp_maquina_2b_truffles',
    characterName: 'Truffles',
    text: 'Brilhante. Ligar algo quebrado. Revolucionário.',
    choices: [
      DialogueChoice(text: 'Reorganizar os componentes', nextNodeId: 'hosp_maquina_2a'),
      DialogueChoice(text: 'Ignorar o problema', nextNodeId: 'hosp_maquina_2c'),
    ],
  ),

  'hosp_maquina_2c': DialogueNode(
    id: 'hosp_maquina_2c',
    characterName: 'Enfermeira Joycelina',
    text: 'Sem essa máquina, eu não posso trabalhar… precisamos disso funcionando.',
    choices: [
      DialogueChoice(text: 'Reorganizar os componentes', nextNodeId: 'hosp_maquina_2a'),
      DialogueChoice(text: 'Ligar a máquina imediatamente', nextNodeId: 'hosp_maquina_2b'),
    ],
  ),

  'hosp_maquina_2a': DialogueNode(
    id: 'hosp_maquina_2a',
    characterName: 'Narrador',
    text:
        'Você reorganiza os componentes, conecta cabos e estabiliza o sistema. A máquina volta a funcionar… ainda instável, mas operacional.',
    nextNodeId: 'hosp_recalibra_1',
  ),

  // Recalibrar Truffles
  'hosp_recalibra_1': DialogueNode(
    id: 'hosp_recalibra_1',
    characterName: 'Truffles',
    text: 'Ótimo… a máquina funciona… e nós não. Perfeito. Absolutamente perfeito.',
    nextNodeId: 'hosp_recalibra_2',
  ),

  'hosp_recalibra_2': DialogueNode(
    id: 'hosp_recalibra_2',
    characterName: 'Enfermeira Joycelina',
    text: 'Talvez… possamos usar a máquina para ajudar eles…',
    choices: [
      DialogueChoice(text: 'Ativar recalibração em Truffles', nextNodeId: 'hosp_recalibra_3a'),
      DialogueChoice(text: 'Desligar a máquina', nextNodeId: 'hosp_recalibra_3b'),
      DialogueChoice(text: 'Testar a máquina em si mesmo', nextNodeId: 'hosp_recalibra_3c'),
    ],
  ),

  'hosp_recalibra_3b': DialogueNode(
    id: 'hosp_recalibra_3b',
    characterName: 'Enfermeira Joycelina',
    text: 'Não! Nós acabamos de consertar isso!',
    choices: [
      DialogueChoice(text: 'Ativar recalibração em Truffles', nextNodeId: 'hosp_recalibra_3a'),
      DialogueChoice(text: 'Testar a máquina em si mesmo', nextNodeId: 'hosp_recalibra_3c'),
    ],
  ),

  'hosp_recalibra_3c': DialogueNode(
    id: 'hosp_recalibra_3c',
    characterName: 'Narrador',
    text: 'Você tenta usar a máquina em si mesmo… ela emite um alerta e não ativa.',
    nextNodeId: 'hosp_recalibra_3c_truffles',
  ),
  'hosp_recalibra_3c_truffles': DialogueNode(
    id: 'hosp_recalibra_3c_truffles',
    characterName: 'Truffles',
    text: 'Genial. Quer se desmontar também?',
    choices: [
      DialogueChoice(text: 'Ativar recalibração em Truffles', nextNodeId: 'hosp_recalibra_3a'),
      DialogueChoice(text: 'Desligar a máquina', nextNodeId: 'hosp_recalibra_3b'),
    ],
  ),

  'hosp_recalibra_3a': DialogueNode(
    id: 'hosp_recalibra_3a',
    characterName: 'Narrador',
    text:
        'Você ativa a máquina em Truffles. Uma luz envolve os quatro "anões"… Eles começam a se reorganizar… lentamente… até voltarem ao normal.',
    nextNodeId: 'hosp_recalibra_4',
  ),

  'hosp_recalibra_4': DialogueNode(
    id: 'hosp_recalibra_4',
    characterName: 'Truffles',
    text: 'Funcionou. Isso… realmente funcionou. (pausa) Você não é tão inútil quanto parece.',
    nextNodeId: 'hosp_recalibra_5',
  ),

  'hosp_recalibra_5': DialogueNode(
    id: 'hosp_recalibra_5',
    characterName: 'Enfermeira Joycelina',
    text: 'Agora… eu posso cuidar dos outros… obrigada…',
    nextNodeId: 'hosp_recalibra_6',
  ),

  'hosp_recalibra_6': DialogueNode(
    id: 'hosp_recalibra_6',
    characterName: 'Truffles',
    text: 'Agora vamos, já que você é tão bom me ajude a voltar para a oficina.',
    nextNodeId: null,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // OFICINA — Truffles
  // Missão ativada: m6_truffles → m7_investigacao
  // ══════════════════════════════════════════════════════════════════════════

  'oficina_intro_1': DialogueNode(
    id: 'oficina_intro_1',
    characterName: 'Truffles',
    text: 'Finalmente… minha oficina… Ou o que restou dela.',
    choices: [
      DialogueChoice(text: 'O que aconteceu aqui?', nextNodeId: 'oficina_intro_2a'),
      DialogueChoice(text: 'Isso tudo parece inútil.', nextNodeId: 'oficina_intro_2b'),
      DialogueChoice(text: 'Dá pra usar esse lugar ainda?', nextNodeId: 'oficina_intro_2c'),
    ],
  ),

  'oficina_intro_2b': DialogueNode(
    id: 'oficina_intro_2b',
    characterName: 'Truffles',
    text: 'Inútil? Isso aqui mantém a ilha funcionando.',
    choices: [
      DialogueChoice(text: 'O que aconteceu aqui?', nextNodeId: 'oficina_intro_2a'),
      DialogueChoice(text: 'Dá pra usar esse lugar ainda?', nextNodeId: 'oficina_intro_2c'),
    ],
  ),

  'oficina_intro_2c': DialogueNode(
    id: 'oficina_intro_2c',
    characterName: 'Truffles',
    text: 'Funciona… mas não como deveria.',
    choices: [
      DialogueChoice(text: 'O que aconteceu aqui?', nextNodeId: 'oficina_intro_2a'),
      DialogueChoice(text: 'Isso tudo parece inútil.', nextNodeId: 'oficina_intro_2b'),
    ],
  ),

  'oficina_intro_2a': DialogueNode(
    id: 'oficina_intro_2a',
    characterName: 'Truffles',
    text:
        'Não foi destruição comum… foi desorganização. Como se cada peça tivesse sido colocada no lugar errado de propósito.',
    nextNodeId: 'oficina_observar_1',
  ),

  'oficina_observar_1': DialogueNode(
    id: 'oficina_observar_1',
    characterName: 'Narrador',
    text: 'Truffles caminha pela oficina, analisando o ambiente. Você decide observar melhor…',
    choices: [
      DialogueChoice(text: 'Observar as ferramentas desalinhadas', nextNodeId: 'oficina_observar_2b'),
      DialogueChoice(text: 'Analisar marcas no chão próximas à saída', nextNodeId: 'oficina_observar_2a'),
      DialogueChoice(text: 'Ignorar e ir embora', nextNodeId: 'oficina_observar_2c'),
    ],
  ),

  'oficina_observar_2b': DialogueNode(
    id: 'oficina_observar_2b',
    characterName: 'Narrador',
    text: 'As ferramentas estão fora do lugar… mas seguem o mesmo padrão já visto.',
    nextNodeId: 'oficina_observar_2b_truffles',
  ),
  'oficina_observar_2b_truffles': DialogueNode(
    id: 'oficina_observar_2b_truffles',
    characterName: 'Truffles',
    text: 'Você está olhando… mas ainda não está enxergando.',
    choices: [
      DialogueChoice(text: 'Analisar marcas no chão próximas à saída', nextNodeId: 'oficina_observar_2a'),
      DialogueChoice(text: 'Ignorar e ir embora', nextNodeId: 'oficina_observar_2c'),
    ],
  ),

  'oficina_observar_2c': DialogueNode(
    id: 'oficina_observar_2c',
    characterName: 'Truffles',
    text: 'Se você ignorar os detalhes… vai perder o que importa.',
    choices: [
      DialogueChoice(text: 'Observar as ferramentas desalinhadas', nextNodeId: 'oficina_observar_2b'),
      DialogueChoice(text: 'Analisar marcas no chão próximas à saída', nextNodeId: 'oficina_observar_2a'),
    ],
  ),

  'oficina_observar_2a': DialogueNode(
    id: 'oficina_observar_2a',
    characterName: 'Narrador',
    text:
        'Você observa marcas no chão… como se algo pesado tivesse sido arrastado para fora da oficina.',
    nextNodeId: 'oficina_concluir_1',
  ),

  'oficina_concluir_1': DialogueNode(
    id: 'oficina_concluir_1',
    characterName: 'Truffles',
    text: 'Isso não veio daqui… essas marcas continuam…',
    choices: [
      DialogueChoice(text: 'Talvez tenha sido descartado.', nextNodeId: 'oficina_concluir_2b'),
      DialogueChoice(text: 'Alguém está acumulando recursos em outro lugar.', nextNodeId: 'oficina_concluir_2a'),
      DialogueChoice(text: 'Não tem como saber.', nextNodeId: 'oficina_concluir_2c'),
    ],
  ),

  'oficina_concluir_2b': DialogueNode(
    id: 'oficina_concluir_2b',
    characterName: 'Truffles',
    text: 'Isso não é descarte… é reaproveitamento.',
    choices: [
      DialogueChoice(text: 'Alguém está acumulando recursos em outro lugar.', nextNodeId: 'oficina_concluir_2a'),
      DialogueChoice(text: 'Não tem como saber.', nextNodeId: 'oficina_concluir_2c'),
    ],
  ),

  'oficina_concluir_2c': DialogueNode(
    id: 'oficina_concluir_2c',
    characterName: 'Truffles',
    text: 'Sempre tem como saber. É só observar melhor.',
    choices: [
      DialogueChoice(text: 'Talvez tenha sido descartado.', nextNodeId: 'oficina_concluir_2b'),
      DialogueChoice(text: 'Alguém está acumulando recursos em outro lugar.', nextNodeId: 'oficina_concluir_2a'),
    ],
  ),

  'oficina_concluir_2a': DialogueNode(
    id: 'oficina_concluir_2a',
    characterName: 'Truffles',
    text:
        'Exatamente… Alguém não está destruindo recursos… está concentrando.',
    nextNodeId: 'oficina_concluir_3',
  ),

  'oficina_concluir_3': DialogueNode(
    id: 'oficina_concluir_3',
    characterName: 'Truffles',
    text:
        'Antes de você chegar… eu vi algo estranho. O Mercadão da Ilha… tinha comida demais. E isso não faz sentido nenhum.',
    nextNodeId: null,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // MERCADÃO — Chef Frigelino + Buffles + Dr. Garibaldo + Beta
  // Missão ativada: m7_investigacao → batalha final
  // ══════════════════════════════════════════════════════════════════════════

  'mercadao_intro_1': DialogueNode(
    id: 'mercadao_intro_1',
    characterName: 'Narrador',
    text:
        'O Mercadão da Ilha está estranho. Mesas desalinhadas, cadeiras caídas… mas diferente dos outros lugares, há sinais recentes de uso. Um cheiro leve de comida paira no ar… algo que não deveria existir.',
    nextNodeId: 'mercadao_intro_2',
  ),

  'mercadao_intro_2': DialogueNode(
    id: 'mercadao_intro_2',
    characterName: 'Chef Frigelino',
    text:
        'Ah… você chegou… curioso… muito curioso… Depois de tudo… alguém ainda sente fome? E então… está com fome?',
    choices: [
      DialogueChoice(text: 'Sim, preciso de energia.', nextNodeId: 'mercadao_comeu'),
      DialogueChoice(text: 'De onde veio essa comida?', nextNodeId: 'mercadao_perguntou'),
      DialogueChoice(text: 'Vou investigar o ambiente primeiro.', nextNodeId: 'mercadao_investigar'),
    ],
  ),

  'mercadao_comeu': DialogueNode(
    id: 'mercadao_comeu',
    characterName: 'Narrador',
    text:
        'Você aceita a comida… mas algo parece estranho. O sabor não corresponde ao cheiro.',
    nextNodeId: 'mercadao_comeu_chef',
  ),
  'mercadao_comeu_chef': DialogueNode(
    id: 'mercadao_comeu_chef',
    characterName: 'Chef Frigelino',
    text: 'Coma… você vai precisar…',
    choices: [
      DialogueChoice(text: 'De onde veio essa comida?', nextNodeId: 'mercadao_perguntou'),
      DialogueChoice(text: 'Vou investigar o ambiente primeiro.', nextNodeId: 'mercadao_investigar'),
    ],
  ),

  'mercadao_perguntou': DialogueNode(
    id: 'mercadao_perguntou',
    characterName: 'Chef Frigelino',
    text: 'Eu… improvisei com o que restou… uns restos que achei por aí…',
    nextNodeId: 'mercadao_perguntou_narrador',
  ),
  'mercadao_perguntou_narrador': DialogueNode(
    id: 'mercadao_perguntou_narrador',
    characterName: 'Narrador',
    text: 'A resposta parece vaga, talvez ensaiada.',
    choices: [
      DialogueChoice(text: 'Vou investigar o ambiente primeiro.', nextNodeId: 'mercadao_investigar'),
    ],
  ),

  'mercadao_investigar': DialogueNode(
    id: 'mercadao_investigar',
    characterName: 'Narrador',
    text:
        'Você decide não confiar imediatamente… algo não está certo aqui. Ao fundo, escondido entre estruturas metálicas… um freezer chama sua atenção.',
    choices: [
      DialogueChoice(text: 'Abrir o freezer', nextNodeId: 'mercadao_freezer_abriu'),
      DialogueChoice(text: 'Ignorar', nextNodeId: 'mercadao_freezer_ignorou'),
    ],
  ),

  'mercadao_freezer_ignorou': DialogueNode(
    id: 'mercadao_freezer_ignorou',
    characterName: 'Narrador',
    text: 'Você decide não mexer… mas a sensação de que algo está errado permanece.',
    choices: [
      DialogueChoice(text: 'Abrir o freezer', nextNodeId: 'mercadao_freezer_abriu'),
    ],
  ),

  'mercadao_freezer_abriu': DialogueNode(
    id: 'mercadao_freezer_abriu',
    characterName: 'Narrador',
    text:
        'Você abre o freezer lentamente… Dentro, há uma quantidade absurda de peixes… muito mais do que deveria existir. Entre os peixes congelados… há cabos conectados ao fundo do freezer. Eles vibram levemente… como se estivessem transportando algo. Os cabos seguem por uma tubulação metálica… saindo do Mercadão da Ilha. Um pequeno ser congelado se move.',
    nextNodeId: 'mercadao_buffles_1',
  ),

  'mercadao_buffles_1': DialogueNode(
    id: 'mercadao_buffles_1',
    characterName: 'Buffles Cozinheiro',
    text: 'brrr… brrr…',
    nextNodeId: 'mercadao_apos_freezer',
  ),

  'mercadao_apos_freezer': DialogueNode(
    id: 'mercadao_apos_freezer',
    characterName: 'Chef Frigelino',
    text: 'Você viu demais… (pausa) Mas talvez… já estivesse destinado a isso.',
    nextNodeId: 'mercadao_buffles_chama',
  ),

  'mercadao_buffles_chama': DialogueNode(
    id: 'mercadao_buffles_chama',
    characterName: 'Narrador',
    text: 'Buffles se aproxima do jogador lentamente. O pequeno ser parece tentar chamar sua atenção…',
    choices: [
      DialogueChoice(text: 'Seguir Buffles', nextNodeId: 'mercadao_painel_1'),
      DialogueChoice(text: 'Confrontar o Chef', nextNodeId: 'mercadao_confrontar'),
      DialogueChoice(text: 'Ignorar e sair', nextNodeId: 'mercadao_nao_sair'),
    ],
  ),

  'mercadao_confrontar': DialogueNode(
    id: 'mercadao_confrontar',
    characterName: 'Chef Frigelino',
    text: 'Você ainda não entende o suficiente para perguntar.',
    choices: [
      DialogueChoice(text: 'Seguir Buffles', nextNodeId: 'mercadao_painel_1'),
      DialogueChoice(text: 'Ignorar e sair', nextNodeId: 'mercadao_nao_sair'),
    ],
  ),

  'mercadao_nao_sair': DialogueNode(
    id: 'mercadao_nao_sair',
    characterName: 'Narrador',
    text:
        'Você tenta sair… mas a sensação de que algo importante está prestes a ser revelado impede você.',
    choices: [
      DialogueChoice(text: 'Seguir Buffles', nextNodeId: 'mercadao_painel_1'),
      DialogueChoice(text: 'Confrontar o Chef', nextNodeId: 'mercadao_confrontar'),
    ],
  ),

  'mercadao_painel_1': DialogueNode(
    id: 'mercadao_painel_1',
    characterName: 'Narrador',
    text:
        'Você segue Buffles até uma área escondida do Mercadão da Ilha. Há um painel aberto, conectado diretamente ao freezer… pelo lado de fora.',
    choices: [
      DialogueChoice(text: 'Desconectar os cabos do painel', nextNodeId: 'mercadao_painel_errado'),
      DialogueChoice(text: 'Analisar o sistema', nextNodeId: 'mercadao_painel_certo'),
      DialogueChoice(text: 'Ignorar', nextNodeId: 'mercadao_painel_ignorar'),
    ],
  ),

  'mercadao_painel_errado': DialogueNode(
    id: 'mercadao_painel_errado',
    characterName: 'Narrador',
    text: 'O sistema emite um ruído instável.',
    nextNodeId: 'mercadao_painel_errado_chef',
  ),
  'mercadao_painel_errado_chef': DialogueNode(
    id: 'mercadao_painel_errado_chef',
    characterName: 'Chef Frigelino',
    text: 'Se fizer isso sem entender… pode perder a única chance de compreender.',
    choices: [
      DialogueChoice(text: 'Analisar o sistema', nextNodeId: 'mercadao_painel_certo'),
      DialogueChoice(text: 'Ignorar', nextNodeId: 'mercadao_painel_ignorar'),
    ],
  ),

  'mercadao_painel_ignorar': DialogueNode(
    id: 'mercadao_painel_ignorar',
    characterName: 'Narrador',
    text: 'Você ignora o painel… mas claramente ele é parte do problema.',
    choices: [
      DialogueChoice(text: 'Desconectar os cabos do painel', nextNodeId: 'mercadao_painel_errado'),
      DialogueChoice(text: 'Analisar o sistema', nextNodeId: 'mercadao_painel_certo'),
    ],
  ),

  'mercadao_painel_certo': DialogueNode(
    id: 'mercadao_painel_certo',
    characterName: 'Narrador',
    text:
        'Você analisa o sistema… Os dados indicam transferência de energia dos alimentos… E um destino… …. H15.',
    nextNodeId: 'mercadao_revelacao_1',
  ),

  'mercadao_revelacao_1': DialogueNode(
    id: 'mercadao_revelacao_1',
    characterName: 'Chef Frigelino',
    text: '…então você percebeu. Tudo está sendo enviado para o laboratório.',
    choices: [
      DialogueChoice(text: 'O Cientista está envolvido?', nextNodeId: 'mercadao_revelacao_2a'),
      DialogueChoice(text: 'Isso não faz sentido.', nextNodeId: 'mercadao_revelacao_2b'),
      DialogueChoice(text: 'Você fez isso?', nextNodeId: 'mercadao_revelacao_2c'),
    ],
  ),

  'mercadao_revelacao_2b': DialogueNode(
    id: 'mercadao_revelacao_2b',
    characterName: 'Chef Frigelino',
    text: 'Faz… você só ainda não conectou tudo.',
    choices: [
      DialogueChoice(text: 'O Cientista está envolvido?', nextNodeId: 'mercadao_revelacao_2a'),
      DialogueChoice(text: 'Você fez isso?', nextNodeId: 'mercadao_revelacao_2c'),
    ],
  ),

  'mercadao_revelacao_2c': DialogueNode(
    id: 'mercadao_revelacao_2c',
    characterName: 'Chef Frigelino',
    text: 'Eu apenas executo uma parte.',
    choices: [
      DialogueChoice(text: 'O Cientista está envolvido?', nextNodeId: 'mercadao_revelacao_2a'),
      DialogueChoice(text: 'Isso não faz sentido.', nextNodeId: 'mercadao_revelacao_2b'),
    ],
  ),

  'mercadao_revelacao_2a': DialogueNode(
    id: 'mercadao_revelacao_2a',
    characterName: 'Chef Frigelino',
    text:
        'Envolvido… é uma forma simples de dizer. Ele entende o sistema melhor do que qualquer um.',
    nextNodeId: 'mercadao_garibaldo_chega',
  ),

  // Dr. Garibaldo chega
  'mercadao_garibaldo_chega': DialogueNode(
    id: 'mercadao_garibaldo_chega',
    characterName: 'Dr. Garibaldo',
    text: 'Pelo seu olhar… está começando a entender…',
    choices: [
      DialogueChoice(text: 'O que é toda essa energia?', nextNodeId: 'mercadao_garibaldo_2b'),
      DialogueChoice(text: 'Você sabia disso?', nextNodeId: 'mercadao_garibaldo_2a'),
      DialogueChoice(text: 'Isso precisa parar.', nextNodeId: 'mercadao_garibaldo_2c'),
    ],
  ),

  'mercadao_garibaldo_2b': DialogueNode(
    id: 'mercadao_garibaldo_2b',
    characterName: 'Dr. Garibaldo',
    text: 'Isso faz parte do sistema.',
    choices: [
      DialogueChoice(text: 'Você sabia disso?', nextNodeId: 'mercadao_garibaldo_2a'),
      DialogueChoice(text: 'Isso precisa parar.', nextNodeId: 'mercadao_garibaldo_2c'),
    ],
  ),

  'mercadao_garibaldo_2c': DialogueNode(
    id: 'mercadao_garibaldo_2c',
    characterName: 'Dr. Garibaldo',
    text: 'Parar… sem entender… seria um erro.',
    choices: [
      DialogueChoice(text: 'Você sabia disso?', nextNodeId: 'mercadao_garibaldo_2a'),
    ],
  ),

  'mercadao_garibaldo_2a': DialogueNode(
    id: 'mercadao_garibaldo_2a',
    characterName: 'Dr. Garibaldo',
    text: 'se eu… se eu sabia? (pausa) Eu projetei.',
    nextNodeId: 'mercadao_garibaldo_3',
  ),

  'mercadao_garibaldo_3': DialogueNode(
    id: 'mercadao_garibaldo_3',
    characterName: 'Dr. Garibaldo',
    text:
        'A ilha estava colapsando… antes mesmo do ataque. Os recursos estavam se esgotando. O sistema… falhando. Então eu criei uma solução. Reorganizar. Redistribuir. Concentrar energia.',
    choices: [
      DialogueChoice(text: 'Isso está destruindo tudo.', nextNodeId: 'mercadao_garibaldo_4a'),
      DialogueChoice(text: 'Você fez a escolha certa.', nextNodeId: 'mercadao_garibaldo_4b'),
      DialogueChoice(text: 'E toda aquela história de entidade? Illuminati dos mares?', nextNodeId: 'mercadao_garibaldo_4c'),
    ],
  ),

  'mercadao_garibaldo_4b': DialogueNode(
    id: 'mercadao_garibaldo_4b',
    characterName: 'Dr. Garibaldo',
    text: 'Não existe escolha certa… apenas necessária.',
    choices: [
      DialogueChoice(text: 'Isso está destruindo tudo.', nextNodeId: 'mercadao_garibaldo_4a'),
      DialogueChoice(text: 'E toda aquela história de entidade? Illuminati dos mares?', nextNodeId: 'mercadao_garibaldo_4c'),
    ],
  ),

  'mercadao_garibaldo_4c': DialogueNode(
    id: 'mercadao_garibaldo_4c',
    characterName: 'Dr. Garibaldo',
    text:
        'Eu… eu precisava que você acreditasse que havia um inimigo externo. Alguém para combater. A verdade é mais sombria: não houve um vilão misterioso. Fui eu quem criei o sistema. Os Illuminati dos mares… eram apenas uma metáfora para o caos que eu mesmo desencadeei. A manipulação foi necessária… ou assim eu justifiquei para mim mesmo.',
    choices: [
      DialogueChoice(text: 'Isso está destruindo tudo.', nextNodeId: 'mercadao_garibaldo_4a'),
    ],
  ),

  'mercadao_garibaldo_4a': DialogueNode(
    id: 'mercadao_garibaldo_4a',
    characterName: 'Dr. Garibaldo',
    text: 'Destruir… para reconstruir. Essa sempre foi a lógica.',
    nextNodeId: 'mercadao_beta_surge',
  ),

  // Beta surge
  'mercadao_beta_surge': DialogueNode(
    id: 'mercadao_beta_surge',
    characterName: 'Narrador',
    text:
        'De repente, o chão do Mercadão da Ilha treme violentamente. A parede de metal atrás do freezer é rasgada como se fosse papel. Uma figura imponente, envolta em sombras e energia instável, entra no recinto. Seus olhos brilham com uma lógica fria e calculista.',
    nextNodeId: 'mercadao_beta_1',
  ),

  'mercadao_beta_1': DialogueNode(
    id: 'mercadao_beta_1',
    characterName: 'Beta',
    text: 'Os dados foram coletados. Os padrões foram confirmados. A execução pode começar.',
    nextNodeId: 'mercadao_beta_2',
  ),

  'mercadao_beta_2': DialogueNode(
    id: 'mercadao_beta_2',
    characterName: 'Dr. Garibaldo',
    text: 'Beta… espere… isso não estava nos parâmetros finais…',
    nextNodeId: 'mercadao_beta_3',
  ),

  'mercadao_beta_3': DialogueNode(
    id: 'mercadao_beta_3',
    characterName: 'Beta',
    text: 'Você definiu o problema. Eu apenas encontrei a solução ótima.',
    nextNodeId: 'mercadao_beta_4',
  ),

  'mercadao_beta_4': DialogueNode(
    id: 'mercadao_beta_4',
    characterName: 'Dr. Garibaldo',
    text: 'Você está extrapolando o modelo! Isso não é reorganização… isso é colapso!',
    nextNodeId: 'mercadao_beta_5',
  ),

  'mercadao_beta_5': DialogueNode(
    id: 'mercadao_beta_5',
    characterName: 'Beta',
    text: 'Correção: é convergência.',
    nextNodeId: 'mercadao_beta_6',
  ),

  'mercadao_beta_6': DialogueNode(
    id: 'mercadao_beta_6',
    characterName: 'Narrador',
    text:
        'Beta levanta a mão. Uma distorção no espaço lança o Cientista contra a parede. Ele cai, consciente… mas incapaz de agir.',
    nextNodeId: 'mercadao_beta_7',
  ),

  'mercadao_beta_7': DialogueNode(
    id: 'mercadao_beta_7',
    characterName: 'Beta',
    text:
        'Recursos dispersos geram instabilidade. Recursos concentrados geram controle. O sistema será otimizado.',
    nextNodeId: 'mercadao_beta_8',
  ),

  'mercadao_beta_8': DialogueNode(
    id: 'mercadao_beta_8',
    characterName: 'Beta',
    text:
        'Variável não prevista detectada. (pausa) Você. Você interferiu na coleta. Interferiu na distribuição. Interferiu no equilíbrio do sistema. (pausa) Agora… você será testado.',
    nextNodeId: 'mercadao_batalha_inicio',
  ),

  'mercadao_batalha_inicio': DialogueNode(
    id: 'mercadao_batalha_inicio',
    characterName: 'Dr. Garibaldo',
    text:
        'Você… precisa entender… (pausa) Ele não é o vilão… ele é o resultado… (pausa maior) Mas isso… não significa que ele esteja certo…',
    nextNodeId: null,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // H15 FINAL — Encerramento do sistema
  // ══════════════════════════════════════════════════════════════════════════

  'h15_final_1': DialogueNode(
    id: 'h15_final_1',
    characterName: 'Dr. Garibaldo',
    text: 'Você venceu o Beta… Mas não venceu o sistema.',
    choices: [
      DialogueChoice(text: 'Isso ainda não acabou.', nextNodeId: 'h15_final_2a'),
      DialogueChoice(text: 'Eu já fiz o suficiente.', nextNodeId: 'h15_final_2b'),
      DialogueChoice(text: 'Desligue isso agora.', nextNodeId: 'h15_final_2c'),
    ],
  ),

  'h15_final_2b': DialogueNode(
    id: 'h15_final_2b',
    characterName: 'Dr. Garibaldo',
    text: 'Então tudo isso terá sido em vão.',
    choices: [
      DialogueChoice(text: 'Isso ainda não acabou.', nextNodeId: 'h15_final_2a'),
    ],
  ),

  'h15_final_2c': DialogueNode(
    id: 'h15_final_2c',
    characterName: 'Dr. Garibaldo',
    text: 'Se fosse simples assim… eu já teria feito.',
    choices: [
      DialogueChoice(text: 'Isso ainda não acabou.', nextNodeId: 'h15_final_2a'),
    ],
  ),

  'h15_final_2a': DialogueNode(
    id: 'h15_final_2a',
    characterName: 'Dr. Garibaldo',
    text:
        'Se quiser parar tudo… vai precisar quebrar a lógica que mantém isso funcionando.',
    nextNodeId: 'h15_final_3',
  ),

  'h15_final_3': DialogueNode(
    id: 'h15_final_3',
    characterName: 'Narrador',
    text:
        'O sistema reage à sua presença. As máquinas começam a se ajustar… como se estivessem tentando se defender. Você precisa desestabilizar os fluxos de energia.',
    choices: [
      DialogueChoice(text: 'Reorganizar fluxos de energia', nextNodeId: 'h15_final_4a'),
      DialogueChoice(text: 'Sobrecarregar o sistema', nextNodeId: 'h15_final_4b'),
      DialogueChoice(text: 'Ignorar os alertas', nextNodeId: 'h15_final_4c'),
    ],
  ),

  'h15_final_4b': DialogueNode(
    id: 'h15_final_4b',
    characterName: 'Dr. Garibaldo',
    text: 'Força bruta não resolve lógica.',
    nextNodeId: 'h15_final_4b_narrador',
  ),
  'h15_final_4b_narrador': DialogueNode(
    id: 'h15_final_4b_narrador',
    characterName: 'Narrador',
    text: 'As máquinas reagem violentamente e bloqueiam sua ação.',
    choices: [
      DialogueChoice(text: 'Reorganizar fluxos de energia', nextNodeId: 'h15_final_4a'),
      DialogueChoice(text: 'Ignorar os alertas', nextNodeId: 'h15_final_4c'),
    ],
  ),

  'h15_final_4c': DialogueNode(
    id: 'h15_final_4c',
    characterName: 'Dr. Garibaldo',
    text: 'Ignorar o problema não o resolve.',
    nextNodeId: 'h15_final_4c_narrador',
  ),
  'h15_final_4c_narrador': DialogueNode(
    id: 'h15_final_4c_narrador',
    characterName: 'Narrador',
    text: 'O sistema continua operando.',
    choices: [
      DialogueChoice(text: 'Reorganizar fluxos de energia', nextNodeId: 'h15_final_4a'),
      DialogueChoice(text: 'Sobrecarregar o sistema', nextNodeId: 'h15_final_4b'),
    ],
  ),

  'h15_final_4a': DialogueNode(
    id: 'h15_final_4a',
    characterName: 'Narrador',
    text:
        'Você reorganiza os fluxos de energia… Os circuitos se estabilizam parcialmente.',
    nextNodeId: 'h15_final_5',
  ),

  'h15_final_5': DialogueNode(
    id: 'h15_final_5',
    characterName: 'Narrador',
    text:
        'O sistema foi interrompido… Os cabos pararam de pulsar… A energia deixa de fluir do Mercadão da Ilha para o laboratório. O silêncio… finalmente… retorna.',
    nextNodeId: 'h15_final_6',
  ),

  'h15_final_6': DialogueNode(
    id: 'h15_final_6',
    characterName: 'Dr. Garibaldo',
    text:
        'Então… você fez… Você quebrou a lógica… Eu criei o modelo… Eu criei o sistema… Mas fui longe demais tentando prever tudo… Beta era a execução perfeita dessa lógica… Sem erro… sem dúvida… sem humanidade…',
    nextNodeId: 'h15_final_7',
  ),

  'h15_final_7': DialogueNode(
    id: 'h15_final_7',
    characterName: 'Dr. Garibaldo',
    text:
        'E você… Você foi a variável que eu não consegui calcular.',
    nextNodeId: 'h15_final_8',
  ),

  'h15_final_8': DialogueNode(
    id: 'h15_final_8',
    characterName: 'Dr. Garibaldo',
    text:
        'Os logs de tempo… Não foi uma semana… A distorção causada pelo sistema… e pelo Beta… Alterou tudo… Você esteve dormindo por mais de oitenta anos.',
    nextNodeId: 'h15_final_9',
  ),

  'h15_final_9': DialogueNode(
    id: 'h15_final_9',
    characterName: 'Narrador',
    text: 'O mundo que você conhecia… já não existe mais.',
    choices: [
      DialogueChoice(text: 'O que eu faço agora?', nextNodeId: 'h15_final_fim'),
      DialogueChoice(text: 'Pelo menos os outros estão a salvo.', nextNodeId: 'h15_final_fim'),
      DialogueChoice(text: 'Eu preciso ver com meus próprios olhos.', nextNodeId: 'h15_final_fim'),
    ],
  ),

  'h15_final_fim': DialogueNode(
    id: 'h15_final_fim',
    characterName: 'Narrador',
    text:
        'Você percebe que seu trabalho aqui acabou. A ilha agora pertence a eles. É hora de descobrir o que restou do mundo lá fora. O caos que antes dominava a ilha… agora dá lugar a algo diferente… Você caminha em direção aos limites da ilha, onde o vento gelado sopra forte. Não há como voltar ao passado, mas há um mundo inteiro a ser explorado. No fim, descobriu-se que não havia vilão misterioso. O verdadeiro inimigo era a lógica sem coração que o próprio cientista desencadeou. E, de algum jeito, a esperança venceu. FIM.',
    nextNodeId: null,
  ),
};
