import '../models/environment.dart';

final List<Environment> staticEnvironments = [
  Environment(
    id: 'h15',
    name: 'Centro de Pesquisas Avançadas (H15)',
    description: 'Laboratório tecnológico com telas piscando, cabos espalhados, máquinas parcialmente destruídas e anotações científicas por todo lado. O ambiente possui um clima tenso e silencioso, com sons de eletricidade e estática ao fundo. Há sinais de pressa e desorganização, indicando que algo grave aconteceu.',
    latitude: -22.834089776229245,
    longitude: -47.05267330993873,
    radius: 45.0,
    audioAsset: 'assets/audio/h15_theme.mp3',
    isUnlocked: true, // Aberto por padrão
  ),
  Environment(
    id: 'biblioteca',
    name: 'Dojoteca (Biblioteca)',
    description: 'O que antes era um centro de estudos tradicional agora se assemelha a um místico campo de treinamento. Estantes de madeira maciça dispostas como labirintos e tatames improvisados feitos de tapetes de leitura. O silêncio é profundo e intencional. Livros caídos formam pilhas perfeitamente equilibradas.',
    latitude: -22.833900994731703,
    longitude: -47.05184828539257,
    radius: 15.0,
    audioAsset: 'assets/audio/library_theme.mp3',
    isUnlocked: false,
  ),
  Environment(
    id: 'hospital',
    name: 'Hospital São Manacás (Manacás)',
    description: 'O centro médico sofreu danos severos. Macas fora do lugar, luzes piscando e equipamentos quebrados. Há um estranho barulho mecânico de uma máquina experimental. Uma estátua de um anjo em forma de pinguim (São Manacás) observa o caos no recinto.',
    latitude: -22.83240646531408,
    longitude: -47.05124895720967,
    radius: 35.0,
    audioAsset: 'assets/audio/hospital_theme.mp3',
    isUnlocked: false,
  ),
  Environment(
    id: 'oficina',
    name: 'Oficina (Mescla)',
    description: 'Espadas, escudos e ferramentas espalhadas. Peças metálicas desalinhadas e estruturas inacabadas. O som de metal ecoa pelo espaço. Apesar do caos... há um padrão. Como se tudo estivesse no lugar errado... de propósito.',
    latitude: -22.83388081560502,
    longitude: -47.05146812025525,
    radius: 15.0,
    audioAsset: 'assets/audio/workshop_theme.mp3',
    isUnlocked: false,
  ),
  Environment(
    id: 'mercadao',
    name: 'Mercadão da Ilha (Refeitório)',
    description: 'Um grande salão parcialmente destruído, com mesas viradas e bandejas espalhadas. Um cheiro leve de comida paira no ar... algo que não deveria existir na atual situação da ilha. As panelas ainda estão quentes e há um freezer vibrando de forma suspeita no fundo do salão.',
    latitude: -22.833043531432814,
    longitude: -47.05205417217558,
    radius: 30.0,
    audioAsset: 'assets/audio/foodcourt_theme.mp3',
    isUnlocked: false,
  ),
];