enum MissionStatus { pendente, ativa, concluida }

class Mission {
  final String id;
  final String titulo;
  final String descricao;
  final String environmentId;
  final String? proximoEnvironmentId;
  final MissionStatus status;

  const Mission({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.environmentId,
    this.proximoEnvironmentId,
    this.status = MissionStatus.pendente,
  });

  bool get isPendente => status == MissionStatus.pendente;
  bool get isAtiva => status == MissionStatus.ativa;
  bool get isConcluida => status == MissionStatus.concluida;

  Mission copyWith({MissionStatus? status}) {
    return Mission(
      id: id,
      titulo: titulo,
      descricao: descricao,
      environmentId: environmentId,
      proximoEnvironmentId: proximoEnvironmentId,
      status: status ?? this.status,
    );
  }
}
