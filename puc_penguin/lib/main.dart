import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/map_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/tutorial_screen.dart';
import 'services/auth_service.dart';
import 'utils/app_router.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await AuthService.signInAnon();
  } catch (e) {
    debugPrint('Firebase não inicializado: $e');
  }

  FlutterNativeSplash.remove();

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
    // Reaplicar aqui garante que vale após o MaterialApp ser construído
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: MaterialApp(
        title: 'PUC Penguin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: SplashScreen(nextScreen: const RootScreen()),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sempre abre o HomeScreen.
    // "Novo Jogo"    → HomeScreen navega para OnboardingScreen
    // "Continuar"    → HomeScreen carrega o save e vai para GameScreen
    return const HomeScreen();
  }
}
