import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para rastrear qual NPC está acompanhando o jogador no momento.
/// Nulo se o jogador estiver sozinho.
final companionProvider = StateProvider<String?>((ref) {
  return null;
});
