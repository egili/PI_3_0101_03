import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('O serviço de localização está desativado. Por favor, ative o GPS.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Permissões de localização permanentemente negadas. Ative nas configurações do aparelho.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        // bestForNavigation = máxima precisão do chip GPS
        accuracy: LocationAccuracy.bestForNavigation,

        // distanceFilter: 0 = atualiza a cada nova leitura do GPS,
        // sem exigir deslocamento mínimo
        distanceFilter: 0,

        // intervalDuration: atualiza a cada 1 segundo
        intervalDuration: const Duration(seconds: 1),

        // Mantém o GPS ativo mesmo com a tela bloqueada
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'PUC Penguin',
          notificationText: 'Rastreando sua localização no campus...',
          enableWakeLock: true,
        ),
      ),
    );
  }
}