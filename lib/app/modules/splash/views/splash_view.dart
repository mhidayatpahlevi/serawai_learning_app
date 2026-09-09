import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF8FF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/splash.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '“  Pantun, jembatan kata\npenghubung generasi  ”',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        height: 1.45,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF324A62),
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: 190,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: const LinearProgressIndicator(
                          minHeight: 7,
                          backgroundColor: Color(0xFFDCEBEC),
                          color: Color(0xFF169B96),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Memuat pengalaman seru...',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF8790A8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}