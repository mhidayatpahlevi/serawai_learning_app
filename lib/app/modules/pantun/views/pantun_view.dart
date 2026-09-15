import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/pantun_model.dart';
import '../controllers/pantun_controller.dart';

class PantunView extends GetView<PantunController> {
  const PantunView({super.key});

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryColor = Color(0xFF2F9C95);
  static const Color darkColor = Color(0xFF14213D);
  static const Color secondaryText = Color(0xFF73809A);
  static const Color backgroundColor = Color(0xFFF8FCFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },

          icon: const Icon(Icons.arrow_back_rounded, color: darkColor),
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

      body: Obx(() {
        // ====================================================
        // LOADING
        // ====================================================

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        // ====================================================
        // ERROR
        // ====================================================

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildError();
        }

        // ====================================================
        // EMPTY
        // ====================================================

        if (controller.pantunList.isEmpty) {
          return _buildEmpty();
        }

        // ====================================================
        // CONTENT
        // ====================================================

        return RefreshIndicator(
          color: primaryColor,
          onRefresh: controller.refreshPantun,

          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),

            padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),

            children: [
              // ===============================================
              // HEADER
              // ===============================================

              _buildHeaderCard(),

              const SizedBox(height: 22),

              // ===============================================
              // SECTION HEADER
              // ===============================================
              _buildSectionHeader(),

              const SizedBox(height: 12),

              // ===============================================
              // LIST PANTUN
              // ===============================================
              ...List.generate(controller.pantunList.length, (index) {
                final PantunModel pantun = controller.pantunList[index];

                return _buildPantunCard(pantun, index);
              }),

              const SizedBox(height: 5),

              // ===============================================
              // FOOTER
              // ===============================================
              _buildFooter(),
            ],
          ),
        );
      }),
    );
  }

  // ============================================================
  // HEADER CARD
  // ============================================================

  Widget _buildHeaderCard() {
    final String category = controller.pantunList.isNotEmpty
        ? controller.pantunList.first.kategori
        : '';

    final _PantunTheme theme = _getTheme(category);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.background, Colors.white],

          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),

        borderRadius: BorderRadius.circular(26),

        border: Border.all(color: theme.color.withOpacity(0.08)),
      ),

      child: Row(
        children: [
          // ====================================================
          // CATEGORY ICON
          // ====================================================

          Container(
            width: 78,
            height: 78,

            padding: const EdgeInsets.all(13),

            decoration: BoxDecoration(
              color: theme.iconBackground,

              borderRadius: BorderRadius.circular(22),
            ),

            child: _buildCategoryImage(category, size: 52),
          ),

          const SizedBox(width: 15),

          // ====================================================
          // HEADER INFORMATION
          // ====================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Kumpulan Pantun',

                  style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  '${controller.pantunList.length} Pantun',

                  style: GoogleFonts.poppins(
                    color: darkColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: theme.chipBackground,

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(
                        _getCategoryFallbackIcon(category),

                        size: 14,
                        color: theme.color,
                      ),

                      const SizedBox(width: 5),

                      Flexible(
                        child: Text(
                          category.isEmpty ? 'Pantun' : category,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: GoogleFonts.poppins(
                            color: theme.color,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _getCategoryDescription(category),

                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 9,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader() {
    return Row(
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
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),

          decoration: BoxDecoration(
            color: const Color(0xFFE3F6F3),

            borderRadius: BorderRadius.circular(20),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              const Icon(
                Icons.auto_stories_rounded,
                size: 14,
                color: primaryColor,
              ),

              const SizedBox(width: 4),

              Text(
                '${controller.pantunList.length} pantun',

                style: GoogleFonts.poppins(
                  color: primaryColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PANTUN CARD
  // ============================================================

  Widget _buildPantunCard(PantunModel pantun, int index) {
    final _PantunTheme theme = _getTheme(pantun.kategori);

    final int number = pantun.orderInCategory > 0
        ? pantun.orderInCategory
        : index + 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      child: Material(
        color: Colors.transparent,

        borderRadius: BorderRadius.circular(22),

        child: InkWell(
          borderRadius: BorderRadius.circular(22),

          onTap: () {
            controller.openPantun(pantun);
          },

          child: Ink(
            padding: const EdgeInsets.all(13),

            decoration: BoxDecoration(
              color: theme.background,

              borderRadius: BorderRadius.circular(22),

              border: Border.all(color: theme.color.withOpacity(0.05)),
            ),

            child: Row(
              children: [
                // =================================================
                // ICON + NUMBER
                // =================================================

                Stack(
                  clipBehavior: Clip.none,

                  children: [
                    Container(
                      width: 76,
                      height: 76,

                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: theme.iconBackground,

                        borderRadius: BorderRadius.circular(19),
                      ),

                      child: _buildCategoryImage(pantun.kategori, size: 52),
                    ),

                    Positioned(
                      top: -5,
                      left: -5,

                      child: Container(
                        width: 32,
                        height: 32,

                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          color: theme.color,

                          shape: BoxShape.circle,

                          border: Border.all(color: Colors.white, width: 2),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),

                              blurRadius: 5,
                            ),
                          ],
                        ),

                        child: Text(
                          '$number',

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

                // =================================================
                // INFORMATION
                // =================================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

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

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Icon(
                            _getCategoryFallbackIcon(pantun.kategori),

                            size: 13,
                            color: theme.color,
                          ),

                          const SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              'Kategori: ${pantun.kategori}',

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: GoogleFonts.poppins(
                                color: secondaryText,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 9),

                      Wrap(
                        spacing: 7,
                        runSpacing: 6,

                        children: [
                          _buildChip(
                            icon: Icons.school_rounded,

                            text:
                                'Level: ${pantun.level.isEmpty ? '-' : _capitalize(pantun.level)}',

                            color: theme.color,

                            background: theme.chipBackground,
                          ),

                          _buildChip(
                            icon: Icons.music_note_rounded,

                            text:
                                'Rima: ${pantun.polaRima.isEmpty ? '-' : pantun.polaRima}',

                            color: theme.color,

                            background: theme.chipBackground,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 7),

                // =================================================
                // ARROW
                // =================================================
                Container(
                  width: 42,
                  height: 42,

                  decoration: BoxDecoration(
                    color: theme.buttonBackground,
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: theme.color,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      decoration: BoxDecoration(
        color: background,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, size: 12, color: color),

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
  // NORMALISASI CATEGORY
  // ============================================================

  String _categoryKey(String category) {
    final String value = category
        .toLowerCase()
        .trim()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');

    if (value.contains('nasihat')) {
      return 'nasihat';
    }

    if (value.contains('jenaka')) {
      return 'jenaka';
    }

    if (value.contains('teka')) {
      return 'teka teki';
    }

    if (value.contains('kiasan')) {
      return 'kiasan';
    }

    if (value.contains('agama')) {
      return 'agama';
    }

    return value;
  }

  // ============================================================
  // CATEGORY IMAGE
  // ============================================================

  Widget _buildCategoryImage(String category, {double size = 45}) {
    final String? path = _getCategoryAsset(category);

    final IconData fallback = _getCategoryFallbackIcon(category);

    final Color color = _getTheme(category).color;

    if (path == null) {
      return Icon(fallback, color: color, size: size);
    }

    return Image.asset(
      path,

      width: size,
      height: size,

      fit: BoxFit.contain,

      errorBuilder: (context, error, stackTrace) {
        return Icon(fallback, color: color, size: size);
      },
    );
  }

  // ============================================================
  // CATEGORY ASSET
  // ============================================================

  String? _getCategoryAsset(String category) {
    switch (_categoryKey(category)) {
      case 'nasihat':
        return 'assets/images/kategori/daunicon.png';

      case 'jenaka':
        return 'assets/images/kategori/jenakaicon.png';

      case 'teka teki':
        return 'assets/images/kategori/tekatekiicon.png';

      case 'kiasan':
        return 'assets/images/kategori/kiasanicon.png';

      case 'agama':
        return 'assets/images/kategori/agamaicon.png';

      default:
        return null;
    }
  }

  // ============================================================
  // FALLBACK ICON
  // ============================================================

  IconData _getCategoryFallbackIcon(String category) {
    switch (_categoryKey(category)) {
      case 'nasihat':
        return Icons.eco_rounded;

      case 'jenaka':
        return Icons.sentiment_very_satisfied_rounded;

      case 'teka teki':
        return Icons.help_outline_rounded;

      case 'kiasan':
        return Icons.format_quote_rounded;

      case 'agama':
        return Icons.menu_book_rounded;

      default:
        return Icons.auto_stories_rounded;
    }
  }

  // ============================================================
  // CATEGORY DESCRIPTION
  // ============================================================

  String _getCategoryDescription(String category) {
    switch (_categoryKey(category)) {
      case 'nasihat':
        return 'Pelajari pesan kehidupan dan petuah melalui pantun.';

      case 'jenaka':
        return 'Belajar Bahasa Serawai melalui pantun yang lucu dan menghibur.';

      case 'teka teki':
        return 'Asah kemampuan berpikir melalui pantun teka-teki yang seru.';

      case 'kiasan':
        return 'Temukan makna tersirat di balik kata-kata dalam pantun.';

      case 'agama':
        return 'Pelajari nilai kebaikan dan pesan keagamaan melalui pantun.';

      default:
        return 'Pilih pantun dan mulai perjalanan belajarmu.';
    }
  }

  // ============================================================
  // THEME
  // ============================================================

  _PantunTheme _getTheme(String category) {
    switch (_categoryKey(category)) {
      // ========================================================
      // NASIHAT
      // ========================================================

      case 'nasihat':
        return const _PantunTheme(
          color: Color(0xFF4AA95E),
          background: Color(0xFFF0F9E9),
          iconBackground: Color(0xFFE0F3D6),
          chipBackground: Color(0xFFDDF1D5),
          buttonBackground: Color(0xFFDCF1D7),
        );

      // ========================================================
      // JENAKA
      // ========================================================

      case 'jenaka':
        return const _PantunTheme(
          color: Color(0xFFF09B36),
          background: Color(0xFFFFF6E8),
          iconBackground: Color(0xFFFFE8C3),
          chipBackground: Color(0xFFFFEAC8),
          buttonBackground: Color(0xFFFFE6BA),
        );

      // ========================================================
      // TEKA-TEKI
      // ========================================================

      case 'teka teki':
        return const _PantunTheme(
          color: Color(0xFF4E94D1),
          background: Color(0xFFEDF7FF),
          iconBackground: Color(0xFFDCEEFF),
          chipBackground: Color(0xFFDDEFFC),
          buttonBackground: Color(0xFFDCECF8),
        );

      // ========================================================
      // KIASAN
      // ========================================================

      case 'kiasan':
        return const _PantunTheme(
          color: Color(0xFF8062D0),
          background: Color(0xFFF5F1FF),
          iconBackground: Color(0xFFEAE2FF),
          chipBackground: Color(0xFFE7DFFF),
          buttonBackground: Color(0xFFE8E1FA),
        );

      // ========================================================
      // AGAMA
      // ========================================================

      case 'agama':
        return const _PantunTheme(
          color: Color(0xFF359F83),
          background: Color(0xFFECF9F5),
          iconBackground: Color(0xFFDDF4EC),
          chipBackground: Color(0xFFD9F1E9),
          buttonBackground: Color(0xFFDDF3EC),
        );

      // ========================================================
      // DEFAULT
      // ========================================================

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
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE5F9F6), Color(0xFFF0FBFC)],
        ),

        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        children: [
          const Icon(Icons.eco_rounded, color: Color(0xFF48AD83), size: 28),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              '“Belajar pantun, mengenal bahasa,\n'
              'melestarikan budaya Serawai.”',

              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(
                color: secondaryText,
                fontSize: 10,
                height: 1.5,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 8),

          const Icon(Icons.auto_stories_rounded, color: primaryColor, size: 27),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty() {
    return RefreshIndicator(
      color: primaryColor,

      onRefresh: controller.refreshPantun,

      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),

        children: [
          const SizedBox(height: 150),

          Container(
            width: 85,
            height: 85,

            margin: const EdgeInsets.symmetric(horizontal: 150),

            decoration: const BoxDecoration(
              color: Color(0xFFE4F7F4),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.auto_stories_outlined,

              size: 43,

              color: primaryColor,
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              'Belum Ada Pantun',

              style: GoogleFonts.poppins(
                color: darkColor,

                fontSize: 17,

                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Center(
            child: Text(
              'Belum ada data pantun pada kategori ini.',

              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(color: secondaryText, fontSize: 10),
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
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 80,

              height: 80,

              decoration: const BoxDecoration(
                color: Color(0xFFFFECEC),

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.cloud_off_rounded,

                size: 40,

                color: Color(0xFFE36B6B),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Gagal Memuat Pantun',

              style: GoogleFonts.poppins(
                color: darkColor,

                fontSize: 18,

                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              controller.errorMessage.value,

              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(
                color: secondaryText,

                fontSize: 11,

                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: controller.loadPantun,

              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,

                foregroundColor: Colors.white,

                elevation: 0,

                padding: const EdgeInsets.symmetric(
                  horizontal: 20,

                  vertical: 12,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              icon: const Icon(Icons.refresh_rounded),

              label: Text(
                'Coba Lagi',

                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CAPITALIZE
  // ============================================================

  String _capitalize(String value) {
    if (value.trim().isEmpty) {
      return '-';
    }

    final String text = value.trim();

    return '${text[0].toUpperCase()}'
        '${text.substring(1).toLowerCase()}';
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
