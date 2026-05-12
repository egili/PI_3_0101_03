import '../constants/environments.dart';
import '../models/environment.dart';
import 'storage_service.dart';
import 'location_service.dart'; 
import 'firebase_progress_service.dart'; 

/// Serviço com as regras de negócio do jogo.
/// Gerencia o Sistema de Desbloqueio e a validação de acesso.
class GameService {
  final StorageService _storageService = StorageService();
  final LocationService _locationService = LocationService();
  final FirebaseProgressService _firebaseService; 
  final dynamic _uiService; 

  GameService(this._firebaseService, this._uiService);

  /// 1. DEFINIR REGRAS DE DESBLOQUEIO
  /// Mapeamento oficial: Missão concluída libera o próximo ID de ambiente.
  final Map<String, String> _regrasProgresso = {
    'm1_bibliotecario': 'biblioteca',
    'm3_enfermeira': 'manacas',
    'm6_truffles': 'mescla',
    'm7_investigacao': 'refeitorio',
  };

  /// Retorna todos os ambientes, marcando quais estão desbloqueados
  Future<List<Environment>> getEnvironmentsWithProgress() async {
    final unlockedIds = await _storageService.loadUnlockedEnvironments();
    final all = staticEnvironments; 

    return all.map((env) {
      final isUnlocked = unlockedIds.contains(env.id);
      return env.copyWith(isUnlocked: isUnlocked);
    }).toList();
  }

  /// 2. IMPLEMENTAR VALIDAÇÃO DE ACESSO / 3. BLOQUEAR AMBIENTES
  Future<bool> validarAcessoAmbiente(Environment env, dynamic userPos) async {
    // RF03: Bloqueio por regra de negócio (isUnlocked) no Firebase
    bool liberado = await _firebaseService.canAccessEnvironment(env.id);
    
    if (!liberado) {
      _uiService.showError("Este local ainda está inacessível. Progrida na história!");
      return false;
    }

    // RF01/RF02: Validação por proximidade física (Raio de 10-30m)
    bool isInsideRange = _locationService.checkProximity(userPos, env.coordinates);
    if (!isInsideRange) {
      _uiService.showError("Você precisa estar fisicamente no local para interagir.");
      return false;
    }

    return true; 
  }

  /// 4. LIBERAR AMBIENTES APÓS MISSÃO
  /// Atualiza o status e desbloqueia o próximo ambiente no fluxo.
  Future<void> finalizarMissaoETrajeto(String missionId, String deviceId) async {
    // Salva conclusão da missão no Firebase
    await _firebaseService.concluirMissao(deviceId: deviceId, missaoId: missionId);
    
    // Verifica se esta missão libera um ambiente específico
    String? ambienteParaDesbloquear = _regrasProgresso[missionId];

    if (ambienteParaDesbloquear != null) {
      // Chama a sua função completeMission para liberar o próximo passo
      await _firebaseService.completeMission(missionId, ambienteParaDesbloquear);
      await unlockEnvironment(ambienteParaDesbloquear, deviceId);
      
      _uiService.showSuccess("Novo ambiente desbloqueado no seu mapa!");
    }
  }

  /// Desbloqueia um novo ambiente e garante a persistência (RF04/RF08).
  Future<bool> unlockEnvironment(String environmentId, String deviceId) async {
    final unlocked = await _storageService.loadUnlockedEnvironments();

    if (unlocked.contains(environmentId)) return false;

    unlocked.add(environmentId);
    await _storageService.saveUnlockedEnvironments(unlocked);
    
    // Sincroniza com sua função desbloquearAmbiente no Firebase
    await _firebaseService.desbloquearAmbiente(deviceId: deviceId, environmentId: environmentId);
    
    return true; 
  }

  /// 5. TESTAR FLUXO DE PROGRESSÃO
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

  void handleEnvironmentInteraction(Environment env, dynamic userPos, String deviceId) async {
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