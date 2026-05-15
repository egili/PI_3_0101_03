import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/player.dart';

class FirebaseProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'jogadores';

  // ✅ Não usamos mais Firebase Auth — o deviceId é a chave persistente
  Future<void> garantirAutenticacao() async {
    // Mantido para compatibilidade com home_screen.dart
    debugPrint('ℹ️ Usando deviceId como chave — Auth não necessário');
  }

  Future<void> salvarProgresso({
    required String deviceId,
    required String playerName,
    required String gender,
    required String? currentEnvironmentId,
    required List<String> unlockedEnvironments,
    required List<String> missoesConcluidas,
    required Map<String, String> escolhas,
  }) async {
    try {
      await _firestore.collection(_collection).doc(deviceId).set(
        {
          'playerName': playerName,
          'gender': gender,
          'currentEnvironmentId': currentEnvironmentId,
          'unlockedEnvironments': unlockedEnvironments,
          'missoesConcluidas': missoesConcluidas,
          'escolhas': escolhas,
          'ultimoSalvamento': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      debugPrint('✅ Progresso salvo no Firebase para deviceId: $deviceId');
    } catch (e) {
      debugPrint('❌ Erro ao salvar progresso: $e');
      rethrow;
    }
  }

  Future<void> salvarAmbienteAtual({
    required String deviceId,
    required String? environmentId,
  }) async {
    try {
      await _firestore.collection(_collection).doc(deviceId).set(
        {
          'currentEnvironmentId': environmentId,
          'ultimoSalvamento': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('❌ Erro ao salvar ambiente: $e');
    }
  }

  Future<void> desbloquearAmbiente({
    required String deviceId,
    required String environmentId,
  }) async {
    try {
      await _firestore.collection(_collection).doc(deviceId).set(
        {
          'unlockedEnvironments': FieldValue.arrayUnion([environmentId]),
          'ultimoSalvamento': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      debugPrint('🔓 Ambiente desbloqueado no Firebase: $environmentId');
    } catch (e) {
      debugPrint('❌ Erro ao desbloquear ambiente: $e');
    }
  }

  Future<void> concluirMissao({
    required String deviceId,
    required String missaoId,
  }) async {
    try {
      await _firestore.collection(_collection).doc(deviceId).set(
        {
          'missoesConcluidas': FieldValue.arrayUnion([missaoId]),
          'ultimoSalvamento': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('❌ Erro ao salvar missão: $e');
    }
  }

  Future<bool> canAccessEnvironment(String environmentId) async {
    if (environmentId == 'h15') return true;
    return false;
  }

  Future<bool> canAccessEnvironmentForDevice(
      String deviceId, String environmentId) async {
    try {
      if (environmentId == 'h15') return true;

      final doc =
          await _firestore.collection(_collection).doc(deviceId).get();

      if (doc.exists && doc.data() != null) {
        List<dynamic> unlocked = doc.data()!['unlockedEnvironments'] ?? [];
        return unlocked.contains(environmentId);
      }
      return false;
    } catch (e) {
      debugPrint('❌ Erro ao validar acesso ao ambiente: $e');
      return false;
    }
  }

  Future<void> salvarEscolha({
    required String deviceId,
    required String perguntaId,
    required String resposta,
  }) async {
    try {
      await _firestore.collection(_collection).doc(deviceId).set(
        {
          'escolhas.$perguntaId': resposta,
          'ultimoSalvamento': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('❌ Erro ao salvar escolha: $e');
    }
  }

  // Mantido para compatibilidade com game_service.dart
  Future<void> completeMission(String missionId, String nextEnvId) async {
    debugPrint(
        '⚠️ completeMission sem deviceId — use completeMissionForDevice');
  }

  Future<void> completeMissionForDevice(
      String deviceId, String missionId, String nextEnvId) async {
    try {
      await _firestore.collection(_collection).doc(deviceId).set(
        {
          'missoesConcluidas': FieldValue.arrayUnion([missionId]),
          'unlockedEnvironments': FieldValue.arrayUnion([nextEnvId]),
          'ultimoSalvamento': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      debugPrint('🎯 Missão $missionId finalizada e $nextEnvId liberado.');
    } catch (e) {
      debugPrint('❌ Erro no fluxo de missão/desbloqueio: $e');
    }
  }

  Future<GameProgress?> carregarProgresso(String deviceId) async {
    try {
      final doc =
          await _firestore.collection(_collection).doc(deviceId).get();

      if (!doc.exists || doc.data() == null) {
        debugPrint('ℹ️ Nenhum progresso encontrado para deviceId: $deviceId');
        return null;
      }

      debugPrint('✅ Progresso carregado do Firebase para deviceId: $deviceId');
      return GameProgress.fromMap(doc.data()!);
    } catch (e) {
      debugPrint('❌ Erro ao carregar progresso: $e');
      return null;
    }
  }

  Future<bool> temProgressoSalvo(String deviceId) async {
    try {
      final doc =
          await _firestore.collection(_collection).doc(deviceId).get();
      return doc.exists;
    } catch (e) {
      debugPrint('❌ Erro ao verificar progresso: $e');
      return false;
    }
  }

  Future<void> apagarProgresso(String deviceId) async {
    try {
      await _firestore.collection(_collection).doc(deviceId).delete();
      debugPrint('🗑️ Progresso apagado para deviceId: $deviceId');
    } catch (e) {
      debugPrint('❌ Erro ao apagar progresso: $e');
    }
  }
}

class GameProgress {
  final String playerName;
  final String gender;
  final String? currentEnvironmentId;
  final List<String> unlockedEnvironments;
  final List<String> missoesConcluidas;
  final Map<String, String> escolhas;
  final DateTime? ultimoSalvamento;

  const GameProgress({
    required this.playerName,
    required this.gender,
    this.currentEnvironmentId,
    required this.unlockedEnvironments,
    required this.missoesConcluidas,
    required this.escolhas,
    this.ultimoSalvamento,
  });

  factory GameProgress.fromMap(Map<String, dynamic> map) {
    return GameProgress(
      playerName: map['playerName'] ?? '',
      gender: map['gender'] ?? '',
      currentEnvironmentId: map['currentEnvironmentId'],
      unlockedEnvironments:
          List<String>.from(map['unlockedEnvironments'] ?? ['h15']),
      missoesConcluidas: List<String>.from(map['missoesConcluidas'] ?? []),
      escolhas: Map<String, String>.from(map['escolhas'] ?? {}),
      ultimoSalvamento: (map['ultimoSalvamento'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'gender': gender,
      'currentEnvironmentId': currentEnvironmentId,
      'unlockedEnvironments': unlockedEnvironments,
      'missoesConcluidas': missoesConcluidas,
      'escolhas': escolhas,
    };
  }
}

class GenderHelper {
  static Gender fromString(String value) {
    return Gender.values.firstWhere(
      (g) => g.name == value,
      orElse: () => Gender.male,
    );
  }
}