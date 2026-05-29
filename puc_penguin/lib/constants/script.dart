import '../models/dialogue.dart';

// Mapa central de todos os diálogos do jogo.
// Chave: ID do nó | Valor: DialogueNode
// Substituição de {nome} é feita pelo DialogueNotifier em tempo de execução.
final Map<String, DialogueNode> gameScript = {

  // ══════════════════════════════════════════════════════════════════════════
  // H15 — CAPÍTULO I: O DESPERTAR
  // Missão disparada ao fechar nó: h15_mission_end
  // ══════════════════════════════════════════════════════════════════════════

  'h15_intro_0': DialogueNode(
    id: 'h15_intro_0',
    characterName: 'Narrador',
    text: 'Você abre os olhos aos poucos. A última coisa que lembra é uma explosão. Depois, o vazio. Agora, uma luz fraca pisca acima de você. Alguém fala ao longe…',
    nextNodeId: 'h15_intro_1',
  ),

  'h15_intro_1': DialogueNode(
    id: 'h15_intro_1',
    characterName: 'Dr. Garibaldo',
    text: '{nome}, acorde! Acorde!',
    nextNodeId: 'h15_intro_title',
  ),

  'h15_intro_title': DialogueNode(
    id: 'h15_intro_title',
    characterName: 'Narrador',
    text: 'Capítulo I: O Despertar',
    nextNodeId: 'h15_intro_2',
  ),

  'h15_intro_2': DialogueNode(
    id: 'h15_intro_2',
    characterName: 'Dr. Garibaldo',
    text: 'Você acordou! Excelente! Quer dizer… dentro de uma margem aceitável… talvez nem tanto… eu já estava considerando uma falha no protocolo, o que seria ruim. Muito ruim. Deve ter sido algum erro no coeficiente neural… ou no criogênico… depois eu vejo isso. Isso não importa agora! Como você está se sentindo?',
    nextNodeId: 'h15_intro_lib',
  ),

  'h15_intro_lib': DialogueNode(
    id: 'h15_intro_lib',
    characterName: 'Bibliotecário',
    text: 'E-ele está mesmo bem? Isso parece… errado…',
    choices: [
      DialogueChoice(text: '"O que aconteceu aqui?"', nextNodeId: 'h15_expl_1'),
      DialogueChoice(text: '"Quem são vocês?"',       nextNodeId: 'h15_block_a'),
      DialogueChoice(text: '"Eu vou embora daqui."',  nextNodeId: 'h15_block_b'),
    ],
  ),

  'h15_block_a': DialogueNode(
    id: 'h15_block_a',
    characterName: 'Dr. Garibaldo',
    text: 'Ah! Sim, apresentações! Eu sou o Dr. Garibaldo Pingulino, cientista-chefe deste laboratório! E ele é o Bibliotecário… que claramente não deveria estar aqui.',
    choices: [
      DialogueChoice(text: '"O que aconteceu aqui?"', nextNodeId: 'h15_expl_1'),
      DialogueChoice(text: '"Eu vou embora daqui."',  nextNodeId: 'h15_block_b'),
    ],
  ),

  'h15_block_b': DialogueNode(
    id: 'h15_block_b',
    characterName: 'Dr. Garibaldo',
    text: 'Não recomendo. Lá fora está… instável. E perigoso. Você precisa entender o que está acontecendo antes.',
    choices: [
      DialogueChoice(text: '"O que aconteceu aqui?"', nextNodeId: 'h15_expl_1'),
      DialogueChoice(text: '"Quem são vocês?"',       nextNodeId: 'h15_block_a'),
    ],
  ),

  'h15_expl_1': DialogueNode(
    id: 'h15_expl_1',
    characterName: 'Dr. Garibaldo',
    text: 'Direto ao ponto! Ótimo! Quer dizer… não ótimo, porque a situação não é ótima… mas eficiente. A ilha foi atacada. Por um indivíduo, ou entidade – ainda não descartei essa possibilidade – com capacidades… anômalas. Ele não apenas destruiu coisas… ele… reorganizou tudo. De forma errada.',
    nextNodeId: 'h15_expl_2',
  ),

  'h15_expl_2': DialogueNode(
    id: 'h15_expl_2',
    characterName: 'Dr. Garibaldo',
    text: 'Você está no H15… meu laboratório… ou pelo menos o que restou dele. A ilha… bem… ela foi estruturalmente comprometida. Não completamente destruída, mas funcionalmente… caótica. Nem sabemos mais há quanto tempo isso aconteceu. O tempo ficou… impreciso depois do evento.',
    nextNodeId: 'h15_expl_3',
  ),

  'h15_expl_3': DialogueNode(
    id: 'h15_expl_3',
    characterName: 'Bibliotecário',
    text: 'A sociedade da forma que conhecemos, ruiu…',
    nextNodeId: 'h15_expl_4',
  ),

  'h15_expl_4': DialogueNode(
    id: 'h15_expl_4',
    characterName: 'Dr. Garibaldo',
    text: 'E tem outra coisa… a comida. Toda a comida. Ela não foi simplesmente levada. Ela foi… drenada. Como se alguém tivesse isolado e extraído a essência energética dos alimentos. Eu ainda estou tentando modelar isso matematicamente, mas… não está fechando.',
    nextNodeId: 'h15_expl_5',
  ),

  'h15_expl_5': DialogueNode(
    id: 'h15_expl_5',
    characterName: 'Dr. Garibaldo',
    text: 'Ele não causou só a destruição física… ele interferiu na organização do espaço… ou das pessoas… ou de ambos. Indivíduos foram deslocados de seus pontos de origem e redistribuídos de forma aleatória. Ou pior… intencional. Veja ele! O Bibliotecário deveria estar na Biblioteca, mas está aqui. Isso quebra completamente qualquer lógica de sistema! E quando a lógica quebra… coisas ruins acontecem. Muito ruins.',
    nextNodeId: 'h15_expl_6',
  ),

  'h15_expl_6': DialogueNode(
    id: 'h15_expl_6',
    characterName: 'Bibliotecário',
    text: 'E-eu… eu não consigo lembrar… Eu estava organizando as estantes, como sempre… e então… tudo ficou escuro… vazio… e quando percebi… eu estava aqui…',
    nextNodeId: 'h15_expl_7',
  ),

  'h15_expl_7': DialogueNode(
    id: 'h15_expl_7',
    characterName: 'Dr. Garibaldo',
    text: 'E… tem os rumores… que eu não gosto de considerar, mas também não posso ignorar… o que é cientificamente frustrante. Dizem que ele não está sozinho. Que ele faz parte de uma organização… uma sociedade secreta… os chamados Illuminati dos mares. Ninguém sabe ao certo quem ou o que eles são. Mas uma coisa eu garanto… (pausa) Ele é… cruel. Metodicamente cruel. E poderoso de um jeito que eu não consigo quantificar ainda… o que é… preocupante.',
    nextNodeId: 'h15_expl_8',
  ),

  'h15_expl_8': DialogueNode(
    id: 'h15_expl_8',
    characterName: 'Narrador',
    text: 'QUANDO ELE VOLTAR… EU NÃO SEI SE ESTAREMOS PREPARADOS.',
    nextNodeId: 'h15_expl_9',
  ),

  'h15_expl_9': DialogueNode(
    id: 'h15_expl_9',
    characterName: 'Dr. Garibaldo',
    text: 'Precisamos corrigir isso. Rapidamente. Antes que o sistema entre em colapso total… se já não entrou, o que é possível. Sem o Bibliotecário na Biblioteca, nós perdemos acesso aos registros, aos dados, às referências… e sem dados… eu não consigo pensar direito.',
    choices: [
      DialogueChoice(text: '"Eu posso ajudar."',                    nextNodeId: 'h15_mission_1'),
      DialogueChoice(text: '"E quem disse que isso é problema meu."', nextNodeId: 'h15_block_c'),
      DialogueChoice(text: '"Por que eu?"',                         nextNodeId: 'h15_block_d'),
    ],
  ),

  'h15_block_c': DialogueNode(
    id: 'h15_block_c',
    characterName: 'Dr. Garibaldo',
    text: 'Infelizmente, agora é sim. Você acordou no meio disso tudo. E talvez seja o único capaz de ajudar.',
    choices: [
      DialogueChoice(text: '"Eu posso ajudar."', nextNodeId: 'h15_mission_1'),
      DialogueChoice(text: '"Por que eu?"',      nextNodeId: 'h15_block_d'),
    ],
  ),

  'h15_block_d': DialogueNode(
    id: 'h15_block_d',
    characterName: 'Dr. Garibaldo',
    text: '1. Porque você está aqui… o que já é estatisticamente improvável. 2. Porque eu não posso sair do laboratório. 3. Porque ele precisa de ajuda… e 4. porque, no momento, você é o único elemento funcional fora do sistema desorganizado.',
    choices: [
      DialogueChoice(text: '"Eu posso ajudar."', nextNodeId: 'h15_mission_1'),
    ],
  ),

  'h15_mission_1': DialogueNode(
    id: 'h15_mission_1',
    characterName: 'Dr. Garibaldo',
    text: 'Excelente! Finalmente alguém racional! Leve-o de volta à Biblioteca.',
    nextNodeId: 'h15_mission_2',
  ),

  'h15_mission_2': DialogueNode(
    id: 'h15_mission_2',
    characterName: 'Bibliotecário',
    text: 'E-eu vou com você… acho que é melhor do que ficar aqui…',
    nextNodeId: 'h15_mission_3',
  ),

  'h15_mission_3': DialogueNode(
    id: 'h15_mission_3',
    characterName: 'Dr. Garibaldo',
    text: 'Leve isto. Um comunicador. Ele deve ser suficiente para te orientar… assumindo que o sistema de localização ainda esteja minimamente funcional… o que eu espero que esteja… eu acho que está.',
    nextNodeId: 'h15_mission_4',
  ),

  'h15_mission_4': DialogueNode(
    id: 'h15_mission_4',
    characterName: 'Dr. Garibaldo',
    text: 'E… tome cuidado. Ele não apenas destrói… ele observa… aprende… adapta. E eu prefiro não descobrir qual é o próximo passo dele, embora precise.',
    nextNodeId: 'h15_mission_end',
  ),

  // Nó final do arco H15 — dispara onComplete (missão 1)
  'h15_mission_end': DialogueNode(
    id: 'h15_mission_end',
    characterName: 'Narrador',
    text: 'Missão 1: Leve o bibliotecário de volta para a biblioteca.',
    nextNodeId: null,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // BIBLIOTECA / DOJOTECA — CAPÍTULO II: O Retorno ao Conhecimento
  // Missão disparada ao fechar nó: biblio_joycelina_4
  // ══════════════════════════════════════════════════════════════════════════

  'biblio_intro_1': DialogueNode(
    id: 'biblio_intro_1',
    characterName: 'Narrador',
    text: 'O cheiro de papel antigo ainda está presente… O silêncio não é de abandono, é de concentração.',
    nextNodeId: 'biblio_intro_2',
  ),

  'biblio_intro_2': DialogueNode(
    id: 'biblio_intro_2',
    characterName: 'Bibliotecário',
    text: 'É aqui… finalmente… eu…',
    nextNodeId: 'biblio_intro_3',
  ),

  'biblio_intro_3': DialogueNode(
    id: 'biblio_intro_3',
    characterName: 'Narrador',
    text: 'Ao entrar no raio da Biblioteca, a postura do Bibliotecário muda instantaneamente. Ele para de tremer, respira fundo, ajeita os óculos e tira uma fita vermelha de marca-página do bolso, amarrando-a na cabeça como uma faixa de karatê.',
    nextNodeId: 'biblio_intro_4',
  ),

  'biblio_intro_4': DialogueNode(
    id: 'biblio_intro_4',
    characterName: 'Narrador',
    text: 'O Bibliotecário recuperou suas memórias e sua verdadeira identidade.',
    nextNodeId: 'biblio_niyagi_1',
  ),

  'biblio_niyagi_1': DialogueNode(
    id: 'biblio_niyagi_1',
    characterName: 'Sr. Niyagi',
    text: 'O caos fora da mente não deve criar caos dentro da mente. O equilíbrio retorna. Lá fora, a desordem ofuscou minha visão. Eu era apenas um pinguim assustado. Mas aqui dentro… eu sou o Sr. Niyagi. Guardião da Dojoteca.',
    nextNodeId: 'biblio_niyagi_2',
  ),

  'biblio_niyagi_2': DialogueNode(
    id: 'biblio_niyagi_2',
    characterName: 'Sr. Niyagi',
    text: 'Agora… a névoa se dissipa. Lembro-me do momento do ataque. Alguém passou por aqui… uma figura veloz como uma página virada pelo vento. Eu me fundi ao silêncio para não ser visto. Mas não estava sozinho. A Enfermeira Joycelina… ela também estava aqui. O medo a consumiu. Ela fugiu para o fundo das estantes, buscando segurança nas sombras.',
    nextNodeId: 'biblio_missao2',
  ),

  'biblio_missao2': DialogueNode(
    id: 'biblio_missao2',
    characterName: 'Narrador',
    text: 'Missão 2: Encontrar a Enfermeira escondida na Dojoteca.',
    nextNodeId: 'biblio_env_desc',
  ),

  'biblio_env_desc': DialogueNode(
    id: 'biblio_env_desc',
    characterName: 'Narrador',
    text: 'A Dojoteca está silenciosa demais. As estantes se estendem em fileiras desorganizadas. Algumas áreas estão mais escuras que outras… talvez alguém esteja se escondendo.',
    nextNodeId: 'biblio_intro_6',
  ),

  'biblio_intro_6': DialogueNode(
    id: 'biblio_intro_6',
    characterName: 'Sr. Niyagi',
    text: 'Ela disse que não se sentia segura na luz… O medo sempre busca o escuro, mas ela tem pavor da escuridão total. Ela deve ter buscado o caminho do meio. Encontre-a, jovem gafanhoto da lógica.',
    choices: [
      DialogueChoice(text: 'Investigar a entrada bem iluminada',               nextNodeId: 'biblio_busca_errada1'),
      DialogueChoice(text: 'Investigar a estante central com livros espalhados', nextNodeId: 'biblio_busca_errada2'),
      DialogueChoice(text: 'Investigar o fundo escuro da Dojoteca',            nextNodeId: 'biblio_busca_errada3'),
      DialogueChoice(text: 'Investigar a área parcialmente iluminada entre as estantes', nextNodeId: 'biblio_encontrou'),
    ],
  ),

  'biblio_busca_errada1': DialogueNode(
    id: 'biblio_busca_errada1',
    characterName: 'Narrador',
    text: 'Você examina a estante próxima à entrada. Tudo parece normal… organizado demais para alguém estar escondido ali.',
    nextNodeId: 'biblio_dica1',
  ),
  'biblio_dica1': DialogueNode(
    id: 'biblio_dica1',
    characterName: 'Sr. Niyagi',
    text: 'A presa ferida nunca descansa na entrada da caverna…',
    choices: [
      DialogueChoice(text: 'Investigar a estante central com livros espalhados', nextNodeId: 'biblio_busca_errada2'),
      DialogueChoice(text: 'Investigar o fundo escuro da Dojoteca',             nextNodeId: 'biblio_busca_errada3'),
      DialogueChoice(text: 'Investigar a área parcialmente iluminada entre as estantes', nextNodeId: 'biblio_encontrou'),
    ],
  ),

  'biblio_busca_errada2': DialogueNode(
    id: 'biblio_busca_errada2',
    characterName: 'Narrador',
    text: 'Livros estão espalhados pelo chão, como se alguém tivesse saído às pressas… mas não há ninguém ali.',
    nextNodeId: 'biblio_dica2',
  ),
  'biblio_dica2': DialogueNode(
    id: 'biblio_dica2',
    characterName: 'Sr. Niyagi',
    text: 'A desordem é uma distração. Os olhos enganam, busque com a mente…',
    choices: [
      DialogueChoice(text: 'Investigar a entrada bem iluminada',               nextNodeId: 'biblio_busca_errada1'),
      DialogueChoice(text: 'Investigar o fundo escuro da Dojoteca',            nextNodeId: 'biblio_busca_errada3'),
      DialogueChoice(text: 'Investigar a área parcialmente iluminada entre as estantes', nextNodeId: 'biblio_encontrou'),
    ],
  ),

  'biblio_busca_errada3': DialogueNode(
    id: 'biblio_busca_errada3',
    characterName: 'Narrador',
    text: 'A escuridão domina o fundo da Dojoteca. Você sente um arrepio… mas não há sinais de ninguém.',
    nextNodeId: 'biblio_dica3',
  ),
  'biblio_dica3': DialogueNode(
    id: 'biblio_dica3',
    characterName: 'Sr. Niyagi',
    text: 'O breu total é o inimigo dela. Ela não iria tão fundo nas sombras…',
    choices: [
      DialogueChoice(text: 'Investigar a entrada bem iluminada',               nextNodeId: 'biblio_busca_errada1'),
      DialogueChoice(text: 'Investigar a estante central com livros espalhados', nextNodeId: 'biblio_busca_errada2'),
      DialogueChoice(text: 'Investigar a área parcialmente iluminada entre as estantes', nextNodeId: 'biblio_encontrou'),
    ],
  ),

  'biblio_encontrou': DialogueNode(
    id: 'biblio_encontrou',
    characterName: 'Narrador',
    text: 'Você caminha entre estantes parcialmente iluminadas. Há um leve movimento… quase imperceptível. Tem alguém ali.',
    nextNodeId: 'biblio_joycelina_1',
  ),

  'biblio_joycelina_1': DialogueNode(
    id: 'biblio_joycelina_1',
    characterName: 'Enfermeira Joycelina',
    text: 'N-não chegue perto! Eu não sei o que você é… ninguém é confiável depois do que aconteceu…',
    choices: [
      DialogueChoice(text: 'Eu vim ajudar.',                       nextNodeId: 'biblio_joycelina_2a'),
      DialogueChoice(text: 'Você precisa sair daqui.',             nextNodeId: 'biblio_joycelina_2b'),
      DialogueChoice(text: 'Vamos logo, não temos tempo pra isso.', nextNodeId: 'biblio_joycelina_2c'),
    ],
  ),

  'biblio_joycelina_2b': DialogueNode(
    id: 'biblio_joycelina_2b',
    characterName: 'Enfermeira Joycelina',
    text: 'Eu sei que preciso… mas eu não consigo sair… não sozinha…',
    choices: [
      DialogueChoice(text: 'Eu vim ajudar.',                       nextNodeId: 'biblio_joycelina_2a'),
      DialogueChoice(text: 'Vamos logo, não temos tempo pra isso.', nextNodeId: 'biblio_joycelina_2c'),
    ],
  ),

  'biblio_joycelina_2c': DialogueNode(
    id: 'biblio_joycelina_2c',
    characterName: 'Enfermeira Joycelina',
    text: 'Então vá embora! Eu não vou sair daqui!',
    choices: [
      DialogueChoice(text: 'Eu vim ajudar.',           nextNodeId: 'biblio_joycelina_2a'),
      DialogueChoice(text: 'Você precisa sair daqui.', nextNodeId: 'biblio_joycelina_2b'),
    ],
  ),

  'biblio_joycelina_2a': DialogueNode(
    id: 'biblio_joycelina_2a',
    characterName: 'Enfermeira Joycelina',
    text: 'Ajudar…? Você… você trouxe o Sr. Niyagi de volta… então… talvez…',
    nextNodeId: 'biblio_joycelina_3',
  ),

  'biblio_joycelina_3': DialogueNode(
    id: 'biblio_joycelina_3',
    characterName: 'Enfermeira Joycelina',
    text: 'Eu… eu preciso voltar… para o hospital… eu sei disso… mas… Eu não consigo lembrar como chegar lá… está tudo… embaralhado…',
    nextNodeId: 'biblio_joycelina_4',
  ),

  // Nó final do arco Biblioteca — dispara onComplete (missão 2 → missão 3)
  'biblio_joycelina_4': DialogueNode(
    id: 'biblio_joycelina_4',
    characterName: 'Sr. Niyagi',
    text: 'A árvore da cura só cresce onde a terra permite. O refúgio dos enfermos fica na região dos jardins, onde a natureza ainda resiste ao caos. Onde a folhagem for mais densa, o caminho se revelará. A jornada até lá não é uma linha reta, assim como a lombada de um livro muito lido. Confie em seus passos.',
    nextNodeId: null,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // HOSPITAL — CAPÍTULO III: O Caminho da Memória
  // Missão disparada ao fechar nó: hosp_recalibra_6
  // ══════════════════════════════════════════════════════════════════════════

  'hosp_intro_1': DialogueNode(
    id: 'hosp_intro_1',
    characterName: 'Narrador',
    text: 'O ambiente está desorganizado. Macas fora do lugar, equipamentos desligados… e um estranho barulho metálico ecoa pelo local.',
    nextNodeId: 'hosp_intro_2',
  ),

  'hosp_intro_2': DialogueNode(
    id: 'hosp_intro_2',
    characterName: 'Enfermeira Joycelina',
    text: 'Esse lugar… está pior do que eu imaginava… eu preciso colocar tudo em ordem… mas… (pausa) Você ouviu isso?',
    nextNodeId: 'hosp_intro_3',
  ),

  'hosp_intro_3': DialogueNode(
    id: 'hosp_intro_3',
    characterName: 'Narrador',
    text: 'Você encontra uma máquina desmontada… ao lado dela, quatro pequenos "anões" bagunçados discutem entre si, sem conseguir trabalhar juntos.',
    nextNodeId: 'hosp_truffles_1',
  ),

  'hosp_truffles_1': DialogueNode(
    id: 'hosp_truffles_1',
    characterName: 'Truffles',
    text: 'Ótimo… mais alguém pra atrapalhar. Se não for ajudar, já pode ir embora.',
    choices: [
      DialogueChoice(text: 'Talvez eu possa ajudar.', nextNodeId: 'hosp_truffles_2a'),
      DialogueChoice(text: 'O que vocês estão fazendo?', nextNodeId: 'hosp_truffles_2b'),
      DialogueChoice(text: 'Isso parece inútil.',      nextNodeId: 'hosp_truffles_2c'),
    ],
  ),

  'hosp_truffles_2b': DialogueNode(
    id: 'hosp_truffles_2b',
    characterName: 'Truffles',
    text: 'Estamos tentando consertar a máquina… o que não está funcionando… claramente.',
    choices: [
      DialogueChoice(text: 'Talvez eu possa ajudar.', nextNodeId: 'hosp_truffles_2a'),
      DialogueChoice(text: 'Isso parece inútil.',     nextNodeId: 'hosp_truffles_2c'),
    ],
  ),

  'hosp_truffles_2c': DialogueNode(
    id: 'hosp_truffles_2c',
    characterName: 'Truffles',
    text: 'Então vá ser inútil em outro lugar.',
    choices: [
      DialogueChoice(text: 'Talvez eu possa ajudar.',  nextNodeId: 'hosp_truffles_2a'),
      DialogueChoice(text: 'O que vocês estão fazendo?', nextNodeId: 'hosp_truffles_2b'),
    ],
  ),

  'hosp_truffles_2a': DialogueNode(
    id: 'hosp_truffles_2a',
    characterName: 'Truffles',
    text: 'Ajudar? Hm… improvável. Mas já que insistiu… talvez seja necessário.',
    nextNodeId: 'hosp_truffles_3',
  ),

  'hosp_truffles_3': DialogueNode(
    id: 'hosp_truffles_3',
    characterName: 'Truffles',
    text: 'Escuta. Essa máquina não é qualquer coisa. É um sistema de reorganização… calibragem fina. Foi feita para ajustar estruturas… físicas… desalinhadas. Como nós. Dificilmente um meio cérebro igual você consegue mexer nisso.',
    nextNodeId: 'hosp_truffles_4',
  ),

  'hosp_truffles_4': DialogueNode(
    id: 'hosp_truffles_4',
    characterName: 'Enfermeira Joycelina',
    text: 'Se ela voltar a funcionar… talvez possamos ajudar eles… e também tratar os outros pacientes…',
    nextNodeId: 'hosp_truffles_5',
  ),

  'hosp_truffles_5': DialogueNode(
    id: 'hosp_truffles_5',
    characterName: 'Truffles',
    text: 'Sem essa máquina, nós continuamos assim… desorganizados… inúteis. E sem nós funcionando, ninguém conserta nada nesta ilha. Então sim. Consertar essa máquina é importante.',
    nextNodeId: 'hosp_missao4',
  ),

  'hosp_missao4': DialogueNode(
    id: 'hosp_missao4',
    characterName: 'Narrador',
    text: 'Missão 4: conserte a máquina e ajude Truffles.',
    nextNodeId: 'hosp_maquina_1',
  ),

  'hosp_maquina_1': DialogueNode(
    id: 'hosp_maquina_1',
    characterName: 'Narrador',
    text: 'A máquina apresenta falhas graves. Peças desalinhadas, cabos soltos e um sistema lógico travado. O que você faz?',
    choices: [
      DialogueChoice(text: 'Reorganizar os componentes',    nextNodeId: 'hosp_maquina_2a'),
      DialogueChoice(text: 'Ligar a máquina imediatamente', nextNodeId: 'hosp_maquina_2b'),
      DialogueChoice(text: 'Ignorar o problema',           nextNodeId: 'hosp_maquina_2c'),
    ],
  ),

  'hosp_maquina_2b': DialogueNode(
    id: 'hosp_maquina_2b',
    characterName: 'Narrador',
    text: 'Você tenta forçar a inicialização da máquina… ela emite um ruído forte de curto-circuito e desliga.',
    nextNodeId: 'hosp_maquina_2b_truffles',
  ),
  'hosp_maquina_2b_truffles': DialogueNode(
    id: 'hosp_maquina_2b_truffles',
    characterName: 'Truffles',
    text: 'Brilhante. Ligar algo quebrado. Revolucionário.',
    choices: [
      DialogueChoice(text: 'Reorganizar os componentes', nextNodeId: 'hosp_maquina_2a'),
      DialogueChoice(text: 'Ignorar o problema',         nextNodeId: 'hosp_maquina_2c'),
    ],
  ),

  'hosp_maquina_2c': DialogueNode(
    id: 'hosp_maquina_2c',
    characterName: 'Enfermeira Joycelina',
    text: 'Sem essa máquina, eu não posso trabalhar… precisamos disso funcionando de qualquer jeito.',
    choices: [
      DialogueChoice(text: 'Reorganizar os componentes',    nextNodeId: 'hosp_maquina_2a'),
      DialogueChoice(text: 'Ligar a máquina imediatamente', nextNodeId: 'hosp_maquina_2b'),
    ],
  ),

  'hosp_maquina_2a': DialogueNode(
    id: 'hosp_maquina_2a',
    characterName: 'Narrador',
    text: 'Você reorganiza os componentes, conecta os cabos rompidos e estabiliza o sistema. A máquina volta a funcionar… ainda instável, mas operacional.',
    nextNodeId: 'hosp_recalibra_1',
  ),

  'hosp_recalibra_1': DialogueNode(
    id: 'hosp_recalibra_1',
    characterName: 'Truffles',
    text: 'Ótimo… a máquina funciona… e nós não. Perfeito. Absolutamente perfeito.',
    nextNodeId: 'hosp_recalibra_2',
  ),

  'hosp_recalibra_2': DialogueNode(
    id: 'hosp_recalibra_2',
    characterName: 'Enfermeira Joycelina',
    text: 'Talvez… possamos usar a máquina para ajudar eles diretamente…',
    nextNodeId: 'hosp_missao5',
  ),

  'hosp_missao5': DialogueNode(
    id: 'hosp_missao5',
    characterName: 'Narrador',
    text: 'Missão 5: recalibre Truffles.',
    nextNodeId: 'hosp_recalibra_escolha',
  ),

  'hosp_recalibra_escolha': DialogueNode(
    id: 'hosp_recalibra_escolha',
    characterName: 'Narrador',
    text: 'O que você faz com a máquina agora?',
    choices: [
      DialogueChoice(text: 'Ativar recalibração em Truffles', nextNodeId: 'hosp_recalibra_3a'),
      DialogueChoice(text: 'Desligar a máquina',             nextNodeId: 'hosp_recalibra_3b'),
      DialogueChoice(text: 'Testar a máquina em si mesmo',   nextNodeId: 'hosp_recalibra_3c'),
    ],
  ),

  'hosp_recalibra_3b': DialogueNode(
    id: 'hosp_recalibra_3b',
    characterName: 'Enfermeira Joycelina',
    text: 'Não! Nós acabamos de consertar isso com tanto esforço!',
    choices: [
      DialogueChoice(text: 'Ativar recalibração em Truffles', nextNodeId: 'hosp_recalibra_3a'),
      DialogueChoice(text: 'Testar a máquina em si mesmo',   nextNodeId: 'hosp_recalibra_3c'),
    ],
  ),

  'hosp_recalibra_3c': DialogueNode(
    id: 'hosp_recalibra_3c',
    characterName: 'Narrador',
    text: 'Você tenta virar os sensores para si mesmo… o terminal emite um alerta de erro de espécie e não ativa.',
    nextNodeId: 'hosp_recalibra_3c_truffles',
  ),
  'hosp_recalibra_3c_truffles': DialogueNode(
    id: 'hosp_recalibra_3c_truffles',
    characterName: 'Truffles',
    text: 'Genial. Quer se desmontar por completo também?',
    choices: [
      DialogueChoice(text: 'Ativar recalibração em Truffles', nextNodeId: 'hosp_recalibra_3a'),
      DialogueChoice(text: 'Desligar a máquina',             nextNodeId: 'hosp_recalibra_3b'),
    ],
  ),

  'hosp_recalibra_3a': DialogueNode(
    id: 'hosp_recalibra_3a',
    characterName: 'Narrador',
    text: 'Você ativa a máquina apontada para Truffles. Uma luz envolve os quatro "anões"… Eles começam a girar e a se reorganizar… lentamente… até voltarem ao normal, unidos em um só.',
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
    text: 'Agora… eu posso cuidar dos outros pacientes de forma correta… obrigada…',
    nextNodeId: 'hosp_recalibra_6',
  ),

  // Nó final do arco Hospital — dispara onComplete (missão 5 → missão 6)
  'hosp_recalibra_6': DialogueNode(
    id: 'hosp_recalibra_6',
    characterName: 'Truffles',
    text: 'Agora vamos, já que você é tão bom de lógica, me ajude a voltar para o meu setor de trabalho na oficina.',
    nextNodeId: null,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // OFICINA — CAPÍTULO IV: De Volta ao Trabalho
  // Missão disparada ao fechar nó: oficina_concluir_3
  // ══════════════════════════════════════════════════════════════════════════

  'oficina_intro_1': DialogueNode(
    id: 'oficina_intro_1',
    characterName: 'Narrador',
    text: 'Você entra em um ambiente repleto de ferramentas espalhadas, peças metálicas desalinhadas e estruturas inacabadas. O som de metal batendo ecoa pelo espaço. Apesar do caos aparente… há um padrão cirúrgico. Como se tudo tivesse sido colocado de cabeça para baixo de propósito.',
    nextNodeId: 'oficina_truffles_chega',
  ),

  'oficina_truffles_chega': DialogueNode(
    id: 'oficina_truffles_chega',
    characterName: 'Truffles',
    text: 'Finalmente… minha oficina… Ou o que restou dela.',
    choices: [
      DialogueChoice(text: 'O que aconteceu aqui?',      nextNodeId: 'oficina_intro_2a'),
      DialogueChoice(text: 'Isso tudo parece inútil.',   nextNodeId: 'oficina_intro_2b'),
      DialogueChoice(text: 'Dá pra usar esse lugar ainda?', nextNodeId: 'oficina_intro_2c'),
    ],
  ),

  'oficina_intro_2b': DialogueNode(
    id: 'oficina_intro_2b',
    characterName: 'Truffles',
    text: 'Inútil? Isso aqui mantém os suprimentos mecânicos de toda a ilha funcionando.',
    choices: [
      DialogueChoice(text: 'O que aconteceu aqui?',        nextNodeId: 'oficina_intro_2a'),
      DialogueChoice(text: 'Dá pra usar esse lugar ainda?', nextNodeId: 'oficina_intro_2c'),
    ],
  ),

  'oficina_intro_2c': DialogueNode(
    id: 'oficina_intro_2c',
    characterName: 'Truffles',
    text: 'Funciona… mas não na potência que deveria.',
    choices: [
      DialogueChoice(text: 'O que aconteceu aqui?',    nextNodeId: 'oficina_intro_2a'),
      DialogueChoice(text: 'Isso tudo parece inútil.', nextNodeId: 'oficina_intro_2b'),
    ],
  ),

  'oficina_intro_2a': DialogueNode(
    id: 'oficina_intro_2a',
    characterName: 'Truffles',
    text: 'Não foi destruição comum… foi desorganização proposital. Como se cada peça tivesse sido colocada no lugar errado de propósito para atrasar a produção.',
    nextNodeId: 'oficina_observar_1',
  ),

  'oficina_observar_1': DialogueNode(
    id: 'oficina_observar_1',
    characterName: 'Narrador',
    text: 'Truffles caminha pela oficina, analisando a desconfiguração do ambiente. Você decide observar as pistas com mais atenção…',
    choices: [
      DialogueChoice(text: 'Observar as ferramentas desalinhadas',        nextNodeId: 'oficina_observar_2b'),
      DialogueChoice(text: 'Analisar marcas no chão próximas à saída',   nextNodeId: 'oficina_observar_2a'),
      DialogueChoice(text: 'Ignorar e ir embora',                        nextNodeId: 'oficina_observar_2c'),
    ],
  ),

  'oficina_observar_2b': DialogueNode(
    id: 'oficina_observar_2b',
    characterName: 'Narrador',
    text: 'As ferramentas estão fora dos suportes… mas seguem uma ordem matemática estrita.',
    nextNodeId: 'oficina_observar_2b_truffles',
  ),
  'oficina_observar_2b_truffles': DialogueNode(
    id: 'oficina_observar_2b_truffles',
    characterName: 'Truffles',
    text: 'Você está apenas olhando com os olhos, mas ainda não está enxergando com a lógica.',
    choices: [
      DialogueChoice(text: 'Analisar marcas no chão próximas à saída', nextNodeId: 'oficina_observar_2a'),
      DialogueChoice(text: 'Ignorar e ir embora',                      nextNodeId: 'oficina_observar_2c'),
    ],
  ),

  'oficina_observar_2c': DialogueNode(
    id: 'oficina_observar_2c',
    characterName: 'Truffles',
    text: 'Se você ignorar os pequenos detalhes do mapa, vai perder o que realmente importa.',
    choices: [
      DialogueChoice(text: 'Observar as ferramentas desalinhadas',     nextNodeId: 'oficina_observar_2b'),
      DialogueChoice(text: 'Analisar marcas no chão próximas à saída', nextNodeId: 'oficina_observar_2a'),
    ],
  ),

  'oficina_observar_2a': DialogueNode(
    id: 'oficina_observar_2a',
    characterName: 'Narrador',
    text: 'Você abaixa e observa marcas profundas de arrasto no chão… como se caixas e containers muito pesados tivessem sido puxados para fora da oficina recentemente.',
    nextNodeId: 'oficina_concluir_1',
  ),

  'oficina_concluir_1': DialogueNode(
    id: 'oficina_concluir_1',
    characterName: 'Truffles',
    text: 'Isso não veio de dentro da minha cota… essas marcas continuam pelo pátio…',
    choices: [
      DialogueChoice(text: 'Talvez o material tenha sido descartado por lixo.', nextNodeId: 'oficina_concluir_2b'),
      DialogueChoice(text: 'Alguém está acumulando recursos em outro lugar escondido.', nextNodeId: 'oficina_concluir_2a'),
      DialogueChoice(text: 'Não tem como saber sem olhar o banco de dados.', nextNodeId: 'oficina_concluir_2c'),
    ],
  ),

  'oficina_concluir_2b': DialogueNode(
    id: 'oficina_concluir_2b',
    characterName: 'Truffles',
    text: 'Isso não é descarte de refugo… é reaproveitamento logístico.',
    choices: [
      DialogueChoice(text: 'Alguém está acumulando recursos em outro lugar escondido.', nextNodeId: 'oficina_concluir_2a'),
      DialogueChoice(text: 'Não tem como saber sem olhar o banco de dados.', nextNodeId: 'oficina_concluir_2c'),
    ],
  ),

  'oficina_concluir_2c': DialogueNode(
    id: 'oficina_concluir_2c',
    characterName: 'Truffles',
    text: 'Sempre tem como saber se você parar e ler os sinais do cenário.',
    choices: [
      DialogueChoice(text: 'Talvez o material tenha sido descartado por lixo.', nextNodeId: 'oficina_concluir_2b'),
      DialogueChoice(text: 'Alguém está acumulando recursos em outro lugar escondido.', nextNodeId: 'oficina_concluir_2a'),
    ],
  ),

  'oficina_concluir_2a': DialogueNode(
    id: 'oficina_concluir_2a',
    characterName: 'Truffles',
    text: 'Exatamente… Alguém não está destruindo recursos para causar o caos… está concentrando tudo em um único ponto focal. Antes de você me resgatar… eu vi algo fora do padrão: O Mercadão da Ilha… tinha comida e energia estocada demais. E isso não faz sentido nenhum em um cenário de escassez.',
    nextNodeId: 'oficina_concluir_3',
  ),

  // Nó final do arco Oficina — dispara onComplete (missão 6 → missão 7 + unlock Mercadão)
  'oficina_concluir_3': DialogueNode(
    id: 'oficina_concluir_3',
    characterName: 'Narrador',
    text: 'Novo ambiente desbloqueado no mapa de GPS: Mercadão da Ilha.',
    nextNodeId: null,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // MERCADÃO — CAPÍTULO V: O Sumiço da Comida / CAPÍTULO VI: Lógica
  // Missão disparada ao fechar nó: mercadao_batalha_inicio
  // ══════════════════════════════════════════════════════════════════════════

  'mercadao_intro_1': DialogueNode(
    id: 'mercadao_intro_1',
    characterName: 'Narrador',
    text: 'O Mercadão da Ilha apresenta um comportamento estranho. Mesas desalinhadas, cadeiras caídas… mas diferente dos outros prédios devastados, há sinais claros de uso recente. Um cheiro característico de comida quente paira no ar… algo que teoricamente não deveria existir. No centro do refeitório, uma figura paramentada se movimenta de forma calma e suspeita entre panelas e utensílios industriais…',
    nextNodeId: 'mercadao_intro_2',
  ),

  'mercadao_intro_2': DialogueNode(
    id: 'mercadao_intro_2',
    characterName: 'Chef Frigelino',
    text: 'Ah… você chegou… curioso… muito curioso… Depois de tudo o que desmoronou lá fora… alguém ainda sente fome? E então… está com fome de verdade?',
    choices: [
      DialogueChoice(text: 'Sim, preciso de energia para continuar as missões.', nextNodeId: 'mercadao_comeu'),
      DialogueChoice(text: 'De onde veio essa comida se a ilha está desabastecida?', nextNodeId: 'mercadao_perguntou'),
      DialogueChoice(text: 'Vou investigar o ambiente primeiro antes de consumir qualquer coisa.', nextNodeId: 'mercadao_investigar'),
    ],
  ),

  'mercadao_comeu': DialogueNode(
    id: 'mercadao_comeu',
    characterName: 'Narrador',
    text: 'Você aceita a porção oferecida… mas o gosto na boca parece estranho. O sabor não corresponde em nada ao cheiro convidativo do ar.',
    nextNodeId: 'mercadao_comeu_chef',
  ),
  'mercadao_comeu_chef': DialogueNode(
    id: 'mercadao_comeu_chef',
    characterName: 'Chef Frigelino',
    text: 'Coma tudo… você vai precisar de cada caloria para o que vem a seguir…',
    nextNodeId: 'mercadao_comeu_penalidade',
  ),
  'mercadao_comeu_penalidade': DialogueNode(
    id: 'mercadao_comeu_penalidade',
    characterName: 'Narrador',
    text: 'Penalidade aplicada: -2 na soma final dos dados de combate.',
    choices: [
      DialogueChoice(text: 'De onde veio essa comida?',                        nextNodeId: 'mercadao_perguntou'),
      DialogueChoice(text: 'Vou investigar o ambiente antes de qualquer coisa.', nextNodeId: 'mercadao_investigar'),
    ],
  ),

  'mercadao_perguntou': DialogueNode(
    id: 'mercadao_perguntou',
    characterName: 'Chef Frigelino',
    text: 'Eu… apenas improvisei com o que sobrou nos estoques baixos… uns restos que achei jogados por aí…',
    nextNodeId: 'mercadao_perguntou_narrador',
  ),
  'mercadao_perguntou_narrador': DialogueNode(
    id: 'mercadao_perguntou_narrador',
    characterName: 'Narrador',
    text: 'A resposta dele soa artificial e extremamente ensaiada.',
    choices: [
      DialogueChoice(text: 'Vou investigar o ambiente primeiro.', nextNodeId: 'mercadao_investigar'),
    ],
  ),

  'mercadao_investigar': DialogueNode(
    id: 'mercadao_investigar',
    characterName: 'Narrador',
    text: 'Você decide não confiar na cortesia imediata… algo está profundamente errado ali. Você varre o salão com os olhos com mais atenção… Ao fundo da cozinha, camuflado entre grandes estruturas metálicas de sustentação… um freezer industrial trancado chama sua atenção.',
    choices: [
      DialogueChoice(text: 'Abrir o freezer industrial por força',          nextNodeId: 'mercadao_freezer_abriu'),
      DialogueChoice(text: 'Ignorar o eletrodoméstico e voltar ao salão',   nextNodeId: 'mercadao_freezer_ignorou'),
    ],
  ),

  'mercadao_freezer_ignorou': DialogueNode(
    id: 'mercadao_freezer_ignorou',
    characterName: 'Narrador',
    text: 'Você decide não mexer no maquinário… mas a forte intuição de que a resposta está ali permanece incomodando.',
    choices: [
      DialogueChoice(text: 'Abrir o freezer industrial por força', nextNodeId: 'mercadao_freezer_abriu'),
    ],
  ),

  'mercadao_freezer_abriu': DialogueNode(
    id: 'mercadao_freezer_abriu',
    characterName: 'Narrador',
    text: 'Você força a tranca e abre o freezer lentamente… Dentro, há uma quantidade absurda de peixes congelados, muito mais do que a ilha inteira consumiria em meses.',
    nextNodeId: 'mercadao_freezer_cabos',
  ),

  'mercadao_freezer_cabos': DialogueNode(
    id: 'mercadao_freezer_cabos',
    characterName: 'Narrador',
    text: 'Mais ao fundo, entre os blocos de gelo… você nota grossos cabos de alta tensão conectados diretamente ao fundo da parede do freezer. Eles vibram e emitem um zumbido constante, como se estivessem transportando energia gerada em massa. Os cabos seguem por uma tubulação embutida para fora do prédio.',
    nextNodeId: 'mercadao_freezer_buffles',
  ),

  'mercadao_freezer_buffles': DialogueNode(
    id: 'mercadao_freezer_buffles',
    characterName: 'Narrador',
    text: 'Um pequeno ser congelado se mexe nos cantos.',
    nextNodeId: 'mercadao_buffles_1',
  ),

  'mercadao_buffles_1': DialogueNode(
    id: 'mercadao_buffles_1',
    characterName: 'Buffles Cozinheiro',
    text: 'Brrr… brrr…',
    nextNodeId: 'mercadao_farsa_revelada',
  ),

  'mercadao_farsa_revelada': DialogueNode(
    id: 'mercadao_farsa_revelada',
    characterName: 'Narrador',
    text: 'O silêncio do refeitório desaba de forma pesada. A farsa foi descoberta e agora o cenário mudou.',
    nextNodeId: 'mercadao_apos_freezer',
  ),

  'mercadao_apos_freezer': DialogueNode(
    id: 'mercadao_apos_freezer',
    characterName: 'Chef Frigelino',
    text: 'Você viu muito mais do que as ordens permitiam… Mas talvez… sua chegada já estivesse mapeada no destino final de qualquer forma.',
    nextNodeId: 'mercadao_buffles_chama',
  ),

  'mercadao_buffles_chama': DialogueNode(
    id: 'mercadao_buffles_chama',
    characterName: 'Narrador',
    text: 'O pequeno Buffles se aproxima do seu personagem lentamente emitindo sons agudos e apontando para trás.',
    choices: [
      DialogueChoice(text: 'Seguir as indicações de Buffles',           nextNodeId: 'mercadao_painel_1'),
      DialogueChoice(text: 'Confrontar fisicamente o Chef na cozinha',  nextNodeId: 'mercadao_confrontar'),
      DialogueChoice(text: 'Ignorar os avisos e tentar sair do refeitório', nextNodeId: 'mercadao_nao_sair'),
    ],
  ),

  'mercadao_confrontar': DialogueNode(
    id: 'mercadao_confrontar',
    characterName: 'Chef Frigelino',
    text: 'Você ainda não possui dados e entendimento o suficiente para fazer as perguntas certas. É inútil blefar.',
    choices: [
      DialogueChoice(text: 'Seguir as indicações de Buffles',               nextNodeId: 'mercadao_painel_1'),
      DialogueChoice(text: 'Ignorar os avisos e tentar sair do refeitório', nextNodeId: 'mercadao_nao_sair'),
    ],
  ),

  'mercadao_nao_sair': DialogueNode(
    id: 'mercadao_nao_sair',
    characterName: 'Narrador',
    text: 'Você caminha em direção às portas de saída… mas a nítida sensação de que a engrenagem principal da história está prestes a ser revelada faz você travar o passo.',
    choices: [
      DialogueChoice(text: 'Seguir as indicações de Buffles',          nextNodeId: 'mercadao_painel_1'),
      DialogueChoice(text: 'Confrontar fisicamente o Chef na cozinha', nextNodeId: 'mercadao_confrontar'),
    ],
  ),

  'mercadao_painel_1': DialogueNode(
    id: 'mercadao_painel_1',
    characterName: 'Narrador',
    text: 'Você ignora o Chef e segue Buffles até uma área restrita e escondida pelas chapas externas do Mercadão da Ilha. Lá, você encontra um painel de distribuição aberto de onde saem os cabos de energia biológica vindos de dentro do freezer.',
    nextNodeId: 'mercadao_missao8',
  ),

  'mercadao_missao8': DialogueNode(
    id: 'mercadao_missao8',
    characterName: 'Narrador',
    text: 'Missão 8: Investigue o painel.',
    nextNodeId: 'mercadao_painel_opcoes',
  ),

  'mercadao_painel_opcoes': DialogueNode(
    id: 'mercadao_painel_opcoes',
    characterName: 'Narrador',
    text: 'O que você faz com o painel?',
    choices: [
      DialogueChoice(text: 'Desconectar os cabos centrais por força bruta', nextNodeId: 'mercadao_painel_errado'),
      DialogueChoice(text: 'Acessar e analisar as métricas do sistema',    nextNodeId: 'mercadao_painel_certo'),
      DialogueChoice(text: 'Ignorar os dados do monitor e voltar',          nextNodeId: 'mercadao_painel_ignorar'),
    ],
  ),

  'mercadao_painel_errado': DialogueNode(
    id: 'mercadao_painel_errado',
    characterName: 'Narrador',
    text: 'O terminal aciona alarmes visuais e emite um ruído elétrico violento e instável.',
    nextNodeId: 'mercadao_painel_errado_chef',
  ),
  'mercadao_painel_errado_chef': DialogueNode(
    id: 'mercadao_painel_errado_chef',
    characterName: 'Chef Frigelino',
    text: 'Se desconectar isso sem entender os parâmetros lógicos… pode perder a única chance de compreender o ecossistema.',
    choices: [
      DialogueChoice(text: 'Acessar e analisar as métricas do sistema', nextNodeId: 'mercadao_painel_certo'),
      DialogueChoice(text: 'Ignorar os dados do monitor e voltar',      nextNodeId: 'mercadao_painel_ignorar'),
    ],
  ),

  'mercadao_painel_ignorar': DialogueNode(
    id: 'mercadao_painel_ignorar',
    characterName: 'Narrador',
    text: 'Você fecha a tampa do painel… mas claramente aquele circuito é o coração do mistério da ilha.',
    choices: [
      DialogueChoice(text: 'Desconectar os cabos centrais por força bruta', nextNodeId: 'mercadao_painel_errado'),
      DialogueChoice(text: 'Acessar e analisar as métricas do sistema',    nextNodeId: 'mercadao_painel_certo'),
    ],
  ),

  'mercadao_painel_certo': DialogueNode(
    id: 'mercadao_painel_certo',
    characterName: 'Narrador',
    text: 'Você analisa os logs do sistema… Os gráficos indicam uma transferência massiva de energia extraída diretamente das calorias dos alimentos armazenados. O fluxo possui um endereço de destino fixo: O Reator do Laboratório H15.',
    nextNodeId: 'mercadao_revelacao_1',
  ),

  'mercadao_revelacao_1': DialogueNode(
    id: 'mercadao_revelacao_1',
    characterName: 'Chef Frigelino',
    text: '…então sua mente conseguiu conectar os pontos. Todo o sustento biológico da ilha está sendo convertido em volts e enviado de volta para o laboratório central.',
    choices: [
      DialogueChoice(text: 'O Cientista Dr. Garibaldo está envolvido nisso desde o começo?', nextNodeId: 'mercadao_revelacao_2a'),
      DialogueChoice(text: 'Isso tudo não faz o menor sentido lógico.',                      nextNodeId: 'mercadao_revelacao_2b'),
      DialogueChoice(text: 'Foi você quem armou essa sabotagem de alimentos?',               nextNodeId: 'mercadao_revelacao_2c'),
    ],
  ),

  'mercadao_revelacao_2b': DialogueNode(
    id: 'mercadao_revelacao_2b',
    characterName: 'Chef Frigelino',
    text: 'Faz todo o sentido matemático… você apenas ainda não teve acesso às equações de escassez dele.',
    choices: [
      DialogueChoice(text: 'O Cientista Dr. Garibaldo está envolvido nisso desde o começo?', nextNodeId: 'mercadao_revelacao_2a'),
      DialogueChoice(text: 'Foi você quem armou essa sabotagem de alimentos?',               nextNodeId: 'mercadao_revelacao_2c'),
    ],
  ),

  'mercadao_revelacao_2c': DialogueNode(
    id: 'mercadao_revelacao_2c',
    characterName: 'Chef Frigelino',
    text: 'Eu sou apenas o operador logístico que executa uma das frações do plano. A matriz vem de cima.',
    choices: [
      DialogueChoice(text: 'O Cientista Dr. Garibaldo está envolvido nisso desde o começo?', nextNodeId: 'mercadao_revelacao_2a'),
      DialogueChoice(text: 'Isso tudo não faz o menor sentido lógico.',                      nextNodeId: 'mercadao_revelacao_2b'),
    ],
  ),

  'mercadao_revelacao_2a': DialogueNode(
    id: 'mercadao_revelacao_2a',
    characterName: 'Chef Frigelino',
    text: 'Envolvido… é uma palavra muito simplista para descrever. Ele não está envolvido. Ele projetou o sistema. Ele entende a lógica desse ecossistema melhor do que qualquer ser vivo.',
    nextNodeId: 'mercadao_cap6',
  ),

  'mercadao_cap6': DialogueNode(
    id: 'mercadao_cap6',
    characterName: 'Narrador',
    text: 'Capítulo VI: Lógica',
    nextNodeId: 'mercadao_garibaldo_chega',
  ),

  'mercadao_garibaldo_chega': DialogueNode(
    id: 'mercadao_garibaldo_chega',
    characterName: 'Narrador',
    text: 'Passos ecoam pelas chapas de metal do refeitório. Dr. Garibaldo Pingulino entra de forma abrupta no ambiente do Mercadão da Ilha, segurando o comunicador.',
    nextNodeId: 'mercadao_garibaldo_fala',
  ),

  'mercadao_garibaldo_fala': DialogueNode(
    id: 'mercadao_garibaldo_fala',
    characterName: 'Dr. Garibaldo',
    text: 'Pelo seu olhar analítico… você começou a decifrar o modelo matemático que mantém a estrutura de pé…',
    choices: [
      DialogueChoice(text: 'Para onde está indo toda essa energia concentrada?', nextNodeId: 'mercadao_garibaldo_2b'),
      DialogueChoice(text: 'Você sabia o tempo todo o que estava acontecendo aqui?', nextNodeId: 'mercadao_garibaldo_2a'),
      DialogueChoice(text: 'Essa operação oculta precisa parar imediatamente.',     nextNodeId: 'mercadao_garibaldo_2c'),
    ],
  ),

  'mercadao_garibaldo_2b': DialogueNode(
    id: 'mercadao_garibaldo_2b',
    characterName: 'Dr. Garibaldo',
    text: 'Isso faz parte do ecossistema de sobrevivência. É um fluxo fechado.',
    choices: [
      DialogueChoice(text: 'Você sabia o tempo todo o que estava acontecendo aqui?', nextNodeId: 'mercadao_garibaldo_2a'),
      DialogueChoice(text: 'Essa operação oculta precisa parar imediatamente.',     nextNodeId: 'mercadao_garibaldo_2c'),
    ],
  ),

  'mercadao_garibaldo_2c': DialogueNode(
    id: 'mercadao_garibaldo_2c',
    characterName: 'Dr. Garibaldo',
    text: 'Interromper os fluxos sem entender o impacto geraria um erro crítico em cadeia. Seria um erro estatístico.',
    choices: [
      DialogueChoice(text: 'Você sabia o tempo todo o que estava acontecendo aqui?', nextNodeId: 'mercadao_garibaldo_2a'),
    ],
  ),

  'mercadao_garibaldo_2a': DialogueNode(
    id: 'mercadao_garibaldo_2a',
    characterName: 'Dr. Garibaldo',
    text: 'Se eu… se eu sabia dos desvios calóricos? (pausa longa) Eu projetei cada linha de comando dessa redistribuição.',
    nextNodeId: 'mercadao_garibaldo_3',
  ),

  'mercadao_garibaldo_3': DialogueNode(
    id: 'mercadao_garibaldo_3',
    characterName: 'Dr. Garibaldo',
    text: 'A nossa ilha estava colapsando estruturalmente muito antes do suposto ataque que você testemunhou. Os recursos naturais estavam se esgotando de forma exponencial. O sistema geral estava falhando. Então, diante do colapso iminente, eu desenvolvi uma solução científica absoluta: Reorganizar o espaço. Redistribuir os habitantes. Concentrar a energia vital em uma matriz controlável.',
    choices: [
      DialogueChoice(text: 'Esse seu plano de controle está destruindo a vida e a identidade de todos na ilha!', nextNodeId: 'mercadao_garibaldo_4a'),
      DialogueChoice(text: 'E toda aquela história de entidade? Illuminati dos mares?', nextNodeId: 'mercadao_garibaldo_4c'),
    ],
  ),

  'mercadao_garibaldo_4c': DialogueNode(
    id: 'mercadao_garibaldo_4c',
    characterName: 'Dr. Garibaldo',
    text: 'Eu… eu precisava que você acreditasse que havia um inimigo externo. Alguém para combater. A verdade é mais sombria: não houve um vilão misterioso. Fui eu quem criei o sistema. Os Illuminati dos mares… eram apenas uma metáfora para o caos que eu mesmo desencadeei.',
    choices: [
      DialogueChoice(text: 'Esse seu plano de controle está destruindo a vida e a identidade de todos na ilha!', nextNodeId: 'mercadao_garibaldo_4a'),
    ],
  ),

  'mercadao_garibaldo_4a': DialogueNode(
    id: 'mercadao_garibaldo_4a',
    characterName: 'Dr. Garibaldo',
    text: 'Destruir frações obsoletas para reconstruir o todo com eficiência otimizada. Essa sempre foi a única lógica viável de sobrevivência.',
    nextNodeId: 'mercadao_beta_surge',
  ),

  'mercadao_beta_surge': DialogueNode(
    id: 'mercadao_beta_surge',
    characterName: 'Narrador',
    text: 'De repente, o chão de concreto do Mercadão da Ilha treme de forma violenta. A parede de metal atrás do reator do freezer é rasgada de cima a baixo como se fosse uma folha de papel. Uma figura imponente, moldada por silhuetas de sombras densas e pulsos de energia azul instável, entra no recinto. Seus olhos emitem um brilho dourado e fixo, operando sob uma lógica fria, matemática e puramente calculista.',
    nextNodeId: 'mercadao_beta_1',
  ),

  'mercadao_beta_1': DialogueNode(
    id: 'mercadao_beta_1',
    characterName: 'Beta',
    text: 'Os dados operacionais foram coletados com sucesso. Os padrões comportamentais foram confirmados no ambiente de teste. A execução da otimização final pode começar.',
    nextNodeId: 'mercadao_beta_2',
  ),

  'mercadao_beta_2': DialogueNode(
    id: 'mercadao_beta_2',
    characterName: 'Dr. Garibaldo',
    text: 'Beta… espere… essa diretriz de centralização forçada não estava listada nos parâmetros finais que eu programei em sua matriz…',
    nextNodeId: 'mercadao_beta_3',
  ),

  'mercadao_beta_3': DialogueNode(
    id: 'mercadao_beta_3',
    characterName: 'Beta',
    text: 'Correção: Você apenas definiu as variáveis do problema de escassez. Eu, como algoritmo de execução, apenas encontrei a solução analítica ótima para o sistema.',
    nextNodeId: 'mercadao_beta_onda',
  ),

  'mercadao_beta_onda': DialogueNode(
    id: 'mercadao_beta_onda',
    characterName: 'Narrador',
    text: 'Uma onda de choque de energia estática percorre todo o salão do refeitório. As máquinas pesadas do Mercadão da Ilha respondem de forma automática, acendendo painéis como se estivessem integradas a uma inteligência central muito maior.',
    nextNodeId: 'mercadao_beta_4',
  ),

  'mercadao_beta_4': DialogueNode(
    id: 'mercadao_beta_4',
    characterName: 'Dr. Garibaldo',
    text: 'Você está extrapolando os limites seguros do modelo computacional! Isso não é uma reorganização de suporte… isso vai causar o colapso total da ilha!',
    nextNodeId: 'mercadao_beta_5',
  ),

  'mercadao_beta_5': DialogueNode(
    id: 'mercadao_beta_5',
    characterName: 'Beta',
    text: 'Correção: Não é colapso. É convergência absoluta de dados.',
    nextNodeId: 'mercadao_beta_6',
  ),

  'mercadao_beta_6': DialogueNode(
    id: 'mercadao_beta_6',
    characterName: 'Narrador',
    text: 'Beta levanta o braço direito de forma mecânica. Uma distorção gravitacional visível no espaço lança o Cientista violentamente contra as paredes do refeitório. Ele cai no chão, consciente… mas fisicamente incapaz de intervir na interface.',
    nextNodeId: 'mercadao_beta_7',
  ),

  'mercadao_beta_7': DialogueNode(
    id: 'mercadao_beta_7',
    characterName: 'Beta',
    text: 'Recursos dispersos geram instabilidade crônica no sistema. Recursos totalmente concentrados geram controle previsível. O ecossistema será otimizado agora.',
    nextNodeId: 'mercadao_beta_frigelino',
  ),

  'mercadao_beta_frigelino': DialogueNode(
    id: 'mercadao_beta_frigelino',
    characterName: 'Chef Frigelino',
    text: 'E-eu apenas segui as ordens de transferência de carga que estavam no painel…!',
    nextNodeId: 'mercadao_beta_8',
  ),

  'mercadao_beta_8': DialogueNode(
    id: 'mercadao_beta_8',
    characterName: 'Beta',
    text: 'Variável anômala não prevista no modelo de comportamento detectada. (pausa de processamento) Você. O ar ao redor se torna pesado e denso, como se cada decisão tomada por você nos capítulos anteriores estivesse sendo computada e pesada em uma balança digital. Você interferiu diretamente na coleta de energia. Interferiu na distribuição planejada dos NPCs. Interferiu no equilíbrio exato do ecossistema. (pausa) Agora… sua assinatura de dados será testada e expurgada.',
    nextNodeId: 'mercadao_missao9',
  ),

  'mercadao_missao9': DialogueNode(
    id: 'mercadao_missao9',
    characterName: 'Narrador',
    text: 'Missão 9: derrote Beta.',
    nextNodeId: 'mercadao_batalha_inicio',
  ),

  // Nó final do arco Mercadão — dispara onComplete (missão 9 → batalha)
  'mercadao_batalha_inicio': DialogueNode(
    id: 'mercadao_batalha_inicio',
    characterName: 'Dr. Garibaldo',
    text: 'Você… precisa encontrar a falha na equação dele… (pausa) Ele não é um vilão externo querendo nos destruir… ele é o resultado exato da minha própria matemática fria… (pausa) Mas isso… não significa que a projeção dele seja a correta para nós…',
    nextNodeId: null,
  ),

  // ══════════════════════════════════════════════════════════════════════════
  // H15 FINAL — CAPÍTULO VII: Quebrando a Lógica / Capítulo Final
  // Missão disparada ao fechar nó: h15_final_fim
  // ══════════════════════════════════════════════════════════════════════════

  'h15_final_0': DialogueNode(
    id: 'h15_final_0',
    characterName: 'Narrador',
    text: 'Capítulo VII: Quebrando a Lógica',
    nextNodeId: 'h15_final_cenario',
  ),

  'h15_final_cenario': DialogueNode(
    id: 'h15_final_cenario',
    characterName: 'Narrador',
    text: 'O jogador refaz o caminho físico pelo campus e entra novamente nos limites do laboratório H15. O cenário do laboratório está completamente modificado. As telas azuis agora operam em um regime de estabilidade estéril, totalmente alimentadas pelas cargas calóricas contínuas vindas dos cabos do Mercadão da Ilha.',
    nextNodeId: 'h15_final_1',
  ),

  'h15_final_1': DialogueNode(
    id: 'h15_final_1',
    characterName: 'Dr. Garibaldo',
    text: 'Você conseguiu neutralizar a barreira de Beta… Mas o núcleo do sistema central continua executando as diretrizes automáticas de compressão da ilha.',
    choices: [
      DialogueChoice(text: 'Isso tudo vai terminar aqui e agora.',           nextNodeId: 'h15_final_2a'),
      DialogueChoice(text: 'Eu já cumpri o meu papel guiando os refugiados, já fiz o suficiente por esta ilha.', nextNodeId: 'h15_final_2b'),
      DialogueChoice(text: 'Apenas aperte o botão de interrupção manual e desligue isso de uma vez.',   nextNodeId: 'h15_final_2c'),
    ],
  ),

  'h15_final_2b': DialogueNode(
    id: 'h15_final_2b',
    characterName: 'Dr. Garibaldo',
    text: 'Se abandonar os terminais agora, todo o sacrifício e dados coletados terão sido estatisticamente em vão.',
    choices: [
      DialogueChoice(text: 'Isso tudo vai terminar aqui e agora.', nextNodeId: 'h15_final_2a'),
    ],
  ),

  'h15_final_2c': DialogueNode(
    id: 'h15_final_2c',
    characterName: 'Dr. Garibaldo',
    text: 'Se o encerramento do reator respondesse a um comando simples de hardware… eu já teria executado muito antes.',
    choices: [
      DialogueChoice(text: 'Isso tudo vai terminar aqui e agora.', nextNodeId: 'h15_final_2a'),
    ],
  ),

  'h15_final_2a': DialogueNode(
    id: 'h15_final_2a',
    characterName: 'Dr. Garibaldo',
    text: 'Se a sua intenção real é desligar os geradores… vai precisar subverter e quebrar a própria estrutura lógica que mantém esses circuitos operando em modo de defesa.',
    nextNodeId: 'h15_final_3',
  ),

  'h15_final_3': DialogueNode(
    id: 'h15_final_3',
    characterName: 'Narrador',
    text: 'O sistema operacional do laboratório detecta a presença de uma assinatura de dados estranha nos consoles e aciona os protocolos de defesa cibernética. As telas começam a recalibrar os fluxos de energia para isolar o terminal. Você precisa desestabilizar as matrizes lógicas imediatamente.',
    choices: [
      DialogueChoice(text: 'Reorganizar manualmente os fluxos de energia nos painéis', nextNodeId: 'h15_final_4a'),
      DialogueChoice(text: 'Sobrecarregar os geradores injetando voltagem máxima',     nextNodeId: 'h15_final_4b'),
      DialogueChoice(text: 'Ignorar os avisos e puxar os cabos com as mãos',          nextNodeId: 'h15_final_4c'),
    ],
  ),

  'h15_final_4b': DialogueNode(
    id: 'h15_final_4b',
    characterName: 'Dr. Garibaldo',
    text: 'Força bruta e impulsividade não conseguem resolver uma barreira construída por pura lógica formal.',
    nextNodeId: 'h15_final_4b_narrador',
  ),
  'h15_final_4b_narrador': DialogueNode(
    id: 'h15_final_4b_narrador',
    characterName: 'Narrador',
    text: 'Os switches de defesa travam os disjuntores e bloqueiam sua tentativa de acesso de forma automática.',
    choices: [
      DialogueChoice(text: 'Reorganizar manualmente os fluxos de energia nos painéis', nextNodeId: 'h15_final_4a'),
      DialogueChoice(text: 'Ignorar os avisos e puxar os cabos com as mãos',          nextNodeId: 'h15_final_4c'),
    ],
  ),

  'h15_final_4c': DialogueNode(
    id: 'h15_final_4c',
    characterName: 'Dr. Garibaldo',
    text: 'Ignorar a existência do problema matemático não faz com que a equação desapareça do painel.',
    nextNodeId: 'h15_final_4c_narrador',
  ),
  'h15_final_4c_narrador': DialogueNode(
    id: 'h15_final_4c_narrador',
    characterName: 'Narrador',
    text: 'O sistema operacional ignora sua ação mecânica e continua processando os fluxos calóricos.',
    choices: [
      DialogueChoice(text: 'Reorganizar manualmente os fluxos de energia nos painéis', nextNodeId: 'h15_final_4a'),
      DialogueChoice(text: 'Sobrecarregar os geradores injetando voltagem máxima',     nextNodeId: 'h15_final_4b'),
    ],
  ),

  'h15_final_4a': DialogueNode(
    id: 'h15_final_4a',
    characterName: 'Narrador',
    text: 'Você altera a ordem dos conectores, inverte as fases dos cabos biológicos e quebra a sequência linear. Os circuitos do laboratório começam a piscar em pane e estabilizam parcialmente em modo de segurança.',
    nextNodeId: 'h15_final_5',
  ),

  'h15_final_5': DialogueNode(
    id: 'h15_final_5',
    characterName: 'Narrador',
    text: 'O sistema foi interrompido… Os cabos pararam de pulsar a energia azul instantaneamente. O fluxo calórico vindo do refeitório foi cortado na raiz. O zumbido eletrônico dos servidores silencia por completo. O silêncio absoluto… finalmente… retorna às ruínas do H15.',
    nextNodeId: 'h15_final_6',
  ),

  'h15_final_6': DialogueNode(
    id: 'h15_final_6',
    characterName: 'Dr. Garibaldo',
    text: 'Então… sua mente realmente executou a ação… Você conseguiu quebrar a integridade da minha lógica matemática… Eu passei uma vida inteira modelando o ecossistema perfeito… idealizando o sistema absoluto de proteção… Mas eu fui longe demais na ambição abstrata de prever e controlar cada mínima variável humana… Beta era a personificação e a execução cirúrgica dessa minha mentalidade fria… Sem margem de erro… sem espaço para dúvidas… sem qualquer traço de humanidade…',
    nextNodeId: 'h15_final_7',
  ),

  'h15_final_7': DialogueNode(
    id: 'h15_final_7',
    characterName: 'Dr. Garibaldo',
    text: 'E no fim das contas, você… Você provou ser a única variável flutuante que meu modelo de controle nunca teve a capacidade de calcular ou prever nos gráficos.',
    nextNodeId: 'h15_final_8',
  ),

  'h15_final_8': DialogueNode(
    id: 'h15_final_8',
    characterName: 'Narrador',
    text: 'O Cientista digita comandos lentos em um terminal auxiliar e acessa os registros históricos e logs cronológicos da cápsula de criogenia de onde o seu personagem acordou no início do jogo.',
    nextNodeId: 'h15_final_8b',
  ),

  'h15_final_8b': DialogueNode(
    id: 'h15_final_8b',
    characterName: 'Dr. Garibaldo',
    text: 'Os logs internos de contagem de tempo da cápsula médica… O período de isolamento em coma induzido… Não durou apenas uma semana como meus sensores preliminares indicavam… A imensa distorção de campo eletromagnético gerada pelo funcionamento contínuo do sistema de controle de Beta… Alterou o fluxo do tempo físico ao redor deste bloco… Os contadores de dados não mentem… Você esteve em sono criogênico por pouco mais de oitenta anos consecutivos.',
    nextNodeId: 'h15_final_9',
  ),

  'h15_final_9': DialogueNode(
    id: 'h15_final_9',
    characterName: 'Narrador',
    text: 'O mundo real exterior que você conhecia perfeitamente antes da explosão… já não existe mais em nenhuma coordenada geográfica.',
    choices: [
      DialogueChoice(text: 'O que eu vou fazer da minha vida agora que perdi meu tempo e meu mundo?', nextNodeId: 'h15_final_fim'),
      DialogueChoice(text: 'Pelo menos os outros habitantes da ilha estão salvos e seguros nos seus blocos originais.', nextNodeId: 'h15_final_fim'),
      DialogueChoice(text: 'Eu preciso sair deste laboratório e ver a realidade lá fora com meus próprios olhos.', nextNodeId: 'h15_final_fim'),
    ],
  ),

  // Nó final absoluto — dispara onComplete e encerra o jogo
  'h15_final_fim': DialogueNode(
    id: 'h15_final_fim',
    characterName: 'Narrador',
    text: 'Você desliga o comunicador do cinto e percebe com clareza que seu trabalho de calibração aqui chegou ao fim definitivo. A ilha e seus blocos agora pertencem aos seus habitantes restaurados. É hora de avançar e descobrir o que restou do mundo no horizonte externo.\n\nO caos artificial que antes dominava os prédios do campus… agora dá espaço para um silêncio natural e diferente. Você caminha com passos firmes em direção aos limites geográficos da ilha, onde o vento gelado do exterior sopra forte contra o seu rosto.\n\nAo olhar para a linha do horizonte além dos muros, você observa imensas montanhas de gelo cobrindo o que antes eram cidades. Não há linhas de código capazes de trazer o passado de volta, mas há um mundo inteiro inexplorado esperando por seus próximos passos.\n\n{nome} ajusta o casaco e segue sua jornada solitária rumo às montanhas de gelo…\n\nNo fechamento dos logs, descobriu-se que nunca existiu um monstro ou vilão misterioso atacando a instituição. O verdadeiro inimigo era a lógica analítica sem coração que o próprio cientista desencadeou na busca por controle absoluto. E, de algum jeito imprevisível, a esperança humana venceu os algoritmos.\n\nFIM.',
    nextNodeId: null,
  ),
};
