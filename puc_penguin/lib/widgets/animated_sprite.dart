import 'package:flutter/material.dart';

/// Widget simples que exibe um sprite estático.
/// Preparado para suportar animações no futuro com múltiplos frames.
class AnimatedSprite extends StatelessWidget {
  final List<String> frames;
  final double size;

  const AnimatedSprite({
    super.key,
    required this.frames,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (frames.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        frames.first,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.person,
            color: Colors.white38,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
