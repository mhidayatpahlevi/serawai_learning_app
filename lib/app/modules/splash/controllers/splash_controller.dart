import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // ============================================================
  // KEY LOCAL STORAGE
  // ============================================================

  static const String _hasSeenSplashKey = 'has_seen_splash';

  // ============================================================
  // STATE
  // ============================================================

  final isNavigating = false.obs;
  final isCheckingSession = true.obs;

  // ============================================================
  // START
  // ============================================================

  @override
  void onReady() {
    super.onReady();
    _checkInitialRoute();
  }

  // ============================================================
  // CEK KONDISI APLIKASI
  // ============================================================

  Future<void> _checkInitialRoute() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final bool hasSeenSplash = prefs.getBool(_hasSeenSplashKey) ?? false;

      // Firebase Auth akan mengembalikan user yang masih login.
      final user = await _authService.authStateChanges.first;

      if (isClosed) return;

      // ----------------------------------------------------------
      // PERTAMA KALI APLIKASI DIBUKA
      // ----------------------------------------------------------
      //
      // Jangan pindah halaman.
      // Pengguna tetap berada di Splash sampai menekan Lanjutkan.
      //
      if (!hasSeenSplash) {
        isCheckingSession.value = false;
        return;
      }

      // ----------------------------------------------------------
      // SUDAH PERNAH MEMBUKA APLIKASI
      // ----------------------------------------------------------

      if (user != null) {
        // Masih login → langsung Home.
        Get.offAllNamed(Routes.home);
      } else {
        // Sudah pernah membuka aplikasi,
        // tetapi belum login / sudah logout.
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      if (isClosed) return;

      isCheckingSession.value = false;
    }
  }

  // ============================================================
  // TOMBOL LANJUTKAN
  // ============================================================

  Future<void> continueToLogin() async {
    if (isNavigating.value) return;

    try {
      isNavigating.value = true;

      final prefs = await SharedPreferences.getInstance();

      // Tandai bahwa splash/onboarding sudah pernah dilewati.
      await prefs.setBool(_hasSeenSplashKey, true);

      // Cek apakah ternyata Firebase masih memiliki user.
      final user = await _authService.authStateChanges.first;

      if (isClosed) return;

      if (user != null) {
        // Kalau sudah mempunyai sesi login,
        // langsung ke Home.
        Get.offAllNamed(Routes.home);
      } else {
        // Pengguna baru → Login.
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      if (isClosed) return;

      Get.offAllNamed(Routes.login);
    } finally {
      if (!isClosed) {
        isNavigating.value = false;
      }
    }
  }
}
