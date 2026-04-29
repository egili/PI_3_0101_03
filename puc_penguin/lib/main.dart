import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(
    // ProviderScope é OBRIGATÓRIO para o Riverpod funcionar.
    // Ele envolve todo o app e gerencia o ciclo de vida dos providers.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PUC Penguin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Definimos as rotas nomeadas aqui para poder usar
      // Navigator.of(context).pushReplacementNamed('/game')
      // em qualquer tela sem precisar importar as outras telas
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/game': (context) => const GameScreen(),
        '/map': (context) => const MapScreen(),
      },
    );
  }
}
