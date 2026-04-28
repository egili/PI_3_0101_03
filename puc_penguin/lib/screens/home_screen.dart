import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),

              // 🔹 LOGO + TEXTO
              Column(
                children: [
                  SizedBox(
                    width: size.width * 0.4,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: size.width * 0.4,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  Text(
                    AppText.welcome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSizes.textExtraLarge,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              // 🔹 BOTÕES
              Column(
                children: [
                  _buildButton(
                    text: AppText.startGame,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GameScreen()),
                      );
                    },
                  ),

                  SizedBox(height: size.height * 0.02),

                  _buildButton(
                    text: AppText.continueGame,
                    isSecondary: true,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(AppText.noSave)),
                      );
                    },
                  ),
                ],
              ),

              // 🔹 RODAPÉ
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.02),
                child: Text(
                  "© 2026 PUC Penguin - Grupo 03",
                  style: TextStyle(
                    fontSize: AppSizes.textLarge,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    bool isSecondary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary
              ? AppColors.buttonSecondary
              : AppColors.buttonPrimary,
          foregroundColor: isSecondary ? AppColors.textPrimary : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
