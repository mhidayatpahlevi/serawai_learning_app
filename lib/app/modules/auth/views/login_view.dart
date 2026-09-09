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
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: darkTextColor,
          ),
        ),
        
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ilustrasi login
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

                Text(
                  'Selamat Datang',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    color: darkTextColor,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Masuk untuk melanjutkan\npetualangan di Pantun Serawai',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.5,
                    color: secondaryTextColor,
                  ),
                ),

                const SizedBox(height: 26),

                TextFormField(
                  controller: controller.loginEmailController,
                  validator: controller.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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

                Obx(
                  () => TextFormField(
                    controller: controller.loginPasswordController,
                    validator: controller.validatePassword,
                    obscureText: controller.obscurePassword.value,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => controller.login(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: darkTextColor,
                    ),
                    decoration: _inputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
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

                const SizedBox(height: 8),

                // Row(
                //   children: [
                //     Obx(
                //       () => SizedBox(
                //         width: 30,
                //         height: 30,
                //         child: Checkbox(
                //           value: controller.rememberMe.value,
                //           onChanged: (value) {
                //             controller.rememberMe.value = value ?? false;
                //           },
                //           activeColor: primaryColor,
                //           checkColor: Colors.white,
                //           side: const BorderSide(
                //             color: Color(0xFFB8C3CC),
                //           ),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(4),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Text(
                //       'Ingat saya',
                //       style: GoogleFonts.poppins(
                //         fontSize: 12,
                //         color: darkTextColor,
                //       ),
                //     ),
                //     const Spacer(),
                //     TextButton(
                //       onPressed: () {
                //         // Contoh:
                //         // Get.toNamed(Routes.forgotPassword);
                //       },
                //       child: Text(
                //         'Lupa password?',
                //         style: GoogleFonts.poppins(
                //           fontSize: 12,
                //           fontWeight: FontWeight.w600,
                //           color: primaryColor,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                const SizedBox(height: 8),

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
                        disabledBackgroundColor:
                            primaryColor.withValues(alpha: 0.55),
                        foregroundColor: Colors.white,
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

                const SizedBox(height: 22),

               

                const SizedBox(height: 24),

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
                      onTap: () => Get.toNamed(Routes.register),
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
              ],
            ),
          ),
        ),
      ),
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
        color: secondaryTextColor,
      ),
      prefixIcon: Icon(
        prefixIcon,
        size: 21,
        color: darkTextColor,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFDDE3E8),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFDDE3E8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          width: 1.5,
          color: primaryColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.red,
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    this.icon,
    this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData? icon;
  final String? label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(color: Color(0xFFE1E6EA)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: icon != null
            ? Icon(icon, size: 25, color: color)
            : Text(
                label ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
      ),
    );
  }
}