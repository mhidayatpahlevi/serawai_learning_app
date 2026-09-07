import 'package:get/get.dart';

import '../data/services/auth_service.dart';
import '../data/services/category_service.dart';
import '../data/services/history_service.dart';
import '../data/services/nlp_service.dart';
import '../data/services/pantun_service.dart';
import '../data/services/progress_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(
      AuthService(),
      permanent: true,
    );

    Get.put<CategoryService>(
      CategoryService(),
      permanent: true,
    );

    Get.put<PantunService>(
      PantunService(),
      permanent: true,
    );

    Get.put<ProgressService>(
      ProgressService(),
      permanent: true,
    );

    Get.put<HistoryService>(
      HistoryService(),
      permanent: true,
    );

    Get.put<NlpService>(
      NlpService(),
      permanent: true,
    );
  }
}