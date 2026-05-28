import 'dart:async';
import 'package:flutter/material.dart';
import '../models/dialogue.dart';

const _npcNames = {
  'Dr. Garibaldo',
  'Sr. Niyagi',
  'Bibliotecário',
  'Enfermeira',
  'Enfermeira Joycelina',
  'Truffles',
  'Chef Frigelino',
  'Buffles Cozinheiro',
  'Beta',
  'Narrador',
  'Sistema',
};

const Map<String, String> _characterSprites = {
  'Dr. Garibaldo'       : 'assets/npcs/Pingulino/Pingulino.png',
  'Sr. Niyagi'          : 'assets/npcs/Niyagi/Niyagi.png',
  'Bibliotecário'       : 'assets/npcs/Niyagi/Niyagi.png',
  'Enfermeira'          : 'assets/npcs/Joycelina/Joycelina.png',
  'Enfermeira Joycelina': 'assets/npcs/Joycelina/Joycelina.png',
  'Truffles'            : 'assets/npcs/Truffles/Truffles.png',
  'Chef Frigelino'      : 'assets/npcs/Frigelino/Frigelino.png',
  'Buffles Cozinheiro'  : 'assets/npcs/Buffles/Buffles.png',
  'Beta'                : 'assets/npcs/Buffles/Buffles.png',
};

const String _playerSprite = 'assets/player/idle/Player.png';

class DialogBox extends StatefulWidget {
  final DialogueNode node;
  final VoidCallback onNext;
  final Function(DialogueChoice) onChoiceSelected;
  final String? npcSprite;
  final String? playerSprite;

  const DialogBox({
    super.key,
    required this.node,
    required this.onNext,
    required this.onChoiceSelected,
    this.npcSprite,
    this.playerSprite,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox>
    with SingleTickerProviderStateMixin {
  String _displayedText = '';
  Timer? _timer;
  int _currentIndex = 0;
  bool _isTyping = true;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
    _startTyping();
  }

  @override
  void didUpdateWidget(DialogBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.node.id != widget.node.id) _startTyping();
  }

  void _startTyping() {
    _timer?.cancel();
    setState(() {
      _displayedText = '';
      _currentIndex = 0;
      _isTyping = true;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 28), (timer) {
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
    _bounceController.dispose();
    super.dispose();
  }

  bool get _isPlayerSpeaking => !_npcNames.contains(widget.node.characterName);
  bool get _isSystemNode => widget.node.characterName == 'Sistema' || widget.node.characterName == 'Narrador';

  String _resolveNpcSprite() {
    return _characterSprites[widget.node.characterName] ??
        widget.npcSprite ??
        'assets/npcs/Pingulino/Pingulino.png';
  }

  @override
  Widget build(BuildContext context) {
    final hasChoices = widget.node.choices.isNotEmpty;
    final isPlayer = _isPlayerSpeaking;
    final npcSprite = _resolveNpcSprite();
    final resolvedPlayerSprite = widget.playerSprite ?? _playerSprite;
    final screenW = MediaQuery.of(context).size.width;

    // Tamanhos responsivos baseados na largura da tela
    final activeSize  = screenW * 0.30; // ~30% da tela = ~115px em 390px
    final inactiveSize = screenW * 0.22; // ~22% da tela = ~86px

    return GestureDetector(
      onTap: _isTyping ? _finishTyping : (hasChoices ? null : widget.onNext),
      child: Container(
        color: const Color(0xFF0A1220),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Sprites ──────────────────────────────────────────────────
            if (!_isSystemNode)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // NPC (esquerda)
                    _SpritePortrait(
                      imagePath: npcSprite,
                      isActive: !isPlayer,
                      flipHorizontal: false,
                      activeSize: activeSize,
                      inactiveSize: inactiveSize,
                    ),
                    // Jogador (direita)
                    _SpritePortrait(
                      imagePath: resolvedPlayerSprite,
                      isActive: isPlayer,
                      flipHorizontal: true,
                      activeSize: activeSize,
                      inactiveSize: inactiveSize,
                    ),
                  ],
                ),
              ),

            // ── Caixa de texto ────────────────────────────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1526).withOpacity(0.97),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF4A90E2), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(
                          color: _isSystemNode
                              ? Colors.amber
                              : isPlayer
                                  ? const Color(0xFF7ED6FF)
                                  : const Color(0xFF4A90E2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.node.characterName.toUpperCase(),
                        style: TextStyle(
                          color: _isSystemNode
                              ? Colors.amber
                              : isPlayer
                                  ? const Color(0xFF7ED6FF)
                                  : const Color(0xFF4A90E2),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _displayedText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (!_isTyping && hasChoices)
                    Column(
                      children: widget.node.choices.map((choice) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F2D5A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 14),
                              alignment: Alignment.centerLeft,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                    color: Color(0xFF2A5FA8)),
                              ),
                            ),
                            onPressed: () => widget.onChoiceSelected(choice),
                            child: Text(choice.text,
                                style: const TextStyle(fontSize: 14)),
                          ),
                        );
                      }).toList(),
                    ),

                  if (!_isTyping && !hasChoices)
                    AnimatedBuilder(
                      animation: _bounceAnim,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, _bounceAnim.value),
                        child: const Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Icons.keyboard_double_arrow_down_rounded,
                            color: Color(0xFF4A90E2),
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Retrato do personagem ─────────────────────────────────────────────────────

class _SpritePortrait extends StatelessWidget {
  final String imagePath;
  final bool isActive;
  final bool flipHorizontal;
  final double activeSize;
  final double inactiveSize;

  const _SpritePortrait({
    required this.imagePath,
    required this.isActive,
    required this.flipHorizontal,
    required this.activeSize,
    required this.inactiveSize,
  });

  @override
  Widget build(BuildContext context) {
    final size = isActive ? activeSize : inactiveSize;
    final height = size * 1.25; // altura ligeiramente maior que a largura

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: size,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFF4A90E2).withOpacity(0.55),
                  blurRadius: 20,
                  spreadRadius: 3,
                )
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ColorFiltered(
          colorFilter: isActive
              ? const ColorFilter.mode(
                  Colors.transparent, BlendMode.multiply)
              : ColorFilter.mode(
                  Colors.black.withOpacity(0.55), BlendMode.darken),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..scale(flipHorizontal ? -1.0 : 1.0, 1.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.blueGrey.shade800,
                child: const Icon(Icons.person,
                    color: Colors.white54, size: 40),
              ),
            ),
          ),
        ),
      ),
    );
  }
}