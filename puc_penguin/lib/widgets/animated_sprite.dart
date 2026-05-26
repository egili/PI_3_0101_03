import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedSprite extends StatefulWidget {
  final List<String> frames;
  final double size;
  final Duration frameDuration;

  const AnimatedSprite({
    super.key,
    required this.frames,
    this.size = 64,
    this.frameDuration = const Duration(milliseconds: 180),
  });

  @override
  State<AnimatedSprite> createState() => _AnimatedSpriteState();
}

class _AnimatedSpriteState extends State<AnimatedSprite> {
  int currentFrame = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(widget.frameDuration, (_) {
      setState(() {
        currentFrame = (currentFrame + 1) % widget.frames.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      widget.frames[currentFrame],
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
    );
  }
}