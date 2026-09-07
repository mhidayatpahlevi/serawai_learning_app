import 'package:get/get.dart';

import '../controllers/pantun_controller.dart';

class PantunBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PantunController>(
      () => PantunController(),
    );
  }
}