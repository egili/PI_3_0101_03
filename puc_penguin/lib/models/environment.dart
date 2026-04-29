class Environment {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final double radius; // em metros
  final String audioAsset;
  final bool isUnlocked;

  Environment({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.audioAsset,
    this.isUnlocked = false,
  });

  Environment copyWith({
    bool? isUnlocked,
  }) {
    return Environment(
      id: id,
      name: name,
      description: description,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      audioAsset: audioAsset,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}