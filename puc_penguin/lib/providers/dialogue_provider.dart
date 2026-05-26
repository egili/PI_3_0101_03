import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dialogue.dart';
import '../constants/script.dart';

class DialogueNotifier extends Notifier<DialogueNode?> {
  @override
  DialogueNode? build() => null; 

  void startDialogue(String startNodeId) {
    state = gameScript[startNodeId];
  }

  void next() {
    if (state?.nextNodeId != null) {
      state = gameScript[state!.nextNodeId];
    } else {
      closeDialogue();
    }
  }

  void makeChoice(DialogueChoice choice) {
    if (choice.onSelect != null) {
      choice.onSelect!(); 
    }
    
    if (choice.nextNodeId != null) {
      state = gameScript[choice.nextNodeId];
    } else {
      closeDialogue();
    }
  }

  void closeDialogue() {
    state = null;
  }
}

final dialogueProvider = NotifierProvider<DialogueNotifier, DialogueNode?>(
  DialogueNotifier.new,
);