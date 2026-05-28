import 'package:flutter/material.dart';

/// Tipos de transição disponíveis para navegação entre telas.
enum TransitionType {
  /// Slide da direita para a esquerda (padrão para navegação "em frente")
  slideFromRight,

  /// Slide de baixo para cima (ideal para modais e detalhes)
  slideFromBottom,

  /// Fade simples (suave, para troca de contexto)
  fade,

  /// Fade + scale (dá sensação de "zoom in", ótimo para telas principais)
  fadeScale,
}

/// Cria um [PageRouteBuilder] com a transição desejada.
///
/// Exemplo de uso:
/// ```dart
/// Navigator.push(context, AppTransitions.route(const GameScreen()));
/// Navigator.push(context, AppTransitions.route(const MissionsScreen(), type: TransitionType.slideFromBottom));
/// ```
class AppTransitions {
  AppTransitions._();

  static const Duration _defaultDuration = Duration(milliseconds: 320);

  /// Retorna um [PageRouteBuilder] configurado com a [TransitionType] escolhida.
  static PageRouteBuilder<T> route<T>(
    Widget page, {
    TransitionType type = TransitionType.slideFromRight,
    Duration duration = _defaultDuration,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      reverseTransitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _build(type, animation, secondaryAnimation, child);
      },
    );
  }

  static Widget _build(
    TransitionType type,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (type) {
      case TransitionType.slideFromRight:
        return _slideFromRight(animation, secondaryAnimation, child);
      case TransitionType.slideFromBottom:
        return _slideFromBottom(animation, child);
      case TransitionType.fade:
        return _fade(animation, child);
      case TransitionType.fadeScale:
        return _fadeScale(animation, child);
    }
  }

  // ── Slide da direita ──────────────────────────────────────────────────────

  static Widget _slideFromRight(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    final tween = Tween(
      begin: begin,
      end: end,
    ).chain(CurveTween(curve: Curves.easeOutCubic));
    // A tela anterior desliza levemente para a esquerda ao sair
    final secondaryTween = Tween(
      begin: Offset.zero,
      end: const Offset(-0.25, 0.0),
    ).chain(CurveTween(curve: Curves.easeOutCubic));

    return SlideTransition(
      position: secondaryAnimation.drive(secondaryTween),
      child: SlideTransition(position: animation.drive(tween), child: child),
    );
  }

  // ── Slide de baixo ────────────────────────────────────────────────────────

  static Widget _slideFromBottom(Animation<double> animation, Widget child) {
    final tween = Tween(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutQuart));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  // ── Fade ──────────────────────────────────────────────────────────────────

  static Widget _fade(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
      child: child,
    );
  }

  // ── Fade + Scale ──────────────────────────────────────────────────────────

  static Widget _fadeScale(Animation<double> animation, Widget child) {
    final fadeTween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).chain(CurveTween(curve: const Interval(0.0, 0.6, curve: Curves.easeOut)));
    final scaleTween = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).chain(CurveTween(curve: Curves.easeOutCubic));

    return FadeTransition(
      opacity: animation.drive(fadeTween),
      child: ScaleTransition(scale: animation.drive(scaleTween), child: child),
    );
  }
}
