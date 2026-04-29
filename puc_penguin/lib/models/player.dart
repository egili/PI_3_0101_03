enum Gender { male, female }

class Player {
  final String name;
  final Gender gender;
  final List<String> unlockedEnvironmentIds;

  Player({
    required this.name,
    required this.gender,
    this.unlockedEnvironmentIds = const [],
  });

  Player copyWith({
    String? name,
    Gender? gender,
    List<String>? unlockedEnvironmentIds,
  }) {
    return Player(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      unlockedEnvironmentIds:
          unlockedEnvironmentIds ?? this.unlockedEnvironmentIds,
    );
  }
}