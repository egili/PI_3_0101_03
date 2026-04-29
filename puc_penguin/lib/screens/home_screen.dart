import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PUC Penguin'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Iniciar Jogo'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const GameScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}