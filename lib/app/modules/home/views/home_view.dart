import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =====================================
      // APP BAR
      // =====================================
      appBar: AppBar(
        title: const Text('Belajar Bahasa Serawai'),
        actions: [
          IconButton(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),

      // =====================================
      // BODY
      // =====================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // =================================
              // SELAMAT DATANG
              // =================================
              Text(
                'Selamat datang, ${controller.nama}',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(controller.email, style: const TextStyle(fontSize: 14)),

              const SizedBox(height: 30),

              // =================================
              // LATIHAN PANTUN
              // =================================
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.auto_stories, size: 60),

                      const SizedBox(height: 16),

                      const Text(
                        'Latihan Pantun',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Pelajari dan lengkapi '
                        'pantun Bahasa Serawai '
                        'dengan pilihan kata '
                        'yang tepat.',
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.toNamed(Routes.kategori);
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Mulai Belajar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =================================
              // RIWAYAT DAN PROGRES
              // =================================
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Get.toNamed(Routes.riwayat);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(18),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          child: Icon(Icons.history, size: 28),
                        ),

                        SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Riwayat & Progres',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 6),

                              Text(
                                'Lihat hasil latihan dan '
                                'perkembangan belajar Anda.',
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 8),

                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =================================
              // INFORMASI FITUR NLP
              // =================================
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.psychology_outlined, size: 30),

                          SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              'Analisis NLP',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'Jawaban latihan dianalisis '
                        'berdasarkan tiga aspek:',
                      ),

                      const SizedBox(height: 12),

                      _buildFeatureItem(
                        icon: Icons.translate_outlined,
                        title: 'Kesesuaian Makna',
                      ),

                      const SizedBox(height: 8),

                      _buildFeatureItem(
                        icon: Icons.subject_outlined,
                        title: 'Kesesuaian Konteks',
                      ),

                      const SizedBox(height: 8),

                      _buildFeatureItem(
                        icon: Icons.music_note_outlined,
                        title: 'Kesesuaian Rima',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================
  // FEATURE ITEM
  // =====================================

  Widget _buildFeatureItem({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, size: 21),

        const SizedBox(width: 10),

        Expanded(child: Text(title)),

        const Icon(Icons.check_circle_outline, size: 20),
      ],
    );
  }
}
