import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'QUEM É VOCÊ?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Nome do Pinguim',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // We'll use a temporary state or controller here
                  },
                ),
                const SizedBox(height: 20),
                const Text('Gênero:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('Masculino'),
                      selected: false, // Needs local state
                      onSelected: (val) {},
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('Feminino'),
                      selected: false, // Needs local state
                      onSelected: (val) {},
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Finalize profile and move to home
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const Text('Começar Jornada'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
