class DialogueNode {
  final String id;
  final String characterName;
  final String text;
  final String? nextNodeId;
  final List<DialogueChoice> choices;

  const DialogueNode({
    required this.id,
    required this.characterName,
    required this.text,
    this.nextNodeId,
    this.choices = const [],
  });
}

class DialogueChoice {
  final String text;
  final String? nextNodeId;
  final void Function()? onSelect;

  const DialogueChoice({
    required this.text,
    this.nextNodeId,
    this.onSelect,
  });
}
