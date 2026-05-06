import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

/// Gera e guarda um ID único para o dispositivo.
/// Usamos isso como chave no Firestore em vez de autenticação,
/// já que o app não tem login.
class DeviceIdService {
  static const String _keyDeviceId = 'device_id';

  /// Retorna o ID do dispositivo. Se não existir, gera um novo e salva.
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString(_keyDeviceId);

    if (id == null) {
      // Gera um ID aleatório de 20 caracteres
      id = _generateId();
      await prefs.setString(_keyDeviceId, id);
    }

    return id;
  }

  static String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(20, (_) => chars[random.nextInt(chars.length)]).join();
  }
}