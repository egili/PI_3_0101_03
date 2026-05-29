enum Gender { male, female }

class Player {
  final String name;
  final Gender gender;
  final List<String> unlockedEnvironmentIds;
  final bool consumedSabotagedFood;

  Player({
    required this.name,
    required this.gender,
    this.unlockedEnvironmentIds = const [],
    this.consumedSabotagedFood = false,
  });

  Player copyWith({
    String? name,
    Gender? gender,
    List<String>? unlockedEnvironmentIds,
    bool? consumedSabotagedFood,
  }) {
    return Player(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      unlockedEnvironmentIds:
          unlockedEnvironmentIds ?? this.unlockedEnvironmentIds,
      consumedSabotagedFood: consumedSabotagedFood ?? this.consumedSabotagedFood,
    );
  }
}