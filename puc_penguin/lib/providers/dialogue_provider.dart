import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dialogue.dart';
import '../constants/script.dart';

// Nós finais corretos de cada arco — disparam onComplete ao fechar
const _finalNodes = {
  'h15_mission_end',
  'biblio_joycelina_4',
  'hosp_recalibra_6',
  'oficina_concluir_3',
  'mercadao_batalha_inicio',
  'h15_final_fim',
};

class DialogueNotifier extends Notifier<DialogueNode?> {
  Function()? _onComplete;
  String _playerName = '';

  @override
  DialogueNode? build() => null;

  /// Define o nome do jogador para substituição de {nome} nas falas
  void setPlayerName(String name) {
    _playerName = name;
  }

  void startDialogue(String startNodeId, {Function()? onComplete}) {
    _onComplete = onComplete;
    final raw = gameScript[startNodeId];
    state = raw != null ? _applyName(raw) : null;
  }

  void next() {
    if (state?.nextNodeId != null) {
      final raw = gameScript[state!.nextNodeId!];
      state = raw != null ? _applyName(raw) : null;
      if (state == null) _finishDialogue(previousId: state?.id);
    } else {
      _finishDialogue(previousId: state?.id);
    }
  }

  void makeChoice(DialogueChoice choice) {
    if (choice.onSelect != null) choice.onSelect!();
    if (choice.nextNodeId != null) {
      final raw = gameScript[choice.nextNodeId!];
      state = raw != null ? _applyName(raw) : null;
      if (state == null) _finishDialogue(previousId: choice.nextNodeId);
    } else {
      _finishDialogue(previousId: state?.id);
    }
  }

  void closeDialogue() {
    _onComplete = null;
    state = null;
  }

  // ── internos ──────────────────────────────────────────────────────────────

  /// Substitui {nome} no texto e nas opções do nó
  DialogueNode _applyName(DialogueNode node) {
    if (_playerName.isEmpty || !node.text.contains('{nome}')) return node;
    final newText = node.text.replaceAll('{nome}', _playerName);
    return DialogueNode(
      id: node.id,
      characterName: node.characterName,
      text: newText,
      nextNodeId: node.nextNodeId,
      choices: node.choices,
    );
  }

  void _finishDialogue({String? previousId}) {
    final lastId = previousId ?? state?.id;
    final wasCorrectEnding = lastId != null && _finalNodes.contains(lastId);
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
