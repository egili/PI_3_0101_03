import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<User?> signInAnon() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();

      return userCredential.user;
    } catch (e) {
      print('Erro no login anônimo: $e');
      return null;
    }
  }
}