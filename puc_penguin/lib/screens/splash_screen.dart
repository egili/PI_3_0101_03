import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // Fade in nos primeiros 0.5s
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.15, curve: Curves.easeIn),
      ),
    );

    // Fade out nos últimos 0.5s
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.85, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().then((_) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => widget.nextScreen,
            transitionDuration: Duration.zero,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Durante fade out usa _fadeOut, senão usa _fadeIn
          final opacity = _controller.value < 0.85 ? _fadeIn.value : _fadeOut.value;
          return Opacity(
            opacity: opacity,
            child: child,
          );
        },
        child: SizedBox.expand(
          child: Image.asset(
            'assets/splash/splash_bg.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
