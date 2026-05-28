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
  Function()? _onComplete;

  @override
  DialogueNode? build() => null;

  void startDialogue(String startNodeId, {Function()? onComplete}) {
    _onComplete = onComplete;
    state = gameScript[startNodeId];
  }

  void next() {
    if (state?.nextNodeId != null) {
      state = gameScript[state!.nextNodeId!];
    } else {
      _finishDialogue();
    }
  }

  void makeChoice(DialogueChoice choice) {
    if (choice.onSelect != null) choice.onSelect!();
    if (choice.nextNodeId != null) {
      state = gameScript[choice.nextNodeId!];
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
    state = null;
    if (wasCorrectEnding) {
      final callback = _onComplete;
      _onComplete = null;
      callback?.call();
    } else {
      _onComplete = null;
    }
  }
}

final dialogueProvider = NotifierProvider<DialogueNotifier, DialogueNode?>(
  DialogueNotifier.new,
);