import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../providers/player_provider.dart';
import '../services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  Gender? _selectedGender;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _completeOnboarding(WidgetRef ref) async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o nome do seu pinguim')),
      );
      return;
    }

    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um gênero')),
      );
      return;
    }

    final player = Player(name: name, gender: _selectedGender!);

    // Salva e atualiza o estado global
    await ref.read(playerProvider.notifier).setPlayer(player);

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

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
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Pinguim',
                    border: OutlineInputBorder(),
                    hintText: 'Ex: Pinguim Gelado',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                const Text('Gênero:'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('Masculino'),
                      selected: _selectedGender == Gender.male,
                      onSelected: (selected) {
                        setState(() {
                          _selectedGender = selected ? Gender.male : null;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('Feminino'),
                      selected: _selectedGender == Gender.female,
                      onSelected: (selected) {
                        setState(() {
                          _selectedGender = selected ? Gender.female : null;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => _completeOnboarding(ref),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
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
