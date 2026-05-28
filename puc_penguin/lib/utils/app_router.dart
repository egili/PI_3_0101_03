import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/game_screen.dart';
import '../screens/map_screen.dart';
import '../screens/missions_screen.dart';
import '../screens/environments_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/tutorial_screen.dart';
import 'transitions.dart';

/// Nomes de rotas centralizados — evite strings espalhadas pelo código.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String game = '/game';
  static const String map = '/map';
  static const String missions = '/missions';
  static const String environments = '/environments';
  static const String tutorial = '/tutorial';
}

/// Roteador central do aplicativo.
///
/// Registre aqui todas as rotas e suas transições. Para navegar, use:
/// ```dart
/// Navigator.pushNamed(context, AppRoutes.game);
/// Navigator.pushNamed(context, AppRoutes.missions);
/// ```
class AppRouter {
  AppRouter._();

  /// Mapeamento de rota → transição escolhida.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return AppTransitions.route(
          const HomeScreen(),
          type: TransitionType.fadeScale,
          settings: settings,
        );

      case AppRoutes.onboarding:
        return AppTransitions.route(
          const OnboardingScreen(),
          type: TransitionType.fade,
          settings: settings,
        );

      case AppRoutes.tutorial:
        return AppTransitions.route(
          const TutorialScreen(),
          type: TransitionType.fade,
          settings: settings,
        );

      case AppRoutes.game:
        return AppTransitions.route(
          const GameScreen(),
          type: TransitionType.slideFromRight,
          settings: settings,
        );

      case AppRoutes.map:
        return AppTransitions.route(
          const MapScreen(),
          type: TransitionType.slideFromBottom,
          settings: settings,
        );

      case AppRoutes.missions:
        return AppTransitions.route(
          const MissionsScreen(),
          type: TransitionType.slideFromRight,
          settings: settings,
        );

      case AppRoutes.environments:
        return AppTransitions.route(
          const EnvironmentsScreen(),
          type: TransitionType.slideFromRight,
          settings: settings,
        );

      default:
        // Rota desconhecida — mostra tela de erro simples
        return AppTransitions.route(
          Scaffold(
            body: Center(child: Text('Rota não encontrada: ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }
}
