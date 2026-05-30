import '../models/mission.dart';

// IDs de ambiente: 'h15', 'biblioteca', 'hospital', 'oficina', 'mercadao'

final List<Mission> staticMissions = [
  Mission(
    id: 'm1_bibliotecario',
    titulo: 'O Bibliotecário',
    descricao: 'Leve o Bibliotecário de volta para a Biblioteca.',
    environmentId: 'h15',
    proximoEnvironmentId: 'biblioteca',
  ),
  Mission(
    id: 'm2_encontrar_enfermeira',
    titulo: 'A Enfermeira Escondida',
    descricao: 'Encontre a Enfermeira Joycelina escondida na Dojoteca.',
    environmentId: 'biblioteca',
  ),
  Mission(
    id: 'm3_levar_enfermeira',
    titulo: 'Caminho da Cura',
    descricao: 'Leve a enfermeira para o Hospital São Manacás.',
    environmentId: 'biblioteca',
    proximoEnvironmentId: 'hospital',
  ),
  Mission(
    id: 'm4_consertar_maquina',
    titulo: 'Reparo Tecnológico',
    descricao: 'Conserte a máquina de reorganização no hospital para ajudar Truffles.',
    environmentId: 'hospital',
  ),
  Mission(
    id: 'm5_recalibrar_truffles',
    titulo: 'Recalibração Final',
    descricao: 'Use a máquina para recalibrar Truffles e devolvê-lo à sua forma original.',
    environmentId: 'hospital',
  ),
  Mission(
    id: 'm6_levar_truffles',
    titulo: 'Retorno à Oficina',
    descricao: 'Leve Truffles de volta para sua oficina no prédio do Mescla.',
    environmentId: 'hospital',
    proximoEnvironmentId: 'oficina',
  ),
  Mission(
    id: 'm7_investigar_mercadao',
    titulo: 'O Mistério do Refeitório',
    descricao: 'Vá investigar o Mercadão da Ilha para entender o sumiço da comida.',
    environmentId: 'oficina',
    proximoEnvironmentId: 'mercadao',
  ),
  Mission(
    id: 'm8_investigar_painel',
    titulo: 'Coração do Sistema',
    descricao: 'Investigue o painel de distribuição externa no Mercadão.',
    environmentId: 'mercadao',
  ),
  Mission(
    id: 'm9_derrotar_beta',
    titulo: 'Confronto Lógico',
    descricao: 'Derrote Beta, a personificação do algoritmo de controle.',
    environmentId: 'mercadao',
  ),
  Mission(
    id: 'm10_interromper_sistema',
    titulo: 'Quebrando a Lógica',
    descricao: 'Retorne ao H15 e interrompa o sistema central do reator.',
    environmentId: 'h15',
  ),
];