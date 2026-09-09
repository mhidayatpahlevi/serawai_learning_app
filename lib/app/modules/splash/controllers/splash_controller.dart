import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onReady() {
    super.onReady();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final user = await _authService.authStateChanges.first;

      if (isClosed) return;

      if (user != null) {
        Get.offAllNamed(Routes.home);
      } else {
        Get.offAllNamed(Routes.login);
      }
    } catch (error) {
      if (!isClosed) {
        Get.offAllNamed(Routes.login);
      }
    }
  }
}