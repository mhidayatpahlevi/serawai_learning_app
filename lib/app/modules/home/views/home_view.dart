import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const Color primaryColor = Color(0xFF2F9C95);
  static const Color darkColor = Color(0xFF14213D);
  static const Color textSecondary = Color(0xFF7D8AA4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FCFC),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================================
              // HEADER
              // ==========================================================
              _buildHeader(),

              const SizedBox(height: 26),

              // ==========================================================
              // SEARCH
              // ==========================================================
              _buildSearchBar(),

              const SizedBox(height: 20),

              // ==========================================================
              // HERO / LATIHAN UTAMA
              // ==========================================================
              _buildMainExerciseCard(),

              const SizedBox(height: 14),

              // ==========================================================
              // MENU LATIHAN + RIWAYAT
              // ==========================================================
              Row(
                children: [
                  Expanded(
                    child: _buildSmallMenuCard(
                      title: 'Latihan\nPantun',
                      subtitle: 'Asah kemampuanmu',
                      icon: Icons.menu_book_rounded,
                      backgroundColor: const Color(0xFFFFF6DF),
                      iconColor: const Color(0xFFFFB839),
                      onTap: () {
                        Get.toNamed(Routes.kategori);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSmallMenuCard(
                      title: 'Riwayat &\nProgres',
                      subtitle: 'Lihat perkembanganmu',
                      icon: Icons.auto_graph_rounded,
                      backgroundColor: const Color(0xFFFFE9EC),
                      iconColor: Color(0xFFF16C88),
                      onTap: () {
                        Get.toNamed(Routes.riwayat);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==========================================================
              // PANTUN HARI INI
              // ==========================================================
              _buildDailyPantun(),

              const SizedBox(height: 26),

              // ==========================================================
              // NLP
              // ==========================================================
              _buildNlpCard(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Halo,',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF526078),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                controller.nama.isEmpty ? 'Pengguna' : controller.nama,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: darkColor,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Yuk, bermain sambil belajar\npantun Serawai!',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0CF),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 38,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 5),

            InkWell(
              onTap: controller.logout,
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 14,
                      color: textSecondary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 11,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // SEARCH BAR
  // ============================================================

  Widget _buildSearchBar() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE8EFF2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Cari pantun, kata, atau kategori...',
          hintStyle: TextStyle(
            color: Color(0xFFA3ADBD),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: darkColor,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HERO CARD
  // ============================================================

  Widget _buildMainExerciseCard() {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      gradient: const LinearGradient(
        colors: [
          Color(0xFFEAF9F8),
          Color(0xFFDFF5EF),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Row(
        children: [
          // ======================================
          // TEKS
          // ======================================
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                10,
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rangkai Kata\nLengkapi Pantun',
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                      color: darkColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Isi kata yang rumpang dan\n'
                    'temukan maknanya!',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: Color(0xFF526078),
                    ),
                  ),

                  const SizedBox(height: 16),

                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.kategori);
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 43,
                      height: 43,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ======================================
          // GAMBAR
          // ======================================
          Expanded(
            flex: 5,
            child: SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(26),
                  bottomRight: Radius.circular(26),
                ),
                child: Image.asset(
                  'assets/images/cardhome.png',

                  // agar gambar memenuhi area
                  fit: BoxFit.cover,

                  // fokuskan karakter ke tengah
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  // ============================================================
  // SMALL MENU CARD
  // ============================================================

  Widget _buildSmallMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 125,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.15,
                          fontWeight: FontWeight.w800,
                          color: darkColor,
                        ),
                      ),
                    ),
                    Icon(
                      icon,
                      size: 31,
                      color: iconColor,
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF56627A),
                  ),
                ),

                const SizedBox(height: 9),

                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 17,
                      color: darkColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  Widget _buildCategory({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.kategori);
      },
      child: Container(
        height: 104,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 34,
              color: iconColor,
            ),
            const SizedBox(height: 9),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: darkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PANTUN HARI INI
  // ============================================================

  Widget _buildDailyPantun() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Text(
                'Pantun Pilihan Hari Ini',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: darkColor,
                ),
              ),
            ),
            Icon(
              Icons.bookmark_border_rounded,
              color: primaryColor,
              size: 21,
            ),
            SizedBox(width: 4),
            Text(
              'Simpan',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),

        const SizedBox(height: 13),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFE7F8F7),
                Color(0xFFEAF8FC),
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  '“',
                  style: TextStyle(
                    height: .8,
                    fontSize: 54,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF70C6BF),
                  ),
                ),
              ),

              const SizedBox(width: 7),

              const Expanded(
                child: Text(
                  'Alangkah alap malam ini,\n'
                  'Luak malam tigau puluh.\n'
                  'Alangkah alap jemau ini,\n'
                  'Luak cingkuk ngegai buluh.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.55,
                    color: Color(0xFF344057),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // NLP
  // ============================================================

  Widget _buildNlpCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFFFE9B7),
                child: Icon(
                  Icons.psychology_alt_rounded,
                  color: Color(0xFFEBA83A),
                  size: 27,
                ),
              ),

              SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analisis NLP',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: darkColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Jawaban dianalisis berdasarkan tiga aspek.',
                      style: TextStyle(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                _buildFeatureItem(
                  icon: Icons.translate_rounded,
                  title: 'Kesesuaian Makna',
                  subtitle: 'Kata sesuai dengan arti pantun',
                  iconBackground: const Color(0xFFE5F7EF),
                  iconColor: const Color(0xFF3AA780),
                ),
                const Divider(height: 1),
                _buildFeatureItem(
                  icon: Icons.subject_rounded,
                  title: 'Kesesuaian Konteks',
                  subtitle: 'Kata sesuai dengan konteks kalimat',
                  iconBackground: const Color(0xFFE8F3FC),
                  iconColor: const Color(0xFF549BC8),
                ),
                const Divider(height: 1),
                _buildFeatureItem(
                  icon: Icons.music_note_rounded,
                  title: 'Kesesuaian Rima',
                  subtitle: 'Kata sesuai dengan pola rima pantun',
                  iconBackground: const Color(0xFFFFE9EC),
                  iconColor: const Color(0xFFE56C7C),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBackground,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: darkColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF43AF8F),
            size: 24,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  

  }
