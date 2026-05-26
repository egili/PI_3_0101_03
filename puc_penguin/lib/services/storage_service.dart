import 'package:shared_preferences/shared_preferences.dart';

/// Serviço responsável por salvar e carregar dados do jogador no dispositivo.
/// Usamos SharedPreferences — ele guarda pares chave/valor no armazenamento
/// local do celular, sem precisar de banco de dados.
class StorageService {
  // Chaves usadas para identificar cada dado salvo
  static const String _keyPlayerName = 'player_name';
  static const String _keyPlayerGender = 'player_gender';
  static const String _keyUnlockedEnvironments = 'unlocked_environments';
  static const String _keyTutorialSeen = 'tutorial_seen';

  // ---------- SALVAR ----------

  /// Salva o nome do jogador localmente.
  Future<void> savePlayerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPlayerName, name);
  }

  /// Salva o gênero do jogador (como String: 'male' ou 'female').
  Future<void> savePlayerGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPlayerGender, gender);
  }

  /// Salva a lista de IDs de ambientes desbloqueados.
  /// SharedPreferences não suporta List diretamente, então salvamos
  /// como uma String separada por vírgulas. Ex: "h15,dojoteca"
  Future<void> saveUnlockedEnvironments(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUnlockedEnvironments, ids.join(','));
  }

  /// Salva que o usuário já viu o tutorial.
  Future<void> saveTutorialSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTutorialSeen, true);
  }

  /// Retorna se o tutorial já foi visto.
  Future<bool> hasSeenTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTutorialSeen) ?? false;
  }


  /// Retorna o nome salvo, ou null se nunca foi salvo.
  Future<String?> loadPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPlayerName);
  }

  /// Retorna o gênero salvo, ou null se nunca foi salvo.
  Future<String?> loadPlayerGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPlayerGender);
  }

  /// Retorna a lista de ambientes desbloqueados.
  /// Se nunca salvou nada, retorna ['h15'] — o ambiente inicial.
  Future<List<String>> loadUnlockedEnvironments() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUnlockedEnvironments);

    if (raw == null || raw.isEmpty) {
      return ['h15']; // padrão: só o ambiente inicial desbloqueado
    }

    // Transforma "h15,dojoteca" de volta em ['h15', 'dojoteca']
    return raw.split(',');
  }

  /// Apaga todo o progresso salvo (útil para "Novo Jogo").
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Verifica se já existe um jogo salvo.
  Future<bool> hasSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyPlayerName);
  }
}
