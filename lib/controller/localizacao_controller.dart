import 'package:get/get.dart';
import 'package:obter_localizacao/dto/localizacao_dto.dart';

class LocalizacaoController extends GetxController {
  Rx<LocalizacaoDto> local = LocalizacaoDto().obs;

  void setLocalizacao(String latitude, String longitude) {
    local.update((val) {
      val?.latitude = latitude;
      val?.longitude = longitude;
    });
  }
}
