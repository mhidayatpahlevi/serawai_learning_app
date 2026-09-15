import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  static const Color primaryColor = Color(0xFF209C99);
  static const Color darkTextColor = Color(0xFF10233F);
  static const Color secondaryTextColor = Color(0xFF8B93A8);
  static const Color borderColor = Color(0xFFDDE3E8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ============================================================
      // APP BAR
      // Tidak ada tombol kembali ke Splash
      // ============================================================
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
      ),

      // ============================================================
      // BODY
      // ============================================================
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ====================================================
                    // ILUSTRASI
                    // ====================================================

                    SizedBox(
                      width: double.infinity,
                      height: 245,
                      child: Image.asset(
                        'assets/images/login.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        filterQuality: FilterQuality.high,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ====================================================
                    // TITLE
                    // ====================================================
                    Text(
                      'Selamat Datang',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        color: darkTextColor,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Masuk untuk melanjutkan\n'
                      'petualangan di Pantun Serawai',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        height: 1.5,
                        color: secondaryTextColor,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ====================================================
                    // EMAIL
                    // ====================================================
                    TextFormField(
                      controller: controller.loginEmailController,
                      validator: controller.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      enableSuggestions: false,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: darkTextColor,
                      ),
                      decoration: _inputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icons.mail_outline_rounded,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ====================================================
                    // PASSWORD
                    // ====================================================
                    Obx(
                      () => TextFormField(
                        controller: controller.loginPasswordController,
                        validator: controller.validatePassword,
                        obscureText: controller.obscurePassword.value,
                        textInputAction: TextInputAction.done,
                        enableSuggestions: false,
                        autocorrect: false,
                        onFieldSubmitted: (_) {
                          if (!controller.isLoading.value) {
                            controller.login();
                          }
                        },
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: darkTextColor,
                        ),
                        decoration: _inputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icons.lock_outline_rounded,
                          suffixIcon: IconButton(
                            tooltip: controller.obscurePassword.value
                                ? 'Tampilkan password'
                                : 'Sembunyikan password',
                            onPressed: controller.togglePasswordVisibility,
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                              color: secondaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ====================================================
                    // TOMBOL MASUK
                    // ====================================================
                    Obx(
                      () => SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.login,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: primaryColor.withValues(
                              alpha: 0.55,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
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
                                  'Masuk',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ====================================================
                    // DAFTAR AKUN
                    // ====================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkTextColor,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            if (!controller.isLoading.value) {
                              Get.toNamed(Routes.register);
                            }
                          },
                          child: Text(
                            'Daftar sekarang',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ====================================================
                    // FOOTER
                    // ====================================================
                    Text(
                      'Serawai • Bengkulu Selatan',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xFFA0A9B8),
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

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,

      hintStyle: GoogleFonts.poppins(fontSize: 13, color: secondaryTextColor),

      prefixIcon: Icon(prefixIcon, size: 21, color: darkTextColor),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),

      border: _border(),

      enabledBorder: _border(),

      focusedBorder: _border(color: primaryColor, width: 1.5),

      errorBorder: _border(color: Colors.red),

      focusedErrorBorder: _border(color: Colors.red, width: 1.5),
    );
  }

  // ============================================================
  // BORDER
  // ============================================================

  OutlineInputBorder _border({Color color = borderColor, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
