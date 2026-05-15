import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/map_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await AuthService.signInAnon();

  } catch (e) {
    debugPrint('Firebase não inicializado: $e');
  }

  runApp(
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
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/onboarding': (context) => const Scaffold(
              body: Center(
                child: Text('Onboarding em desenvolvimento'),
              ),
            ),
        '/': (context) => const HomeScreen(),
        '/game': (context) => const GameScreen(),
        '/map': (context) => const MapScreen(),
      },
    );
  }
}