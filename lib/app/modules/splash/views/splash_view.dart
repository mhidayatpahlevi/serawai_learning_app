import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  static const Color primaryColor = Color(0xFF169B96);
  static const Color darkColor = Color(0xFF14213D);
  static const Color textSecondary = Color(0xFF7D8AA4);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFE6F9FC),
      body: SafeArea(
        child: Column(
          children: [
            // ============================================================
            // GAMBAR UTAMA
            // ============================================================
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Center(
                  child: Image.asset(
                    'assets/images/splash.png',
                    width: size.width,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),

            // ============================================================
            // BAGIAN BAWAH
            // ============================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(26, 28, 26, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ======================================================
                  // LABEL
                  // ======================================================
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F7F4),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Belajagh Baso Serawai',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ======================================================
                  // TITLE
                  // ======================================================
                  Text(
                    'Belajar Pantun\nSerawai Lebih Menyenangkan',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 23,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      color: darkColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ======================================================
                  // DESCRIPTION
                  // ======================================================
                  Text(
                    'Kenali pantun, makna, rima, bahasa, dan budaya '
                    'Serawai Bengkulu Selatan melalui pengalaman '
                    'belajar yang mudah dan menarik.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      height: 1.6,
                      color: textSecondary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ======================================================
                  // QUOTE
                  // ======================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5FBFB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '“Pantun, jembatan kata penghubung generasi.”',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF526078),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ======================================================
                  // BUTTON LANJUTKAN
                  // ======================================================
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: controller.isNavigating.value
                            ? null
                            : controller.continueToLogin,
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: primaryColor.withValues(
                            alpha: 0.6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isNavigating.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Lanjutkan',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 21,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ======================================================
                  // FOOTER
                  // ======================================================
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
          ],
        ),
      ),
    );
  }
}
