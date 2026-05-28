import '../models/environment.dart';

final List<Environment> staticEnvironments = [
  Environment(
    id: 'h15',
    name: 'Centro de Pesquisas Avançadas (H15)',
    description: 'Laboratório tecnológico com telas piscando, cabos e máquinas destruídas. Clima tenso.',
    latitude: -22.834089776229245,
    longitude: -47.05267330993873,
    radius: 45.0,
    audioAsset: 'assets/audio/h15_theme.mp3',
    isUnlocked: true, // Aberto por padrão para início do jogo
  ),
  Environment(
    id: 'biblioteca',
    name: 'Dojoteca (Biblioteca)',
    description: 'Estantes de madeira como labirintos, tatames improvisados. Silêncio profundo.',
    latitude: -22.833648781301225,
    longitude: -47.05196330830579,
    radius: 15.0,
    audioAsset: 'assets/audio/library_theme.mp3',
    isUnlocked: false,
  ),
  Environment(
    id: 'hospital',
    name: 'Hospital São Manacás (Manacás)',
    description: 'Macas fora do lugar, luzes piscando, equipamentos quebrados. Máquina médica experimental.',
    latitude: -22.83240646531408,
    longitude: -47.05124895720967,
    radius: 35.0,
    audioAsset: 'assets/audio/hospital_theme.mp3',
    isUnlocked: false,
  ),
  Environment(
    id: 'oficina',
    name: 'Oficina (Mescla)',
    description: 'Ferramentas espalhadas, metais, estruturas inacabadas. Caos organizado.',
    latitude: -22.833902182094544,
    longitude: -47.05143535129553,
    radius: 15.0,
    audioAsset: 'assets/audio/workshop_theme.mp3',
    isUnlocked: false,
  ),
  Environment(
    id: 'mercadao',
    name: 'Mercadão da Ilha (Refeitório)',
    description: 'Mesas viradas, bandejas espalhadas, freezer escondido com cabos de energia.',
    latitude: -22.833043531432814,
    longitude: -47.05205417217558,
    radius: 30.0,
    audioAsset: 'assets/audio/foodcourt_theme.mp3',
    isUnlocked: false,
  ),
];
