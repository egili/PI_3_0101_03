import '../models/dialogue.dart';

final Map<String, DialogueNode> gameScript = {
  'h15_intro_1': DialogueNode(
    id: 'h15_intro_1',
    characterName: 'Dr. Garibaldo',
    text: 'Você acordou! Excelente! Quer dizer... dentro de uma margem aceitável... talvez nem tanto... eu já estava considerando uma falha no protocolo o que seria ruim. Muito ruim. Como você está se sentindo?',
    nextNodeId: 'h15_intro_2',
  ),
  'h15_intro_2': DialogueNode(
    id: 'h15_intro_2',
    characterName: 'Bibliotecário',
    text: 'E-ele está mesmo bem? Isso parece... errado...',
    choices: [
      DialogueChoice(text: 'O que aconteceu aqui?', nextNodeId: 'h15_opt_1'),
      DialogueChoice(text: 'Quem são vocês?', nextNodeId: 'h15_opt_2'),
      DialogueChoice(text: 'Eu vou embora daqui.', nextNodeId: 'h15_opt_3'),
    ],
  ),
  'h15_opt_1': DialogueNode(
    id: 'h15_opt_1',
    characterName: 'Dr. Garibaldo',
    text: 'Direto ao ponto! Ótimo! Quer dizer... não ótimo, porque a situação não é ótima... mas eficiente. A ilha foi atacada.',
  ),
  'h15_opt_2': DialogueNode(
    id: 'h15_opt_2',
    characterName: 'Dr. Garibaldo',
    text: 'Ah! Sim, apresentações! Eu sou o Dr. Garibaldo Pingulino, cientista-chefe deste laboratório! E ele é o Bibliotecário... que claramente não deveria estar aqui.',
    nextNodeId: 'h15_intro_2', 
  ),
  'h15_opt_3': DialogueNode(
    id: 'h15_opt_3',
    characterName: 'Dr. Garibaldo',
    text: 'Não recomendo. Lá fora está... instável. E perigoso. Você precisa entender o que está acontecendo antes.',
    nextNodeId: 'h15_intro_2', 
  ),
};