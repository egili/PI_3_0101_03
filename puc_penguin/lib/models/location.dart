class UserLocation {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  UserLocation({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  /// Converte a posição do geolocator para o nosso modelo de domínio
  factory UserLocation.fromPosition(dynamic position) {
    return UserLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
    );
  }
}
