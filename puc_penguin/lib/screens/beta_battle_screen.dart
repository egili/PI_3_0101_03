import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../providers/game_provider.dart';
import '../providers/mission_provider.dart';

class BetaBattleScreen extends ConsumerStatefulWidget {
  const BetaBattleScreen({super.key});

  @override
  ConsumerState<BetaBattleScreen> createState() => _BetaBattleScreenState();
}

class _BetaBattleScreenState extends ConsumerState<BetaBattleScreen> {
  int _round = 1;
  int _playerTotal = 0;
  int _betaTotal = 0;
  bool _isRolling = false;
  String _message = 'Batalha de Dados Inicializada!';

  void _rollDice() async {
    if (_isRolling) return;

    setState(() {
      _isRolling = true;
      _message = 'Rolando dados...';
    });

    // Simular animação de rolagem
    await Future.delayed(const Duration(milliseconds: 1500));

    final random = Random();
    int playerRoll = random.nextInt(6) + 1;
    int betaRoll = random.nextInt(6) + 1;

    setState(() {
      _playerTotal += playerRoll;
      _betaTotal += betaRoll;
      _isRolling = false;
      _message = 'Você: $playerRoll | Beta: $betaRoll';
    });

    if (_round < 3) {
      _round++;
    } else {
      _determineWinner();
    }
  }

  void _determineWinner() {
    final player = ref.read(playerProvider);
    int finalPlayerScore = _playerTotal;

    // Aplicar modificadores do roteiro
    if (player?.consumedSabotagedFood == true) {
      finalPlayerScore -= 2;
      _message = 'A comida sabotada enfraqueceu seus dados! (-2)';
    } else {
      finalPlayerScore += 2;
      _message = 'Sua integridade biológica fortalece seus dados! (+2)';
    }

    // Nota: A mecânica de "Esperança" (reroll) poderia ser implementada aqui
    // mas para a MVP focaremos na soma final.

    Future.delayed(const Duration(seconds: 2), () {
      if (finalPlayerScore > _betaTotal) {
        _showResult(true);
      } else {
        _showResult(false);
      }
    });
  }

  void _showResult(bool won) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(won ? 'VITÓRIA!' : 'DERROTA'),
        content: Text(won
          ? 'Os resultados fugiram ao padrão estatístico de Beta. Ele foi expurgado!'
          : 'Beta processou sua assinatura de dados e a eliminou. Tente novamente.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (won) {
                ref.read(missionProvider.notifier).concluirMissao('m9_derrotar_beta');
                Navigator.pop(context); // Volta para GameScreen
              } else {
                // Reinicia a batalha
                setState(() {
                  _round = 1;
                  _playerTotal = 0;
                  _betaTotal = 0;
                  _message = 'Tente novamente!';
                });
              }
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050A18),
      body: Stack(
        children: [
          // Fundo digital/estático (simulado com cores)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blueGrey.shade900, Colors.black],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'RODADA $_round / 3',
                  style: const TextStyle(color: Colors.white70, fontSize: 20),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ScoreColumn(label: 'VOCÊ', score: _playerTotal),
                    const Text('VS', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    _ScoreColumn(label: 'BETA', score: _betaTotal),
                  ],
                ),
                const SizedBox(height: 60),
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _isRolling ? null : _rollDice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(_isRolling ? 'PROCESSANDO...' : 'ROLAR DADOS'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  final String label;
  final int score;

  const _ScoreColumn({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text('$score', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
