import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/pantun_model.dart';
import '../controllers/pantun_controller.dart';

class PantunView extends GetView<PantunController> {
  const PantunView({
    super.key,
  });

  static const Color primaryColor = Color(0xFF2F9C95);
  static const Color darkColor = Color(0xFF14213D);
  static const Color secondaryText = Color(0xFF73809A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FCFC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: darkColor,
          ),
        ),

        title: Column(
          children: [
            Text(
              'Pantun Serawai',
              style: GoogleFonts.poppins(
                color: darkColor,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Pilih pantun yang ingin dipelajari',
              style: GoogleFonts.poppins(
                color: secondaryText,
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        centerTitle: true,
      ),

      body: Obx(
        () {
          // =========================================
          // LOADING
          // =========================================

          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          // =========================================
          // ERROR
          // =========================================

          if (controller.errorMessage.value.isNotEmpty) {
            return _buildError();
          }

          // =========================================
          // EMPTY
          // =========================================

          if (controller.pantunList.isEmpty) {
            return _buildEmpty();
          }

          // =========================================
          // DATA
          // =========================================

          return RefreshIndicator(
            color: primaryColor,
            onRefresh: controller.refreshPantun,

            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),

              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                30,
              ),

              children: [
                // =====================================
                // HEADER CARD
                // =====================================

                _buildHeaderCard(),

                const SizedBox(height: 22),

                // =====================================
                // SECTION TITLE
                // =====================================

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Daftar Pantun',
                        style: GoogleFonts.poppins(
                          color: darkColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F6F3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${controller.pantunList.length} pantun',
                        style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // =====================================
                // LIST
                // =====================================

                ...List.generate(
                  controller.pantunList.length,
                  (index) {
                    final pantun =
                        controller.pantunList[index];

                    return _buildPantunCard(
                      pantun,
                      index,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFDFF8F6),
            Color(0xFFEAF8FF),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),

        borderRadius: BorderRadius.circular(26),
      ),

      child: Row(
        children: [
          // ========================================
          // ICON
          // ========================================

          Container(
            width: 78,
            height: 78,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.8),
              borderRadius: BorderRadius.circular(22),
            ),

            child: Image.asset(
              'assets/images/daunicon.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 15),

          // ========================================
          // TEXT
          // ========================================

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Belajar Melalui Pantun',
                  style: GoogleFonts.poppins(
                    color: darkColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Pilih pantun, pahami maknanya, '
                  'kemudian lengkapi kata yang rumpang.',
                  style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_rounded,
                      color: Color(0xFFF3AF34),
                      size: 16,
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        'Belajar sambil bermain!',
                        style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PANTUN CARD
  // ============================================================

  Widget _buildPantunCard(
    PantunModel pantun,
    int index,
  ) {
    final theme = _getTheme(
      pantun.kategori,
    );

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),

        child: InkWell(
          borderRadius: BorderRadius.circular(22),

          onTap: () {
            controller.openPantun(
              pantun,
            );
          },

          child: Ink(
            padding: const EdgeInsets.all(13),

            decoration: BoxDecoration(
              color: theme.background,
              borderRadius: BorderRadius.circular(22),
            ),

            child: Row(
              children: [
                // ===================================
                // NUMBER + IMAGE
                // ===================================

                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: theme.iconBackground,
                        borderRadius: BorderRadius.circular(19),
                      ),

                      child: _buildCategoryImage(
                        pantun.kategori,
                      ),
                    ),

                    Positioned(
                      top: -5,
                      left: -5,

                      child: Container(
                        width: 31,
                        height: 31,

                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          color: theme.color,
                          shape: BoxShape.circle,

                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),

                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),

                // ===================================
                // INFORMATION
                // ===================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        pantun.judul,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: GoogleFonts.poppins(
                          color: darkColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        pantun.kategori,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: GoogleFonts.poppins(
                          color: secondaryText,
                          fontSize: 10,
                        ),
                      ),

                      const SizedBox(height: 9),

                      Wrap(
                        spacing: 7,
                        runSpacing: 5,

                        children: [
                          _buildChip(
                            icon: Icons.school_rounded,
                            text:
                                pantun.level.isEmpty
                                    ? '-'
                                    : pantun.level,
                            color: theme.color,
                            background:
                                theme.chipBackground,
                          ),

                          _buildChip(
                            icon: Icons.music_note_rounded,
                            text:
                                pantun.polaRima.isEmpty
                                    ? '-'
                                    : pantun.polaRima,
                            color: theme.color,
                            background:
                                theme.chipBackground,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ===================================
                // ARROW
                // ===================================

                Container(
                  width: 42,
                  height: 42,

                  decoration: BoxDecoration(
                    color: theme.buttonBackground,
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: darkColor,
                    size: 27,
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
  // CHIP
  // ============================================================

  Widget _buildChip({
    required IconData icon,
    required String text,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: color,
          ),

          const SizedBox(width: 4),

          Text(
            text,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORY IMAGE
  // ============================================================

  Widget _buildCategoryImage(
    String category,
  ) {
    final path =
        _getCategoryAsset(
      category,
    );

    if (path == null) {
      return const Icon(
        Icons.auto_stories_rounded,
        color: primaryColor,
        size: 40,
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.contain,

      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return const Icon(
          Icons.auto_stories_rounded,
          color: primaryColor,
        );
      },
    );
  }

  // ============================================================
  // ASSET
  // ============================================================

  String? _getCategoryAsset(
    String name,
  ) {
    switch (
        name.toLowerCase().trim()) {
      case 'nasihat':
        return 'assets/images/kategori/daunicon.png';

      case 'cinta':
        return 'assets/images/kategori/hearthicon.png';

      case 'alam':
        return 'assets/images/kategori/mountainicon.png';

      case 'budaya':
        return 'assets/images/kategori/rumahicon.png';

      case 'sosial':
        return 'assets/images/kategori/socialicon.png';

      default:
        return null;
    }
  }

  // ============================================================
  // THEME
  // ============================================================

  _PantunTheme _getTheme(
    String category,
  ) {
    switch (
        category.toLowerCase().trim()) {
      case 'nasihat':
        return const _PantunTheme(
          color: Color(0xFF4AA95E),
          background: Color(0xFFF0F9E9),
          iconBackground: Color(0xFFE0F3D6),
          chipBackground: Color(0xFFDDF1D5),
          buttonBackground: Color(0xFFDCF1D7),
        );

      case 'cinta':
        return const _PantunTheme(
          color: Color(0xFFF1657B),
          background: Color(0xFFFFF0F3),
          iconBackground: Color(0xFFFFE1E7),
          chipBackground: Color(0xFFFFDCE4),
          buttonBackground: Color(0xFFFFDEE5),
        );

      case 'alam':
        return const _PantunTheme(
          color: Color(0xFF5196C7),
          background: Color(0xFFEDF7FE),
          iconBackground: Color(0xFFDCEFFA),
          chipBackground: Color(0xFFDCEEF9),
          buttonBackground: Color(0xFFDCECF7),
        );

      case 'budaya':
        return const _PantunTheme(
          color: Color(0xFFE09536),
          background: Color(0xFFFFF6E6),
          iconBackground: Color(0xFFFFEAC7),
          chipBackground: Color(0xFFFFE8C3),
          buttonBackground: Color(0xFFFFE8C5),
        );

      case 'sosial':
        return const _PantunTheme(
          color: Color(0xFF8062D0),
          background: Color(0xFFF5F1FF),
          iconBackground: Color(0xFFEAE2FF),
          chipBackground: Color(0xFFE7DFFF),
          buttonBackground: Color(0xFFE8E1FA),
        );

      default:
        return const _PantunTheme(
          color: primaryColor,
          background: Color(0xFFEDF9F7),
          iconBackground: Color(0xFFDDF2EF),
          chipBackground: Color(0xFFDDF2EF),
          buttonBackground: Color(0xFFDDF2EF),
        );
    }
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty() {
    return RefreshIndicator(
      color: primaryColor,
      onRefresh: controller.refreshPantun,

      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),

        children: [
          const SizedBox(height: 150),

          const Icon(
            Icons.auto_stories_outlined,
            size: 80,
            color: primaryColor,
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              'Belum ada data pantun.',
              style: GoogleFonts.poppins(
                color: darkColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 70,
              color: Color(0xFFE36B6B),
            ),

            const SizedBox(height: 16),

            Text(
              controller.errorMessage.value,

              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(
                color: secondaryText,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed:
                  controller.loadPantun,

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryColor,

                foregroundColor:
                    Colors.white,

                elevation: 0,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),

              icon: const Icon(
                Icons.refresh_rounded,
              ),

              label: const Text(
                'Coba Lagi',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// THEME MODEL
// ============================================================

class _PantunTheme {
  final Color color;
  final Color background;
  final Color iconBackground;
  final Color chipBackground;
  final Color buttonBackground;

  const _PantunTheme({
    required this.color,
    required this.background,
    required this.iconBackground,
    required this.chipBackground,
    required this.buttonBackground,
  });
}