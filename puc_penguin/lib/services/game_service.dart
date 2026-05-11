import '../constants/environments.dart';
import '../models/environment.dart';
import 'storage_service.dart';
import 'location_service.dart'; // Importação necessária para o RF01/RF02
import 'firebase_progress_service.dart'; // Para persistência em tempo real

/// Serviço com as regras de negócio do jogo.
/// Ele gerencia o Sistema de Desbloqueio e a validação de acesso.
class GameService {
  final StorageService _storageService = StorageService();
  final LocationService _locationService = LocationService();
  final FirebaseProgressService _firebaseService; 
  final dynamic _uiService; // Interface para feedbacks visuais

  // Construtor
  GameService(this._firebaseService, this._uiService);

  /// 1. DEFINIR REGRAS DE DESBLOQUEIO
  /// Mapeamento oficial do roteiro: Missão concluída libera o próximo ID de ambiente.
  final Map<String, String> _regrasProgresso = {
    'm1_bibliotecario': 'biblioteca',
    'm3_enfermeira': 'manacas',
    'm6_truffles': 'mescla',
    'm7_investigacao': 'refeitorio',
  };

  /// Retorna todos os ambientes, marcando quais estão desbloqueados
  /// com base na lista salva no dispositivo ou Firebase.
  Future<List<Environment>> getEnvironmentsWithProgress() async {
    final unlockedIds = await _storageService.loadUnlockedEnvironments();
    final all = staticEnvironments; 

    return all.map((env) {
      final isUnlocked = unlockedIds.contains(env.id);
      return env.copyWith(isUnlocked: isUnlocked);
    }).toList();
  }

  /// 2. IMPLEMENTAR VALIDAÇÃO DE ACESSO
  /// 3. BLOQUEAR AMBIENTES NÃO LIBERADOS
  /// Valida se o jogador pode interagir com o ambiente (Status + GPS).
  Future<bool> validarAcessoAmbiente(Environment env, dynamic userPos) async {
    // RF03: Bloqueio por regra de negócio (isUnlocked)
    if (!env.isUnlocked) {
      _uiService.showError("Este local ainda está inacessível. Progrida na história!");
      return false;
    }

    // RF01/RF02: Validação por proximidade física (Raio de 10-30m)
    bool isInsideRange = _locationService.checkProximity(userPos, env.coordinates);
    if (!isInsideRange) {
      _uiService.showError("Você precisa estar fisicamente no local para interagir.");
      return false;
    }

    return true; // Acesso permitido
  }

  /// 4. LIBERAR AMBIENTES APÓS MISSÃO
  /// Atualiza o status da missão e desbloqueia o próximo ambiente no fluxo.
  Future<void> concluirMissao(String missionId) async {
    // Salva conclusão da missão no Firebase e Local
    await _firebaseService.saveMissionProgress(missionId, true);
    
    // Verifica se esta missão libera um ambiente específico
    String? ambienteParaDesbloquear = _regrasProgresso[missionId];

    if (ambienteParaDesbloquear != null) {
      await unlockEnvironment(ambienteParaDesbloquear);
      
      // Feedback visual em Azul Corporativo para o usuário
      _uiService.showSuccess("Novo ambiente desbloqueado no seu mapa!");
    }
  }

  /// Desbloqueia um novo ambiente e garante a persistência (RF04/RF08).
  Future<bool> unlockEnvironment(String environmentId) async {
    final unlocked = await _storageService.loadUnlockedEnvironments();

    if (unlocked.contains(environmentId)) return false;

    // Atualiza Local e Firebase simultaneamente
    unlocked.add(environmentId);
    await _storageService.saveUnlockedEnvironments(unlocked);
    await _firebaseService.unlockEnvironment(environmentId);
    
    return true; 
  }

  /// 5. TESTAR FLUXO DE PROGRESSÃO
  /// Método para validação durante o desenvolvimento.
  void testarFluxoCompleto() async {
    print("Iniciando Teste de Progressão...");
    // Simula conclusão da missão inicial
    await concluirMissao('m1_bibliotecario');
    
    bool biblioStatus = await isEnvironmentUnlocked('biblioteca');
    print("Teste - Biblioteca Desbloqueada: $biblioStatus");
  }

  /// Verifica se um ambiente específico está desbloqueado.
  Future<bool> isEnvironmentUnlocked(String environmentId) async {
    final unlocked = await _storageService.loadUnlockedEnvironments();
    return unlocked.contains(environmentId);
  }

  /// Lógica de interação com o ambiente (Unificação das validações).
  void handleEnvironmentInteraction(Environment env, dynamic userPos) async {
    bool acessoPermitido = await validarAcessoAmbiente(env, userPos);

    if (acessoPermitido) {
      // Inicia diálogo ou missão
      startNarrative(env.id);
    }
  }

  /// Carrega o progresso completo do jogador ao iniciar o app.
  Future<Map<String, dynamic>?> loadGameProgress() async {
    final hasGame = await _storageService.hasSavedGame();
    if (!hasGame) return null;

    return {
      'playerName': await _storageService.loadPlayerName(),
      'playerGender': await _storageService.loadPlayerGender(),
      'unlockedEnvironments': await _storageService.loadUnlockedEnvironments(),
    };
  }

  /// Salva o progresso quando o jogador visita um ambiente.
  Future<void> saveVisit({
    required String playerName,
    required String gender,
    required String environmentId,
  }) async {
    await _storageService.savePlayerName(playerName);
    await _storageService.savePlayerGender(gender);
    await unlockEnvironment(environmentId);
  }
  
  // Métodos auxiliares de navegação/UI
  void startNarrative(String envId) {
    print("Iniciando narrativa de $envId");
  }
}