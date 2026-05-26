class DialogueChoice {
  final String text;
  final String? nextNodeId;
  final Function()? onSelect;

  DialogueChoice({required this.text, this.nextNodeId, this.onSelect});
}

class DialogueNode {
  final String id;
  final String characterName;
  final String text;
  final List<DialogueChoice> choices;
  final String? nextNodeId;

  DialogueNode({
    required this.id,
    required this.characterName,
    required this.text,
    this.choices = const [],
    this.nextNodeId,
  });
}