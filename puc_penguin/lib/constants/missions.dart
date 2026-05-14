import '../models/mission.dart';

// IDs de ambiente usados: 'h15', 'biblioteca', 'hospital', 'oficina', 'mercadao'
// (conforme constants/environments.dart)

final List<Mission> staticMissions = [
  Mission(
    id: 'm1_bibliotecario',
    titulo: 'O Bibliotecário',
    descricao:
        'Encontre o bibliotecário na Dojoteca e descubra o que aconteceu com os registros da pesquisa.',
    environmentId: 'h15',
    proximoEnvironmentId: 'biblioteca',
  ),
  Mission(
    id: 'm2_pistas',
    titulo: 'Pistas na Biblioteca',
    descricao:
        'Procure nas prateleiras os documentos que ligam o laboratório ao incidente.',
    environmentId: 'biblioteca',
  ),
  Mission(
    id: 'm3_enfermeira',
    titulo: 'A Enfermeira',
    descricao:
        'Fale com a enfermeira no Hospital São Manacás e investigue a máquina experimental.',
    environmentId: 'biblioteca',
    proximoEnvironmentId: 'hospital',
  ),
  Mission(
    id: 'm4_registros',
    titulo: 'Registros Médicos',
    descricao:
        'Encontre os registros médicos escondidos no hospital antes que alguém os destrua.',
    environmentId: 'hospital',
  ),
  Mission(
    id: 'm5_pecas',
    titulo: 'Peças da Verdade',
    descricao:
        'Colete as peças espalhadas na Oficina para reconstruir o dispositivo.',
    environmentId: 'hospital',
    proximoEnvironmentId: 'oficina',
  ),
  Mission(
    id: 'm6_truffles',
    titulo: 'Truffles na Oficina',
    descricao:
        'Encontre Truffles escondido entre as ferramentas e descubra sua parte na conspiração.',
    environmentId: 'oficina',
    proximoEnvironmentId: 'mercadao',
  ),
  Mission(
    id: 'm7_investigacao',
    titulo: 'Investigação Final',
    descricao:
        'No Mercadão da Ilha, reúna todas as evidências e confronte o responsável.',
    environmentId: 'mercadao',
  ),
];
