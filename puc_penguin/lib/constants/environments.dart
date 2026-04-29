import '../../models/environment.dart';

class MockEnvironmentRepository {
  static List<<EnvironmentEnvironment> get allEnvironments {
    return [
      Environment(
        id: 'h15',
        name: 'Centro de Pesquisas Avançadas H15',
        description: 'Laboratório tecnológico com telas piscando e cabos espalhados. Clima tenso e silencioso.',
        latitude: -22.858, // Placeholder: Coordinate for H15 PUC Campinas
        longitude: -47.055, // Placeholder
        radius: 30.0,
        audioAsset: 'audio/h15_ambient.mp3',
        isUnlocked: true, // Starting environment
      ),
      Environment(
        id: 'dojoteca',
        name: 'Dojoteca (Biblioteca)',
        description: 'Místico campo de treinamento com estantes de madeira maciça e silêncio profundo.',
        latitude: -22.859, // Placeholder: Coordinate for Library
        longitude: -47.056, // Placeholder
        radius: 30.0,
        audioAsset: 'audio/dojoteca_ambient.mp3',
        isUnlocked: false,
      ),
      Environment(
        id: 'hospital',
        name: 'Hospital São Manacás',
        description: 'Centro médico com macas fora do lugar e luzes piscando. Presença de uma máquina experimental.',
        latitude: -22.860, // Placeholder: Coordinate for Manacás
        longitude: -47.057, // Placeholder
        radius: 30.0,
        audioAsset: 'audio/hospital_ambient.mp3',
        isUnlocked: false,
      ),
      Environment(
        id: 'oficina',
        name: 'Oficina (Mescla)',
        description: 'Local de conserto de ferramentas e móveis, repleto de peças metálicas desalinhadas.',
        latitude: -22.861, // Placeholder: Coordinate for Mescla
        longitude: -47.058, // Placeholder
        radius: 30.0,
        audioAsset: 'audio/oficina_ambient.mp3',
        isUnlocked: false,
      ),
      Environment(
        id: 'mercadao',
        name: 'Mercadão da Ilha (Refeitório)',
        description: 'Grande salão de alimentação parcialmente destruído. Cheiro de comida no ar.',
        latitude: -22.862, // Placeholder: Coordinate for Refeitório
        longitude: -47.059, // Placeholder
        radius: 30.0,
        audioAsset: 'audio/mercadao_ambient.mp3',
        isUnlocked: false,
      ),
    ];
  }
}