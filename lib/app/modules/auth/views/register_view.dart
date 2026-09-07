import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Daftar Akun',
        style:GoogleFonts.poppins()
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  size: 80,
                ),

                const SizedBox(height: 20),

                Text(
                  'Buat Akun',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Mulai belajar Bahasa Serawai Seluma melalui pantun.',
                  style: GoogleFonts.poppins(),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: controller.namaController,
                  validator: controller.validateNama,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    hintStyle: GoogleFonts.poppins(),
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: controller.registerEmailController,
                  validator: controller.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: controller.registerPasswordController,
                  validator: controller.validatePassword,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: controller.confirmPasswordController,
                  validator: controller.validateConfirmPassword,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                Obx(
                  () => SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          controller.isLoading.value
                              ? null
                              : controller.register,
                      child:
                          controller.isLoading.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Daftar'),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Get.offNamed(Routes.login);
                  },
                  child: const Text(
                    'Sudah memiliki akun? Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}