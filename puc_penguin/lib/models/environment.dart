class Environment {
  final String id;
  final String name;
  final String description;
  final String audioAsset;
  final double latitude;
  final double longitude;
  final double radius;
  final bool isUnlocked;

  Environment({
    required this.id,
    required this.name,
    required this.description,
    required this.audioAsset,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.isUnlocked = false,
  });

  Environment copyWith({
    bool? isUnlocked,
  }) {
    return Environment(
      id: id,
      name: name,
      description: description,
      audioAsset: audioAsset,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}