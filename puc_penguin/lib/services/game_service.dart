import 'package:geolocator/geolocator.dart';
import '../constants/environments.dart';
import '../models/environment.dart';
import 'storage_service.dart';
import 'location_service.dart';
import 'firebase_progress_service.dart';

class GameService {
  final StorageService _storageService = StorageService();
  final LocationService _locationService = LocationService();
  final FirebaseProgressService _firebaseService;
  final dynamic _uiService;

  GameService(this._firebaseService, this._uiService);

  final Map<String, String> _regrasProgresso = {
    'm1_bibliotecario': 'biblioteca',
    'm3_enfermeira': 'manacas',
    'm6_truffles': 'mescla',
    'm7_investigacao': 'refeitorio',
  };

  Future<List<Environment>> getEnvironmentsWithProgress() async {
    final unlockedIds = await _storageService.loadUnlockedEnvironments();
    final all = staticEnvironments;

    return all.map((env) {
      final isUnlocked = unlockedIds.contains(env.id);
      return env.copyWith(isUnlocked: isUnlocked);
    }).toList();
  }

  Future<bool> validarAcessoAmbiente(Environment env, dynamic userPos) async {
    bool liberado = await _firebaseService.canAccessEnvironment(env.id);

    if (!liberado) {
      _uiService.showError("Este local ainda está inacessível. Progrida na história!");
      return false;
    }

    // Corrigido: usa latitude/longitude separados + Geolocator no lugar de checkProximity/coordinates
    double distancia = Geolocator.distanceBetween(
      userPos.latitude,
      userPos.longitude,
      env.latitude,
      env.longitude,
    );

    bool isInsideRange = distancia <= env.radius;

    if (!isInsideRange) {
      _uiService.showError("Você precisa estar fisicamente no local para interagir.");
      return false;
    }

    return true;
  }

  Future<void> finalizarMissaoETrajeto(String missionId, String deviceId) async {
    await _firebaseService.concluirMissao(deviceId: deviceId, missaoId: missionId);

    String? ambienteParaDesbloquear = _regrasProgresso[missionId];

    if (ambienteParaDesbloquear != null) {
      await _firebaseService.completeMission(missionId, ambienteParaDesbloquear);
      await unlockEnvironment(ambienteParaDesbloquear, deviceId);

      _uiService.showSuccess("Novo ambiente desbloqueado no seu mapa!");
    }
  }

  Future<bool> unlockEnvironment(String environmentId, String deviceId) async {
    final unlocked = await _storageService.loadUnlockedEnvironments();

    if (unlocked.contains(environmentId)) return false;

    unlocked.add(environmentId);
    await _storageService.saveUnlockedEnvironments(unlocked);

    await _firebaseService.desbloquearAmbiente(
        deviceId: deviceId, environmentId: environmentId);

    return true;
  }

  void testarFluxoCompleto(String deviceId) async {
    print("Iniciando Teste de Progressão...");
    await finalizarMissaoETrajeto('m1_bibliotecario', deviceId);
    bool status = await _firebaseService.canAccessEnvironment('biblioteca');
    print("Teste - Biblioteca Desbloqueada: $status");
  }

  Future<bool> isEnvironmentUnlocked(String environmentId) async {
    final unlocked = await _storageService.loadUnlockedEnvironments();
    return unlocked.contains(environmentId);
  }

  void handleEnvironmentInteraction(
      Environment env, dynamic userPos, String deviceId) async {
    bool acessoPermitido = await validarAcessoAmbiente(env, userPos);
    if (acessoPermitido) {
      startNarrative(env.id);
    }
  }

  Future<Map<String, dynamic>?> loadGameProgress() async {
    final hasGame = await _storageService.hasSavedGame();
    if (!hasGame) return null;

    return {
      'playerName': await _storageService.loadPlayerName(),
      'playerGender': await _storageService.loadPlayerGender(),
      'unlockedEnvironments': await _storageService.loadUnlockedEnvironments(),
    };
  }

  Future<void> saveVisit({
    required String playerName,
    required String gender,
    required String environmentId,
    required String deviceId,
  }) async {
    await _storageService.savePlayerName(playerName);
    await _storageService.savePlayerGender(gender);
    await unlockEnvironment(environmentId, deviceId);
  }

  void startNarrative(String envId) {
    print("Iniciando narrativa de $envId");
  }
}