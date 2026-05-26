import 'dart:async';
import 'package:flutter/material.dart';
import '../models/dialogue.dart';

class DialogBox extends StatefulWidget {
  final DialogueNode node;
  final VoidCallback onNext;
  final Function(DialogueChoice) onChoiceSelected;

  const DialogBox({
    super.key,
    required this.node,
    required this.onNext,
    required this.onChoiceSelected,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  String _displayedText = "";
  Timer? _timer;
  int _currentIndex = 0;
  bool _isTyping = true;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(DialogBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.node.id != widget.node.id) {
      _startTyping();
    }
  }

  void _startTyping() {
    _timer?.cancel();
    setState(() {
      _displayedText = "";
      _currentIndex = 0;
      _isTyping = true;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_currentIndex < widget.node.text.length) {
        setState(() {
          _displayedText += widget.node.text[_currentIndex];
          _currentIndex++;
        });
      } else {
        _finishTyping();
      }
    });
  }

  void _finishTyping() {
    _timer?.cancel();
    setState(() {
      _displayedText = widget.node.text;
      _isTyping = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasChoices = widget.node.choices.isNotEmpty;

    return GestureDetector(
      onTap: _isTyping ? _finishTyping : (hasChoices ? null : widget.onNext),
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2340).withOpacity(0.95),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFF4A90E2), width: 2.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.node.characterName.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF4A90E2),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _displayedText,
              style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            
            if (!_isTyping && hasChoices)
              Column(
                children: widget.node.choices.map((choice) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF054C94),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () => widget.onChoiceSelected(choice),
                      child: Text(choice.text),
                    ),
                  );
                }).toList(),
              ),

            if (!_isTyping && !hasChoices)
              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.arrow_drop_down_circle, color: Colors.white54, size: 24),
              ),
          ],
        ),
      ),
    );
  }
}