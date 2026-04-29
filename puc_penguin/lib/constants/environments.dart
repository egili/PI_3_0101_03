import '../models/environment.dart';

final List<Environment> staticEnvironments = [
  Environment(
    id: 'h15',
    name: 'Centro de Pesquisas Avançadas (H15)',
    description: 'Laboratório tecnológico com telas piscando, cabos e máquinas destruídas. Clima tenso.',
    latitude: -22.932, // Substituir por coordenadas reais do Campus I
    longitude: -47.062,
    radius: 30.0,
    audioAsset: 'assets/audio/h15_theme.mp3',
    isUnlocked: true, // Aberto por padrão para início do jogo
  ),
  Environment(
    id: 'biblioteca',
    name: 'Dojoteca (Biblioteca)',
    description: 'Estantes de madeira como labirintos, tatames improvisados. Silêncio profundo.',
    latitude: -22.933,
    longitude: -47.063,
    radius: 20.0,
    audioAsset: 'assets/audio/library_theme.mp3',
    isUnlocked: false,
  ),
  Environment(
    id: 'hospital',
    name: 'Hospital São Manacás (Manacás)',
    description: 'Macas fora do lugar, luzes piscando, equipamentos quebrados. Máquina médica experimental.',
    latitude: -22.934,
    longitude: -47.064,
    radius: 20.0,
    audioAsset: 'assets/audio/hospital_theme.mp3',
    isUnlocked: false,
  ),
  Environment(
    id: 'oficina',
    name: 'Oficina (Mescla)',
    description: 'Ferramentas espalhadas, metais, estruturas inacabadas. Caos organizado.',
    latitude: -22.935,
    longitude: -47.065,
    radius: 20.0,
    audioAsset: 'assets/audio/workshop_theme.mp3',
    isUnlocked: false,
  ),
  Environment(
    id: 'mercadao',
    name: 'Mercadão da Ilha (Refeitório)',
    description: 'Mesas viradas, bandejas espalhadas, freezer escondido com cabos de energia.',
    latitude: -22.936,
    longitude: -47.066,
    radius: 30.0,
    audioAsset: 'assets/audio/foodcourt_theme.mp3',
    isUnlocked: false,
  ),
];
