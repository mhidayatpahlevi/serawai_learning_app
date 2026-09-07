import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Login
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Register
  final namaController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  String? validateNama(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama wajib diisi';
    }

    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }

    if (!GetUtils.isEmail(value.trim())) {
      return 'Format email tidak valid';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }

    if (value != registerPasswordController.text) {
      return 'Password tidak sama';
    }

    return null;
  }

  Future<void> register() async {
    if (!(registerFormKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      isLoading.value = true;

      await _authService.register(
        nama: namaController.text,
        email: registerEmailController.text,
        password: registerPasswordController.text,
      );

      Get.offAllNamed(Routes.home);

      Get.snackbar(
        'Berhasil',
        'Akun berhasil dibuat',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Registrasi gagal',
        _firebaseError(e.code),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Terjadi kesalahan',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    if (!(loginFormKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      isLoading.value = true;

      await _authService.login(
        email: loginEmailController.text,
        password: loginPasswordController.text,
      );

      Get.offAllNamed(Routes.home);

      Get.snackbar(
        'Berhasil',
        'Login berhasil',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Login gagal',
        _firebaseError(e.code),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Terjadi kesalahan',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _firebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email sudah digunakan.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Password terlalu lemah.';
      case 'user-not-found':
        return 'Akun tidak ditemukan.';
      case 'wrong-password':
        return 'Password salah.';
      case 'invalid-credential':
        return 'Email atau password salah.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba kembali nanti.';
      case 'network-request-failed':
        return 'Periksa koneksi internet Anda.';
      default:
        return 'Terjadi kesalahan autentikasi.';
    }
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();

    namaController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}