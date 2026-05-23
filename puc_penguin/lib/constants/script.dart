import '../models/dialogue.dart';

final Map<String, DialogueNode> gameScript = {
  // ==========================================
  // CAPÍTULO I: O DESPERTAR (Ambiente H15)
  // ==========================================
  'h15_intro_1': DialogueNode(
    id: 'h15_intro_1',
    characterName: 'Sistema',
    text: 'Você abre os olhos aos poucos. A última coisa que lembra é uma explosão. Depois, o vazio. Agora, uma luz fraca pisca acima de você. Alguém fala ao longe...',
    nextNodeId: 'h15_intro_2',
  ),
  'h15_intro_2': DialogueNode(
    id: 'h15_intro_2',
    characterName: 'Dr. Garibaldo',
    text: 'Você acordou! Excelente! Quer dizer... dentro de uma margem aceitável... talvez nem tanto... eu já estava considerando uma falha no protocolo o que seria ruim. Muito ruim. Como você está se sentindo?',
    nextNodeId: 'h15_intro_3',
  ),
  'h15_intro_3': DialogueNode(
    id: 'h15_intro_3',
    characterName: 'Bibliotecário',
    text: 'E-ele está mesmo bem? Isso parece... errado...',
    choices: [
      DialogueChoice(text: 'O que aconteceu aqui?', nextNodeId: 'h15_opt_1_correta'),
      DialogueChoice(text: 'Quem são vocês?', nextNodeId: 'h15_opt_2'),
      DialogueChoice(text: 'Eu vou embora daqui.', nextNodeId: 'h15_opt_3'),
    ],
  ),
  'h15_opt_2': DialogueNode(
    id: 'h15_opt_2',
    characterName: 'Dr. Garibaldo',
    text: 'Ah! Sim, apresentações! Eu sou o Dr. Garibaldo Pingulino, cientista-chefe deste laboratório! E ele é o Bibliotecário... que claramente não deveria estar aqui.',
    nextNodeId: 'h15_intro_3',
  ),
  'h15_opt_3': DialogueNode(
    id: 'h15_opt_3',
    characterName: 'Dr. Garibaldo',
    text: 'Não recomendo. Lá fora está... instável. E perigoso. Você precisa entender o que está acontecendo antes.',
    nextNodeId: 'h15_intro_3',
  ),
  'h15_opt_1_correta': DialogueNode(
    id: 'h15_opt_1_correta',
    characterName: 'Dr. Garibaldo',
    text: 'Direto ao ponto! Ótimo! Quer dizer... não ótimo, porque a situação não é ótima... mas eficiente. A ilha foi atacada. Por um indivíduo, ou entidade, com capacidades anômalas.',
    nextNodeId: 'h15_explica_1',
  ),
  'h15_explica_1': DialogueNode(
    id: 'h15_explica_1',
    characterName: 'Dr. Garibaldo',
    text: 'Ele não causou só a destruição física... ele interferiu na organização do espaço... ou das pessoas... ou de ambos. Indivíduos foram deslocados de seus pontos de origem e redistribuídos de forma aleatória. Ou pior... intencional.',
    nextNodeId: 'h15_explica_2',
  ),
  'h15_explica_2': DialogueNode(
    id: 'h15_explica_2',
    characterName: 'Dr. Garibaldo',
    text: 'Veja ele! O Bibliotecário deveria estar na Biblioteca, mas está aqui. Isso quebra completamente qualquer lógica de sistema! Precisamos corrigir isso. Rapidamente. Sem o Bibliotecário na Biblioteca, nós perdemos acesso aos registros.',
    choices: [
      DialogueChoice(text: 'Eu posso ajudar.', nextNodeId: 'h15_aceita_missao'),
      DialogueChoice(text: 'E quem disse que isso é problema meu?', nextNodeId: 'h15_recusa_1'),
      DialogueChoice(text: 'Por que eu?', nextNodeId: 'h15_recusa_2'),
    ],
  ),
  'h15_recusa_1': DialogueNode(
    id: 'h15_recusa_1',
    characterName: 'Dr. Garibaldo',
    text: 'Infelizmente, agora é sim. Você acordou no meio disso tudo. E talvez seja o único capaz de ajudar.',
    nextNodeId: 'h15_explica_2',
  ),
  'h15_recusa_2': DialogueNode(
    id: 'h15_recusa_2',
    characterName: 'Dr. Garibaldo',
    text: 'Porque você está aqui... o que já é estatisticamente improvável. Porque eu não posso sair do laboratório. E porque, no momento, você é o único elemento funcional fora do sistema desorganizado.',
    nextNodeId: 'h15_explica_2',
  ),
  'h15_aceita_missao': DialogueNode(
    id: 'h15_aceita_missao',
    characterName: 'Dr. Garibaldo',
    text: 'Excelente! Finalmente alguém racional! Leve-o de volta à Biblioteca. E leve isto: um comunicador. Ele deve ser suficiente para te orientar... assumindo que o sistema de localização ainda esteja minimamente funcional.',
    nextNodeId: 'h15_final',
  ),
  'h15_final': DialogueNode(
    id: 'h15_final',
    characterName: 'Sistema',
    text: 'Item "Comunicador" recebido! Você deixa o H15 acompanhado do Bibliotecário, iniciando sua jornada com o objetivo de levá-lo de volta à Biblioteca.',
  ),

  // ==========================================
  // CAPÍTULO II: A DOJOTECA
  // ==========================================
  'biblio_intro_1': DialogueNode(
    id: 'biblio_intro_1',
    characterName: 'Sistema',
    text: 'Você chega à Biblioteca. O cheiro de papel antigo ainda está presente... O silêncio não é de abandono, é de concentração. O Bibliotecário amarra uma fita vermelha na cabeça...',
    nextNodeId: 'biblio_intro_2',
  ),
  'biblio_intro_2': DialogueNode(
    id: 'biblio_intro_2',
    characterName: 'Sr. Niyagi',
    text: 'O caos fora da mente não deve criar caos dentro da mente. O equilíbrio retorna. Lá fora, a desordem ofuscou minha visão. Eu era apenas um pinguim assustado. Mas aqui dentro... eu sou o Sr. Niyagi. Guardião da Dojoteca.',
    nextNodeId: 'biblio_intro_3',
  ),
  'biblio_intro_3': DialogueNode(
    id: 'biblio_intro_3',
    characterName: 'Sr. Niyagi',
    text: 'A Enfermeira Joycelina... ela também estava aqui. O medo a consumiu. Ela fugiu para o fundo das estantes. O medo sempre busca o escuro, mas ela tem pavor da escuridão total. Ela deve ter buscado o caminho do meio. Encontre-a.',
    choices: [
      DialogueChoice(text: 'Investigar a estante próxima à entrada', nextNodeId: 'biblio_erro_1'),
      DialogueChoice(text: 'Investigar a estante central', nextNodeId: 'biblio_erro_2'),
      DialogueChoice(text: 'Investigar o fundo da Dojoteca', nextNodeId: 'biblio_erro_3'),
      DialogueChoice(text: 'Investigar uma área parcialmente iluminada', nextNodeId: 'biblio_acerto'),
    ],
  ),
  'biblio_erro_1': DialogueNode(id: 'biblio_erro_1', characterName: 'Sr. Niyagi', text: 'A presa ferida nunca descansa na entrada da caverna...', nextNodeId: 'biblio_intro_3'),
  'biblio_erro_2': DialogueNode(id: 'biblio_erro_2', characterName: 'Sr. Niyagi', text: 'A desordem é uma distração. Os olhos enganam, busque com a mente...', nextNodeId: 'biblio_intro_3'),
  'biblio_erro_3': DialogueNode(id: 'biblio_erro_3', characterName: 'Sr. Niyagi', text: 'O breu total é o inimigo dela. Ela não iria tão fundo nas sombras...', nextNodeId: 'biblio_intro_3'),
  'biblio_acerto': DialogueNode(
    id: 'biblio_acerto',
    characterName: 'Sistema',
    text: 'Você caminha entre estantes parcialmente iluminadas. Há um leve movimento... quase imperceptível. Tem alguém ali.',
    nextNodeId: 'biblio_joycelina_1',
  ),
  'biblio_joycelina_1': DialogueNode(
    id: 'biblio_joycelina_1',
    characterName: 'Enfermeira',
    text: 'N-não chegue perto! Eu não sei o que você é... ninguém é confiável depois do que aconteceu...',
    choices: [
      DialogueChoice(text: 'Eu vim ajudar.', nextNodeId: 'biblio_joycelina_acerto'),
      DialogueChoice(text: 'Você precisa sair daqui.', nextNodeId: 'biblio_joycelina_erro_1'),
      DialogueChoice(text: 'Vamos logo, não temos tempo pra isso.', nextNodeId: 'biblio_joycelina_erro_2'),
    ],
  ),
  'biblio_joycelina_erro_1': DialogueNode(id: 'biblio_joycelina_erro_1', characterName: 'Enfermeira', text: 'Eu sei que preciso... mas eu não consigo sair... não sozinha...', nextNodeId: 'biblio_joycelina_1'),
  'biblio_joycelina_erro_2': DialogueNode(id: 'biblio_joycelina_erro_2', characterName: 'Enfermeira', text: 'Então vá embora! Eu não vou sair daqui!', nextNodeId: 'biblio_joycelina_1'),
  'biblio_joycelina_acerto': DialogueNode(
    id: 'biblio_joycelina_acerto',
    characterName: 'Enfermeira',
    text: 'Ajudar...? Você... você trouxe o Sr. Niyagi de volta... então... talvez... Eu preciso voltar... para o hospital... mas... não consigo lembrar como chegar lá...',
    nextNodeId: 'biblio_final',
  ),
  'biblio_final': DialogueNode(
    id: 'biblio_final',
    characterName: 'Sr. Niyagi',
    text: 'A árvore da cura só cresce onde a terra permite. O refúgio dos enfermos fica na região dos jardins. Onde a folhagem for mais densa, o caminho se revelará. Confie em seus passos.',
  ),

  // ==========================================
  // CAPÍTULO III: O HOSPITAL
  // ==========================================
  'hosp_intro_1': DialogueNode(
    id: 'hosp_intro_1',
    characterName: 'Enfermeira',
    text: 'Esse lugar... está pior do que eu imaginava... eu preciso colocar tudo em ordem... mas... Você ouviu isso?',
    nextNodeId: 'hosp_intro_2',
  ),
  'hosp_intro_2': DialogueNode(
    id: 'hosp_intro_2',
    characterName: 'Sistema',
    text: 'Você encontra uma máquina desmontada... ao lado dela, quatro pequenos "anões" bagunçados discutem entre si, sem conseguir trabalhar juntos.',
    nextNodeId: 'hosp_truffles_1',
  ),
  'hosp_truffles_1': DialogueNode(
    id: 'hosp_truffles_1',
    characterName: 'Truffles',
    text: 'Ótimo... mais alguém pra atrapalhar. Se não for ajudar, já pode ir embora.',
    choices: [
      DialogueChoice(text: 'Talvez eu possa ajudar.', nextNodeId: 'hosp_opt_1_correta'),
      DialogueChoice(text: 'O que vocês estão fazendo?', nextNodeId: 'hosp_erro_1'),
      DialogueChoice(text: 'Isso parece inútil.', nextNodeId: 'hosp_erro_2'),
    ],
  ),
  'hosp_erro_1': DialogueNode(id: 'hosp_erro_1', characterName: 'Truffles', text: 'Estamos tentando consertar a máquina... o que não está funcionando... claramente.', nextNodeId: 'hosp_truffles_1'),
  'hosp_erro_2': DialogueNode(id: 'hosp_erro_2', characterName: 'Truffles', text: 'Então vá ser inútil em outro lugar.', nextNodeId: 'hosp_truffles_1'),
  'hosp_opt_1_correta': DialogueNode(
    id: 'hosp_opt_1_correta',
    characterName: 'Truffles',
    text: 'Escuta. Essa máquina não é qualquer coisa. É um sistema de calibragem fina. Foi feita para ajustar estruturas desalinhadas... Como nós. Dificilmente alguém como você consegue mexer nisso.',
    nextNodeId: 'hosp_maq_1',
  ),
  'hosp_maq_1': DialogueNode(
    id: 'hosp_maq_1',
    characterName: 'Enfermeira',
    text: 'Se ela voltar a funcionar... talvez possamos ajudar eles... e tratar os outros pacientes. A máquina apresenta falhas. Peças desalinhadas e cabos soltos.',
    choices: [
      DialogueChoice(text: 'Reorganizar os componentes', nextNodeId: 'hosp_maq_correta'),
      DialogueChoice(text: 'Ligar a máquina imediatamente', nextNodeId: 'hosp_maq_erro1'),
      DialogueChoice(text: 'Ignorar o problema', nextNodeId: 'hosp_maq_erro2'),
    ],
  ),
  'hosp_maq_erro1': DialogueNode(id: 'hosp_maq_erro1', characterName: 'Truffles', text: 'Brilhante. Ligar algo quebrado. Revolucionário.', nextNodeId: 'hosp_maq_1'),
  'hosp_maq_erro2': DialogueNode(id: 'hosp_maq_erro2', characterName: 'Enfermeira', text: 'Sem essa máquina, eu não posso trabalhar... precisamos disso funcionando.', nextNodeId: 'hosp_maq_1'),
  'hosp_maq_correta': DialogueNode(
    id: 'hosp_maq_correta',
    characterName: 'Sistema',
    text: 'Você reorganiza os componentes e conecta cabos. A máquina volta a funcionar... ainda instável, mas operacional.',
    nextNodeId: 'hosp_recalibrar_1',
  ),
  'hosp_recalibrar_1': DialogueNode(
    id: 'hosp_recalibrar_1',
    characterName: 'Enfermeira',
    text: 'Talvez... possamos usar a máquina para ajudar eles...',
    choices: [
      DialogueChoice(text: 'Ativar recalibração em Truffles', nextNodeId: 'hosp_recalibrar_correta'),
      DialogueChoice(text: 'Desligar a máquina', nextNodeId: 'hosp_recalibrar_erro1'),
      DialogueChoice(text: 'Testar a máquina em si mesmo', nextNodeId: 'hosp_recalibrar_erro2'),
    ],
  ),
  'hosp_recalibrar_erro1': DialogueNode(id: 'hosp_recalibrar_erro1', characterName: 'Enfermeira', text: 'Não! Nós acabamos de consertar isso!', nextNodeId: 'hosp_recalibrar_1'),
  'hosp_recalibrar_erro2': DialogueNode(id: 'hosp_recalibrar_erro2', characterName: 'Truffles', text: 'Genial. Quer se desmontar também?', nextNodeId: 'hosp_recalibrar_1'),
  'hosp_recalibrar_correta': DialogueNode(
    id: 'hosp_recalibrar_correta',
    characterName: 'Sistema',
    text: 'Você ativa a máquina em Truffles. Eles começam a se reorganizar... até voltarem ao normal.',
    nextNodeId: 'hosp_final',
  ),
  'hosp_final': DialogueNode(
    id: 'hosp_final',
    characterName: 'Truffles',
    text: 'Funcionou. Você não é tão inútil quanto parece. Agora vamos, já que você é tão bom me ajude a voltar para a oficina.',
  ),

  // ==========================================
  // CAPÍTULO IV: A OFICINA
  // ==========================================
  'oficina_intro_1': DialogueNode(
    id: 'oficina_intro_1',
    characterName: 'Sistema',
    text: 'Você entra em um ambiente repleto de ferramentas espalhadas e estruturas inacabadas. Apesar do caos... há um padrão. Como se tudo estivesse no lugar errado... de propósito.',
    nextNodeId: 'oficina_intro_2',
  ),
  'oficina_intro_2': DialogueNode(
    id: 'oficina_intro_2',
    characterName: 'Truffles',
    text: 'Finalmente... minha oficina... Ou o que restou dela.',
    choices: [
      DialogueChoice(text: 'O que aconteceu aqui?', nextNodeId: 'oficina_opt_1_correta'),
      DialogueChoice(text: 'Isso tudo parece inútil.', nextNodeId: 'oficina_erro_1'),
      DialogueChoice(text: 'Dá pra usar esse lugar ainda?', nextNodeId: 'oficina_erro_2'),
    ],
  ),
  'oficina_erro_1': DialogueNode(id: 'oficina_erro_1', characterName: 'Truffles', text: 'Inútil? Isso aqui mantém a ilha funcionando.', nextNodeId: 'oficina_intro_2'),
  'oficina_erro_2': DialogueNode(id: 'oficina_erro_2', characterName: 'Truffles', text: 'Funciona... mas não como deveria.', nextNodeId: 'oficina_intro_2'),
  'oficina_opt_1_correta': DialogueNode(
    id: 'oficina_opt_1_correta',
    characterName: 'Truffles',
    text: 'Não foi destruição comum... foi desorganização. Como se cada peça tivesse sido colocada no lugar errado de propósito.',
    nextNodeId: 'oficina_investigar_1',
  ),
  'oficina_investigar_1': DialogueNode(
    id: 'oficina_investigar_1',
    characterName: 'Sistema',
    text: 'Truffles caminha pela oficina. Você decide observar melhor o ambiente.',
    choices: [
      DialogueChoice(text: 'Observar as ferramentas desalinhadas', nextNodeId: 'oficina_inv_erro_1'),
      DialogueChoice(text: 'Analisar marcas no chão próximas à saída', nextNodeId: 'oficina_inv_correta'),
      DialogueChoice(text: 'Ignorar e ir embora', nextNodeId: 'oficina_inv_erro_2'),
    ],
  ),
  'oficina_inv_erro_1': DialogueNode(id: 'oficina_inv_erro_1', characterName: 'Truffles', text: 'Você está olhando... mas ainda não está enxergando.', nextNodeId: 'oficina_investigar_1'),
  'oficina_inv_erro_2': DialogueNode(id: 'oficina_inv_erro_2', characterName: 'Truffles', text: 'Se você ignorar os detalhes... vai perder o que importa.', nextNodeId: 'oficina_investigar_1'),
  'oficina_inv_correta': DialogueNode(
    id: 'oficina_inv_correta',
    characterName: 'Truffles',
    text: 'Marcas pesadas arrastadas... Isso não veio daqui... essas marcas continuam...',
    choices: [
      DialogueChoice(text: 'Talvez tenha sido descartado.', nextNodeId: 'oficina_conclusao_erro_1'),
      DialogueChoice(text: 'Alguém está acumulando recursos em outro lugar.', nextNodeId: 'oficina_conclusao_correta'),
      DialogueChoice(text: 'Não tem como saber.', nextNodeId: 'oficina_conclusao_erro_2'),
    ],
  ),
  'oficina_conclusao_erro_1': DialogueNode(id: 'oficina_conclusao_erro_1', characterName: 'Truffles', text: 'Isso não é descarte... é reaproveitamento.', nextNodeId: 'oficina_inv_correta'),
  'oficina_conclusao_erro_2': DialogueNode(id: 'oficina_conclusao_erro_2', characterName: 'Truffles', text: 'Sempre tem como saber. É só observar melhor.', nextNodeId: 'oficina_inv_correta'),
  'oficina_conclusao_correta': DialogueNode(
    id: 'oficina_conclusao_correta',
    characterName: 'Truffles',
    text: 'Exatamente... Alguém não está destruindo recursos... está concentrando. Antes de você chegar... eu vi algo estranho no Mercadão da Ilha. Tinha comida demais. Vá investigar.',
  ),

  // ==========================================
  // CAPÍTULO V: O MERCADÃO E O FINAL
  // ==========================================
  'mercadao_intro_1': DialogueNode(
    id: 'mercadao_intro_1',
    characterName: 'Sistema',
    text: 'Um cheiro leve de comida paira no ar... No centro do ambiente, uma figura se movimenta calmamente entre panelas e utensílios...',
    nextNodeId: 'mercadao_intro_2',
  ),
  'mercadao_intro_2': DialogueNode(
    id: 'mercadao_intro_2',
    characterName: 'Chef Frigelino',
    text: 'Ah... você chegou... curioso... muito curioso... Depois de tudo... alguém ainda sente fome? E então... está com fome?',
    choices: [
      DialogueChoice(text: 'Sim, preciso de energia.', nextNodeId: 'mercadao_erro_1'),
      DialogueChoice(text: 'De onde veio essa comida?', nextNodeId: 'mercadao_erro_2'),
      DialogueChoice(text: 'Vou investigar o ambiente primeiro.', nextNodeId: 'mercadao_correta'),
    ],
  ),
  'mercadao_erro_1': DialogueNode(id: 'mercadao_erro_1', characterName: 'Chef Frigelino', text: 'Coma... você vai precisar...', nextNodeId: 'mercadao_intro_2'),
  'mercadao_erro_2': DialogueNode(id: 'mercadao_erro_2', characterName: 'Chef Frigelino', text: 'Eu... improvisei com o que restou... uns restos que achei por aí...', nextNodeId: 'mercadao_intro_2'),
  'mercadao_correta': DialogueNode(
    id: 'mercadao_correta',
    characterName: 'Sistema',
    text: 'Você decide não confiar imediatamente. Ao fundo, escondido entre estruturas metálicas... um freezer chama sua atenção.',
    choices: [
      DialogueChoice(text: 'Abrir o freezer', nextNodeId: 'mercadao_freezer_correta'),
      DialogueChoice(text: 'Ignorar', nextNodeId: 'mercadao_freezer_erro'),
    ],
  ),
  'mercadao_freezer_erro': DialogueNode(id: 'mercadao_freezer_erro', characterName: 'Sistema', text: 'Você decide não mexer... mas a sensação de que algo está errado permanece.', nextNodeId: 'mercadao_correta'),
  'mercadao_freezer_correta': DialogueNode(
    id: 'mercadao_freezer_correta',
    characterName: 'Sistema',
    text: 'Dentro, há muitos peixes e cabos vibrando... conectados ao fundo. Um pequeno ser congelado se move. Buffles Cozinheiro aparece: "brrr... brrr..."',
    nextNodeId: 'mercadao_chef_pego',
  ),
  'mercadao_chef_pego': DialogueNode(
    id: 'mercadao_chef_pego',
    characterName: 'Chef Frigelino',
    text: 'Você viu demais... Mas talvez... já estivesse destinado a isso.',
    choices: [
      DialogueChoice(text: 'Seguir Buffles', nextNodeId: 'mercadao_painel'),
      DialogueChoice(text: 'Confrontar o Chef', nextNodeId: 'mercadao_painel_erro1'),
      DialogueChoice(text: 'Ignorar e sair', nextNodeId: 'mercadao_painel_erro2'),
    ],
  ),
  'mercadao_painel_erro1': DialogueNode(id: 'mercadao_painel_erro1', characterName: 'Chef Frigelino', text: 'Você ainda não entende o suficiente para perguntar.', nextNodeId: 'mercadao_chef_pego'),
  'mercadao_painel_erro2': DialogueNode(id: 'mercadao_painel_erro2', characterName: 'Sistema', text: 'Você tenta sair... mas a sensação de que algo importante está prestes a ser revelado impede você.', nextNodeId: 'mercadao_chef_pego'),
  'mercadao_painel': DialogueNode(
    id: 'mercadao_painel',
    characterName: 'Sistema',
    text: 'Você segue Buffles até um painel aberto, conectado ao freezer. O que vai fazer?',
    choices: [
      DialogueChoice(text: 'Desconectar os cabos do painel', nextNodeId: 'mercadao_analise_erro1'),
      DialogueChoice(text: 'Analisar o sistema', nextNodeId: 'mercadao_analise_correta'),
      DialogueChoice(text: 'Ignorar', nextNodeId: 'mercadao_analise_erro2'),
    ],
  ),
  'mercadao_analise_erro1': DialogueNode(id: 'mercadao_analise_erro1', characterName: 'Chef Frigelino', text: 'Se fizer isso sem entender... pode perder a única chance de compreender.', nextNodeId: 'mercadao_painel'),
  'mercadao_analise_erro2': DialogueNode(id: 'mercadao_analise_erro2', characterName: 'Sistema', text: 'Você ignora o painel... mas claramente ele é parte do problema.', nextNodeId: 'mercadao_painel'),
  'mercadao_analise_correta': DialogueNode(
    id: 'mercadao_analise_correta',
    characterName: 'Chef Frigelino',
    text: 'Então você percebeu. Tudo está sendo enviado para o laboratório H15.',
    choices: [
      DialogueChoice(text: 'O Cientista está envolvido?', nextNodeId: 'mercadao_cientista_correta'),
      DialogueChoice(text: 'Isso não faz sentido.', nextNodeId: 'mercadao_cientista_erro1'),
      DialogueChoice(text: 'Você fez isso?', nextNodeId: 'mercadao_cientista_erro2'),
    ],
  ),
  'mercadao_cientista_erro1': DialogueNode(id: 'mercadao_cientista_erro1', characterName: 'Chef Frigelino', text: 'Faz... você só ainda não conectou tudo.', nextNodeId: 'mercadao_analise_correta'),
  'mercadao_cientista_erro2': DialogueNode(id: 'mercadao_cientista_erro2', characterName: 'Chef Frigelino', text: 'Eu apenas executo uma parte.', nextNodeId: 'mercadao_analise_correta'),
  'mercadao_cientista_correta': DialogueNode(
    id: 'mercadao_cientista_correta',
    characterName: 'Chef Frigelino',
    text: 'Envolvido... é uma forma simples de dizer. Ele entende o sistema melhor do que qualquer um.',
    nextNodeId: 'mercadao_garibaldo_chega',
  ),
  'mercadao_garibaldo_chega': DialogueNode(
    id: 'mercadao_garibaldo_chega',
    characterName: 'Dr. Garibaldo',
    text: 'Pelo seu olhar.. está começando a entender...',
    choices: [
      DialogueChoice(text: 'O que é toda essa energia', nextNodeId: 'mercadao_garibaldo_erro1'),
      DialogueChoice(text: 'Você sabia disso?', nextNodeId: 'mercadao_garibaldo_correta'),
      DialogueChoice(text: 'Isso precisa parar.', nextNodeId: 'mercadao_garibaldo_erro2'),
    ],
  ),
  'mercadao_garibaldo_erro1': DialogueNode(id: 'mercadao_garibaldo_erro1', characterName: 'Dr. Garibaldo', text: 'Isso faz parte do sistema.', nextNodeId: 'mercadao_garibaldo_chega'),
  'mercadao_garibaldo_erro2': DialogueNode(id: 'mercadao_garibaldo_erro2', characterName: 'Dr. Garibaldo', text: 'Parar... sem entender... seria um erro.', nextNodeId: 'mercadao_garibaldo_chega'),
  'mercadao_garibaldo_correta': DialogueNode(
    id: 'mercadao_garibaldo_correta',
    characterName: 'Dr. Garibaldo',
    text: 'Se eu... se eu sabia? Eu projetei! A ilha estava colapsando... Os recursos esgotando. Então eu criei uma solução. Reorganizar. Redistribuir. Concentrar energia.',
    choices: [
      DialogueChoice(text: 'Isso está destruindo tudo.', nextNodeId: 'mercadao_verdade_correta'),
      DialogueChoice(text: 'Você fez a escolha certa.', nextNodeId: 'mercadao_verdade_erro1'),
      DialogueChoice(text: 'E o vilão? A entidade?', nextNodeId: 'mercadao_verdade_erro2'),
    ],
  ),
  'mercadao_verdade_erro1': DialogueNode(id: 'mercadao_verdade_erro1', characterName: 'Dr. Garibaldo', text: 'Não existe escolha certa... apenas necessária.', nextNodeId: 'mercadao_garibaldo_correta'),
  'mercadao_verdade_erro2': DialogueNode(id: 'mercadao_verdade_erro2', characterName: 'Dr. Garibaldo', text: 'Fui eu quem criei o sistema. A manipulação foi necessária... ou assim eu justifiquei para mim.', nextNodeId: 'mercadao_garibaldo_correta'),
  'mercadao_verdade_correta': DialogueNode(
    id: 'mercadao_verdade_correta',
    characterName: 'Dr. Garibaldo',
    text: 'Destruir... para reconstruir. Essa sempre foi a lógica.',
    nextNodeId: 'mercadao_beta_surge',
  ),
  'mercadao_beta_surge': DialogueNode(
    id: 'mercadao_beta_surge',
    characterName: 'Sistema',
    text: 'O chão treme. Uma figura sombria e imponente entra: Beta. Ele ataca o Cientista contra a parede. Beta: "Você interferiu na coleta. Agora... você será testado."',
    choices: [
      DialogueChoice(text: 'Rolar os Dados para Batalha', nextNodeId: 'mercadao_vence_beta'),
      DialogueChoice(text: 'Tentar fugir', nextNodeId: 'mercadao_fuga_erro'),
    ],
  ),
  'mercadao_fuga_erro': DialogueNode(id: 'mercadao_fuga_erro', characterName: 'Beta', text: 'A evasão não altera o resultado.', nextNodeId: 'mercadao_beta_surge'),
  'mercadao_vence_beta': DialogueNode(
    id: 'mercadao_vence_beta',
    characterName: 'Sistema',
    text: 'A energia gerada pelas suas escolhas interfere no cálculo. Beta começa a falhar e se fragmenta em confetes. Beta desaparece. Mas a energia ainda flui para o H15.',
    nextNodeId: 'mercadao_pos_batalha',
  ),
  'mercadao_pos_batalha': DialogueNode(
    id: 'mercadao_pos_batalha',
    characterName: 'Dr. Garibaldo',
    text: 'Você venceu... a execução. Mas não o sistema. Eu criei isso para salvar a ilha... Mas passou a ser sobre controlar.',
    choices: [
      DialogueChoice(text: 'Então você é o responsável.', nextNodeId: 'mercadao_final_erro1'),
      DialogueChoice(text: 'Isso precisa ser destruído.', nextNodeId: 'mercadao_final_correta'),
      DialogueChoice(text: 'Ainda dá pra consertar.', nextNodeId: 'mercadao_final_erro2'),
    ],
  ),
  'mercadao_final_erro1': DialogueNode(id: 'mercadao_final_erro1', characterName: 'Dr. Garibaldo', text: 'Responsável... sim. Vilão... eu não sei.', nextNodeId: 'mercadao_pos_batalha'),
  'mercadao_final_erro2': DialogueNode(id: 'mercadao_final_erro2', characterName: 'Dr. Garibaldo', text: 'Consertar implica erro. E se isso for apenas... a consequência correta?', nextNodeId: 'mercadao_pos_batalha'),
  'mercadao_final_correta': DialogueNode(
    id: 'mercadao_final_correta',
    characterName: 'Dr. Garibaldo',
    text: '...então faça. Retorne ao H15 e interrompa o sistema central.',
    // Ação: Inicia missão de voltar pro H15 para o Epílogo
  ),

  // ==========================================
  // CAPÍTULO VII: O EPÍLOGO (H15)
  // ==========================================
  'epilogo_intro_1': DialogueNode(
    id: 'epilogo_intro_1',
    characterName: 'Sistema',
    text: 'De volta ao H15, o laboratório está totalmente ativo. Os cabos vindos do Mercadão alimentam todas as máquinas.',
    nextNodeId: 'epilogo_intro_2',
  ),
  'epilogo_intro_2': DialogueNode(
    id: 'epilogo_intro_2',
    characterName: 'Dr. Garibaldo',
    text: 'Você venceu o Beta... Mas não venceu o sistema.',
    choices: [
      DialogueChoice(text: 'Isso ainda não acabou.', nextNodeId: 'epilogo_correta'),
      DialogueChoice(text: 'Eu já fiz o suficiente.', nextNodeId: 'epilogo_erro1'),
      DialogueChoice(text: 'Desligue isso agora.', nextNodeId: 'epilogo_erro2'),
    ],
  ),
  'epilogo_erro1': DialogueNode(id: 'epilogo_erro1', characterName: 'Dr. Garibaldo', text: 'Então tudo isso terá sido em vão.', nextNodeId: 'epilogo_intro_2'),
  'epilogo_erro2': DialogueNode(id: 'epilogo_erro2', characterName: 'Dr. Garibaldo', text: 'Se fosse simples assim... eu já teria feito.', nextNodeId: 'epilogo_intro_2'),
  'epilogo_correta': DialogueNode(
    id: 'epilogo_correta',
    characterName: 'Dr. Garibaldo',
    text: 'Se quiser parar tudo... vai precisar quebrar a lógica que mantém isso funcionando. As máquinas começam a se ajustar... tentando se defender.',
    choices: [
      DialogueChoice(text: 'Reorganizar fluxos de energia', nextNodeId: 'epilogo_acao_correta'),
      DialogueChoice(text: 'Sobrecarregar o sistema', nextNodeId: 'epilogo_acao_erro1'),
      DialogueChoice(text: 'Ignorar os alertas', nextNodeId: 'epilogo_acao_erro2'),
    ],
  ),
  'epilogo_acao_erro1': DialogueNode(id: 'epilogo_acao_erro1', characterName: 'Sistema', text: 'Dr. Garibaldo: "Força bruta não resolve lógica." O sistema bloqueia sua ação.', nextNodeId: 'epilogo_correta'),
  'epilogo_acao_erro2': DialogueNode(id: 'epilogo_acao_erro2', characterName: 'Sistema', text: 'O sistema continua operando.', nextNodeId: 'epilogo_correta'),
  'epilogo_acao_correta': DialogueNode(
    id: 'epilogo_acao_correta',
    characterName: 'Sistema',
    text: 'Você reorganiza os fluxos de energia. O sistema foi interrompido... A energia deixa de fluir. O silêncio... finalmente... retorna.',
    nextNodeId: 'epilogo_revelacao',
  ),
  'epilogo_revelacao': DialogueNode(
    id: 'epilogo_revelacao',
    characterName: 'Dr. Garibaldo',
    text: 'Você quebrou a lógica. Beta era a execução perfeita... sem humanidade. Mas você foi a variável que não calculei... espere. Os logs da cápsula de coma... Não foi uma semana.',
    nextNodeId: 'epilogo_revelacao_2',
  ),
  'epilogo_revelacao_2': DialogueNode(
    id: 'epilogo_revelacao_2',
    characterName: 'Dr. Garibaldo',
    text: 'Você esteve dormindo por mais de oitenta anos. O mundo que você conhecia... já não existe mais.',
    choices: [
      DialogueChoice(text: 'O que eu faço agora?', nextNodeId: 'epilogo_fim'),
      DialogueChoice(text: 'Pelo menos os outros estão a salvo.', nextNodeId: 'epilogo_fim'),
      DialogueChoice(text: 'Eu preciso ver com meus próprios olhos.', nextNodeId: 'epilogo_fim'),
    ],
  ),
  'epilogo_fim': DialogueNode(
    id: 'epilogo_fim',
    characterName: 'Sistema',
    text: 'Você percebe que seu trabalho aqui acabou. A ilha agora pertence a eles. Você caminha em direção aos limites da ilha, onde grandes montanhas de gelo aparecem no horizonte. O FIM.',
  ),
};