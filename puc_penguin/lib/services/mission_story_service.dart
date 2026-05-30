import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mission_provider.dart';

class MissionStoryService {
  final Ref ref;

  MissionStoryService(this.ref);

  /// Valida se a conclusão de um diálogo deve resultar na conclusão de uma missão.
  void validateDialogueCompletion(String nodeId) {
    final missionNotifier = ref.read(missionProvider.notifier);

    switch (nodeId) {
      case 'biblio_joycelina_4':
        missionNotifier.concluirMissao('m2_encontrar_enfermeira');
        break;
      case 'hosp_recalibra_6':
        missionNotifier.concluirMissao('m4_consertar_maquina');
        missionNotifier.concluirMissao('m5_recalibrar_truffles');
        break;
      case 'mercadao_batalha_inicio':
        missionNotifier.concluirMissao('m8_investigar_painel');
        break;
      case 'h15_final_fim':
        missionNotifier.concluirMissao('m10_interromper_sistema');
        break;
    }
  }
}

final missionStoryServiceProvider = Provider<MissionStoryService>((ref) {
  return MissionStoryService(ref);
});
