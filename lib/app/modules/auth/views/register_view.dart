import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  static const Color primaryColor = Color(0xFF239B98);
  static const Color darkColor = Color(0xFF10233F);
  static const Color greyColor = Color(0xFF8B93A8);
  static const Color borderColor = Color(0xFFDDE3E8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offNamed(Routes.login);
            }
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: darkColor,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: controller.registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 10, 28, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Buat Akun',
                            style: GoogleFonts.poppins(
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                              color: darkColor,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            'Bergabung dan mulai belajar\n'
                            'pantun Serawai bersama kami',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              height: 1.45,
                              color: greyColor,
                            ),
                          ),

                          const SizedBox(height: 22),

                          // Nama
                          TextFormField(
                            controller: controller.namaController,
                            validator: controller.validateNama,
                            textInputAction: TextInputAction.next,
                            style: _textFieldStyle(),
                            decoration: _inputDecoration(
                              hintText: 'Nama Lengkap',
                              prefixIcon: Icons.person_outline_rounded,
                            ),
                          ),

                          const SizedBox(height: 13),

                          // Email
                          TextFormField(
                            controller:
                                controller.registerEmailController,
                            validator: controller.validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: _textFieldStyle(),
                            decoration: _inputDecoration(
                              hintText: 'Email',
                              prefixIcon: Icons.mail_outline_rounded,
                            ),
                          ),

                          const SizedBox(height: 13),

                          // Password
                          Obx(
                            () => TextFormField(
                              controller:
                                  controller.registerPasswordController,
                              validator: controller.validatePassword,
                              obscureText:
                                  controller.obscureRegisterPassword.value,
                              textInputAction: TextInputAction.next,
                              style: _textFieldStyle(),
                              decoration: _inputDecoration(
                                hintText: 'Password',
                                prefixIcon: Icons.lock_outline_rounded,
                                suffixIcon: IconButton(
                                  onPressed: controller
                                      .toggleRegisterPasswordVisibility,
                                  icon: Icon(
                                    controller
                                            .obscureRegisterPassword.value
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                    color: greyColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 13),

                          // Konfirmasi password
                          Obx(
                            () => TextFormField(
                              controller:
                                  controller.confirmPasswordController,
                              validator:
                                  controller.validateConfirmPassword,
                              obscureText:
                                  controller.obscureConfirmPassword.value,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                if (!controller.isLoading.value) {
                                  controller.register();
                                }
                              },
                              style: _textFieldStyle(),
                              decoration: _inputDecoration(
                                hintText: 'Konfirmasi Password',
                                prefixIcon: Icons.lock_outline_rounded,
                                suffixIcon: IconButton(
                                  onPressed: controller
                                      .toggleConfirmPasswordVisibility,
                                  icon: Icon(
                                    controller
                                            .obscureConfirmPassword.value
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                    color: greyColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Tombol daftar
                          Obx(
                            () => SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : controller.register,
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: primaryColor,
                                  disabledBackgroundColor:
                                      primaryColor.withValues(alpha: 0.55),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Daftar',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),


                          const SizedBox(height: 40),

                          // Navigasi ke login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sudah memiliki akun? ',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: greyColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.offNamed(Routes.login);
                                },
                                child: Text(
                                  'Masuk',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Ilustrasi bagian bawah
                    SizedBox(
                      width: double.infinity,
                      height: 230,
                      child: Image.asset(
                        'assets/images/register.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _textFieldStyle() {
    return GoogleFonts.poppins(
      fontSize: 13,
      color: darkColor,
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        fontSize: 13,
        color: greyColor,
      ),
      prefixIcon: Icon(
        prefixIcon,
        size: 21,
        color: darkColor,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(
        color: primaryColor,
        width: 1.5,
      ),
      errorBorder: _border(color: Colors.red),
      focusedErrorBorder: _border(
        color: Colors.red,
        width: 1.5,
      ),
    );
  }

  OutlineInputBorder _border({
    Color color = borderColor,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }
}