import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dialogue.dart';
import '../constants/script.dart';

// Nós finais corretos de cada arco — disparam onComplete ao fechar
const _finalNodes = {
  'h15_intro_13',
  'biblio_joycelina_4',
  'hosp_recalibra_6',
  'oficina_concluir_3',
  'mercadao_batalha_inicio',
};

class DialogueNotifier extends Notifier<DialogueNode?> {
  Function(String)? _onComplete;
  String _playerName = 'Jogador';

  @override
  DialogueNode? build() => null;

  void setPlayerName(String name) {
    _playerName = name;
  }

  DialogueNode _injectName(DialogueNode node) {
    if (!node.text.contains('{nome}')) return node;
    return DialogueNode(
      id: node.id,
      characterName: node.characterName,
      text: node.text.replaceAll('{nome}', _playerName),
      nextNodeId: node.nextNodeId,
      choices: node.choices,
    );
  }

  void startDialogue(String startNodeId, {Function(String)? onComplete}) {
    _onComplete = onComplete;
    final node = gameScript[startNodeId];
    state = node != null ? _injectName(node) : null;
  }

  void next() {
    if (state?.nextNodeId != null) {
      final node = gameScript[state!.nextNodeId!];
      state = node != null ? _injectName(node) : null;
    } else {
      _finishDialogue();
    }
  }

  void makeChoice(DialogueChoice choice) {
    if (choice.onSelect != null) choice.onSelect!();
    if (choice.nextNodeId != null) {
      final node = gameScript[choice.nextNodeId!];
      state = node != null ? _injectName(node) : null;
    } else {
      _finishDialogue();
    }
  }

  void closeDialogue() {
    _onComplete = null;
    state = null;
  }

  void _finishDialogue() {
    final wasCorrectEnding = state != null && _finalNodes.contains(state!.id);
    final nodeId = state?.id;
    state = null;
    if (wasCorrectEnding) {
      final callback = _onComplete;
      _onComplete = null;
      callback?.call(nodeId ?? '');
    } else {
      _onComplete = null;
    }
  }
}

final dialogueProvider = NotifierProvider<DialogueNotifier, DialogueNode?>(
  DialogueNotifier.new,
);
