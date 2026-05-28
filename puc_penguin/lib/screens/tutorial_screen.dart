import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/app_router.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<TutorialPage> _pages = [
    TutorialPage(
      title: 'Bem-vindo ao PUC Penguin!',
      description: 'Prepare-se para explorar a universidade e descobrir segredos escondidos em cada canto.',
      icon: Icons.cruelty_free,
      color: Colors.blue.shade100,
    ),
    TutorialPage(
      title: 'Siga o GPS',
      description: 'Para desbloquear novos ambientes, você precisa fisicamente chegar às coordenadas indicadas. O GPS do seu celular é a sua bússola!',
      icon: Icons.location_on,
      color: Colors.green.shade100,
    ),
    TutorialPage(
      title: 'Complete Missões',
      description: 'Cada ambiente possui missões únicas. Complete-as para ganhar experiência e progredir na sua jornada.',
      icon: Icons.assignment,
      color: Colors.orange.shade100,
    ),
    TutorialPage(
      title: 'Tudo Pronto!',
      description: 'Agora que você sabe como funciona, vamos começar a exploração!',
      icon: Icons.rocket_launch,
      color: Colors.purple.shade100,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _finishTutorial();
    }
  }

  void _finishTutorial() async {
    await StorageService().saveTutorialSeen();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.game);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                final page = _pages[index];
                return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: page.color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(page.icon, size: 80, color: Colors.blue.shade900),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        page.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        page.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dots indicator
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.blue : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(_currentPage == _pages.length - 1 ? 'Começar!' : 'Próximo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  TutorialPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
