import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';

/// Provedor de estado para o perfil do jogador atual.
final playerProvider = StateProvider<<<PlayerPlayerPlayer?>((ref) => null);

/// Provedor de estado para o ID do ambiente detectado no momento.
final currentEnvironmentIdProvider = StateProvider<<<StringStringString?>((ref) => null);

/// Provedor de estado para a lista de IDs de ambientes desbloqueados.
final unlockedEnvironmentsProvider = StateProvider<<<ListListList<<<StringStringString>>((ref) => ['h15']);