import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mission_provider.dart';

class H15PuzzleScreen extends ConsumerStatefulWidget {
  const H15PuzzleScreen({super.key});

  @override
  ConsumerState<H15PuzzleScreen> createState() => _H15PuzzleScreenState();
}

class _H15PuzzleScreenState extends ConsumerState<H15PuzzleScreen> {
  // Estado dos disjuntores (true = ativo/estável, false = inativo/instável)
  // O objetivo é deixar todos em 'false' para causar o colapso do sistema
  final List<bool> _switches = [true, true, true, true];
  final List<List<int>> _connections = [
    [0, 1], // Alternar 0 altera 1
    [1, 2], // Alternar 1 altera 2
    [2, 3], // Alternar 2 altera 3
    [3, 0], // Alternar 3 altera 0
  ];

  void _toggleSwitch(int index) {
    setState(() {
      // Inverte o estado do switch clicado
      _switches[index] = !_switches[index];

      // Inverte os estados dos conectados
      for (var connection in _connections) {
        if (connection.contains(index)) {
          int other = connection[0] == index ? connection[1] : connection[0];
          _switches[other] = !_switches[other];
        }
      }
    });

    _checkVictory();
  }

  void _checkVictory() {
    if (_switches.every((s) => s == false)) {
      Future.delayed(const Duration(milliseconds: 500), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('SISTEMA COLAPSADO'),
            content: const Text('Você conseguiu desestabilizar as matrizes lógicas do reator central!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(missionProvider.notifier).concluirMissao('m10_interromper_sistema');
                  Navigator.pop(context); // Volta para GameScreen
                },
                child: const Text('Concluir'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        title: const Text('Reator Central H15'),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'DESESTABILIZE OS FLUXOS',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 10),
          const Text(
            'Desative todos os disjuntores para causar o colapso.',
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: List.generate(4, (index) {
              return GestureDetector(
                onTap: () => _toggleSwitch(index),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _switches[index] ? Colors.blue : Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: _switches[index] ? Colors.blue.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _switches[index] ? 'ATIVO' : 'OFF',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 60),
          const Text(
            'AVISO: INTERFERÊNCIA LÓGICA DETECTADA',
            style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
