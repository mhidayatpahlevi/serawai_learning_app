import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  // =====================================
  // STATE
  // =====================================

  final isNavigating = false.obs;

  // =====================================
  // LANJUT KE LOGIN
  // =====================================

  Future<void> continueToLogin() async {
    if (isNavigating.value) {
      return;
    }

    try {
      isNavigating.value = true;

      // Sedikit delay agar interaksi tombol terasa halus.
      await Future.delayed(const Duration(milliseconds: 250));

      if (isClosed) {
        return;
      }

      Get.offAllNamed(Routes.login);
    } finally {
      if (!isClosed) {
        isNavigating.value = false;
      }
    }
  }
}
