import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  String get nama {
    return _authService.currentUser?.displayName ?? 'Pengguna';
  }

  String get email {
    return _authService.currentUser?.email ?? '';
  }

  Future<void> logout() async {
    try {
      await _authService.logout();

      Get.offAllNamed(Routes.login);
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Tidak dapat logout',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}