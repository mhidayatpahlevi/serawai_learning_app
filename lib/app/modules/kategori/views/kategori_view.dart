import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/category_model.dart';
import '../controllers/kategori_controller.dart';

class KategoriView extends GetView<KategoriController> {
  const KategoriView({
    super.key,
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryColor = Color(0xFF2F9C95);
  static const Color darkColor = Color(0xFF13213D);
  static const Color secondaryText = Color(0xFF73809A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFC),

      body: Obx(
        () {
          // ====================================================
          // LOADING
          // ====================================================

          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
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

          if (controller.categories.isEmpty) {
            return _buildEmpty();
          }

          return RefreshIndicator(
            color: primaryColor,
            onRefresh: controller.loadData,

            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),

              padding: EdgeInsets.zero,

              children: [
                // =================================================
                // HEADER + BANNER + LEVEL
                // =================================================

                _buildTopSection(context),

                // =================================================
                // CONTENT
                // =================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    30,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // =============================================
                      // URUTAN BELAJAR
                      // =============================================

                      _buildSectionHeader(),

                      const SizedBox(height: 14),

                      // =============================================
                      // CATEGORY LIST
                      // =============================================

                      ...controller.categories.map(
                        (category) {
                          return _buildCategoryCard(
                            category,
                          );
                        },
                      ),

                      const SizedBox(height: 8),

                      // =============================================
                      // FOOTER QUOTE
                      // =============================================

                      _buildFooter(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // TOP SECTION
  // ============================================================

  Widget _buildTopSection(
    BuildContext context,
  ) {
    final double statusBar =
        MediaQuery.of(context).padding.top;

    const double appBarHeight = 64;
    const double bannerHeight = 190;
    const double levelHeight = 115;

    final double headerHeight =
        statusBar + appBarHeight;

    final double totalHeight =
        headerHeight +
        bannerHeight +
        levelHeight -
        30;

    return SizedBox(
      height: totalHeight,

      child: Stack(
        clipBehavior: Clip.none,

        children: [
          // ====================================================
          // BACKGROUND HEADER
          // ====================================================

          Positioned(
            top: 0,
            left: 0,
            right: 0,

            height: headerHeight + bannerHeight,

            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE7F9FC),
                    Color(0xFFDFF6F2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // ====================================================
          // APPBAR
          // ====================================================

          Positioned(
            top: statusBar + 4,
            left: 10,
            right: 10,

            height: 58,

            child: Row(
              children: [
                SizedBox(
                  width: 45,
                  height: 45,

                  child: Material(
                    color: Colors.transparent,

                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        50,
                      ),

                      onTap: () {
                        Get.back();
                      },

                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: darkColor,
                        size: 28,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text(
                        'Kategori Pantun',

                        style: GoogleFonts.poppins(
                          fontSize: 21,
                          color: darkColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 1),

                      Text(
                        'Pilih kategori untuk memulai belajar',

                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                // Agar judul tetap center
                const SizedBox(
                  width: 45,
                ),
              ],
            ),
          ),

          // ====================================================
          // BANNER
          // ====================================================

          Positioned(
            top: headerHeight,
            left: 0,
            right: 0,

            height: bannerHeight,

            child: Image.asset(
              'assets/images/kategori/banner.png',

              fit: BoxFit.cover,

              alignment: Alignment.center,

              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  color: const Color(0xFFE3F7F2),

                  alignment: Alignment.center,

                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: primaryColor,
                    size: 80,
                  ),
                );
              },
            ),
          ),

          // ====================================================
          // LEVEL CARD OVERLAP
          // ====================================================

          Positioned(
            top:
                headerHeight +
                bannerHeight -
                32,

            left: 16,
            right: 16,

            child: _buildLevelCard(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LEVEL CARD
  // ============================================================

  Widget _buildLevelCard() {
    final int total =
        controller.categories.length;

    final int unlocked =
        controller.highestUnlockedCategory.value
            .clamp(
              0,
              total,
            )
            .toInt();

    final double progress =
        total == 0
            ? 0
            : unlocked / total;

    return Container(
      constraints: const BoxConstraints(
        minHeight: 112,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.96,
        ),

        borderRadius: BorderRadius.circular(
          28,
        ),

        border: Border.all(
          color: Colors.white,
          width: 2,
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF83BDB8,
            ).withOpacity(
              0.15,
            ),

            blurRadius: 20,

            offset: const Offset(
              0,
              8,
            ),
          ),
        ],
      ),

      child: Row(
        children: [
          // ====================================================
          // MEDAL
          // ====================================================

          Container(
            width: 74,
            height: 74,

            decoration: BoxDecoration(
              color: const Color(
                0xFFE5F8F5,
              ),

              borderRadius: BorderRadius.circular(
                24,
              ),
            ),

            child: Center(
              child: Container(
                width: 52,
                height: 52,

                decoration: const BoxDecoration(
                  color: Color(
                    0xFFFFD769,
                  ),

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.workspace_premium_rounded,
                  size: 34,
                  color: Color(
                    0xFFF4A72C,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 15),

          // ====================================================
          // LEVEL INFORMATION
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Level Anda',

                  style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Text(
                  controller.userLevel.value
                      .toUpperCase(),

                  maxLines: 1,

                  overflow:
                      TextOverflow.ellipsis,

                  style: GoogleFonts.poppins(
                    color: darkColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  'Kategori terbuka sampai $unlocked',

                  maxLines: 1,

                  overflow:
                      TextOverflow.ellipsis,

                  style: GoogleFonts.poppins(
                    color: const Color(
                      0xFF586A88,
                    ),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ====================================================
          // PROGRESS
          // ====================================================

          SizedBox(
            width: 95,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                Text(
                  '$unlocked/$total',

                  style: GoogleFonts.poppins(
                    color: darkColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                Text(
                  'Kategori',

                  style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 12),

                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),

                  child: LinearProgressIndicator(
                    value: progress,

                    minHeight: 8,

                    backgroundColor:
                        const Color(
                      0xFFD9ECEB,
                    ),

                    valueColor:
                        const AlwaysStoppedAnimation<
                            Color>(
                      primaryColor,
                    ),
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
            'Urutan Belajar',

            style: GoogleFonts.poppins(
              color: darkColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 8,
          ),

          decoration: BoxDecoration(
            color: const Color(
              0xFFE1F7F4,
            ),

            borderRadius: BorderRadius.circular(
              30,
            ),
          ),

          child: Row(
            children: [
              const Icon(
                Icons.menu_book_rounded,
                color: primaryColor,
                size: 18,
              ),

              const SizedBox(width: 5),

              Text(
                'Lihat Panduan',

                style: GoogleFonts.poppins(
                  color: const Color(
                    0xFF187E77,
                  ),
                  fontSize: 11,
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
  // CATEGORY CARD
  // ============================================================

  Widget _buildCategoryCard(
    CategoryModel category,
  ) {
    final bool unlocked =
        controller.isUnlocked(
      category,
    );

    final _CategoryTheme theme =
        _getTheme(
      category.nama,
    );

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      child: Material(
        color: Colors.transparent,

        borderRadius: BorderRadius.circular(
          22,
        ),

        child: InkWell(
          borderRadius: BorderRadius.circular(
            22,
          ),

          onTap: () {
            controller.openCategory(
              category,
            );
          },

          child: Ink(
            padding: const EdgeInsets.all(
              13,
            ),

            decoration: BoxDecoration(
              color: unlocked
                  ? theme.backgroundColor
                  : theme.backgroundColor.withOpacity(
                      0.62,
                    ),

              borderRadius: BorderRadius.circular(
                22,
              ),
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
                      width: 88,
                      height: 88,

                      padding: const EdgeInsets.all(
                        15,
                      ),

                      decoration: BoxDecoration(
                        color:
                            theme.iconBackground,

                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Opacity(
                        opacity: unlocked
                            ? 1
                            : 0.60,

                        child:
                            _buildCategoryImage(
                          category.nama,
                        ),
                      ),
                    ),

                    Positioned(
                      top: -5,
                      left: -5,

                      child: Container(
                        width: 38,
                        height: 38,

                        alignment:
                            Alignment.center,

                        decoration:
                            BoxDecoration(
                          color: unlocked
                              ? theme.color
                              : theme.color
                                  .withOpacity(
                                  0.72,
                                ),

                          shape:
                              BoxShape.circle,

                          border:
                              Border.all(
                            color:
                                Colors.white,
                            width: 2,
                          ),
                        ),

                        child: Text(
                          '${category.order}',

                          style:
                              GoogleFonts.poppins(
                            color:
                                Colors.white,
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 15),

                // =================================================
                // INFORMATION
                // =================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        category.nama,

                        maxLines: 1,

                        overflow:
                            TextOverflow.ellipsis,

                        style: GoogleFonts.poppins(
                          color: darkColor,
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),

                      if (category
                          .description
                          .trim()
                          .isNotEmpty) ...[
                        const SizedBox(
                          height: 2,
                        ),

                        Text(
                          category.description,

                          maxLines: 2,

                          overflow:
                              TextOverflow.ellipsis,

                          style:
                              GoogleFonts.poppins(
                            color:
                                secondaryText,
                            fontSize: 11,
                            height: 1.35,
                          ),
                        ),
                      ],

                      const SizedBox(height: 8),

                      // =============================================
                      // BOTTOM INFORMATION
                      // =============================================

                      Wrap(
                        spacing: 9,
                        runSpacing: 6,

                        crossAxisAlignment:
                            WrapCrossAlignment.center,

                        children: [
                          // Level indicator
                          Row(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [
                              _buildLevelBars(
                                theme.color,
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      theme.chipColor,

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    20,
                                  ),
                                ),

                                child: Text(
                                  'Level: ${_capitalize(category.level)}',

                                  style:
                                      GoogleFonts.poppins(
                                    color:
                                        theme.color,
                                    fontSize: 9,
                                    fontWeight:
                                        FontWeight
                                            .w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Total pantun
                          Row(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [
                              const Icon(
                                Icons
                                    .description_outlined,
                                size: 16,
                                color:
                                    secondaryText,
                              ),

                              const SizedBox(
                                width: 4,
                              ),

                              Text(
                                '${category.totalPantun} pantun',

                                style:
                                    GoogleFonts.poppins(
                                  color:
                                      secondaryText,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // =================================================
                // ARROW / LOCK
                // =================================================

                Container(
                  width: 48,
                  height: 48,

                  decoration: BoxDecoration(
                    color: unlocked
                        ? theme.buttonColor
                        : const Color(
                            0xFFE1E4EB,
                          ),

                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    unlocked
                        ? Icons.chevron_right_rounded
                        : Icons.lock_rounded,

                    size: unlocked
                        ? 29
                        : 23,

                    color: unlocked
                        ? darkColor
                        : const Color(
                            0xFF9EA6B4,
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
  // LEVEL BARS
  // ============================================================

  Widget _buildLevelBars(
    Color color,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.end,

      children: [
        Container(
          width: 5,
          height: 9,

          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              2,
            ),
          ),
        ),

        const SizedBox(width: 2),

        Container(
          width: 5,
          height: 15,

          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              2,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CATEGORY IMAGE
  // ============================================================

  Widget _buildCategoryImage(
    String name,
  ) {
    final String? asset =
        _getCategoryAsset(
      name,
    );

    if (asset == null) {
      return const Icon(
        Icons.auto_stories_rounded,
        color: primaryColor,
        size: 42,
      );
    }

    return Image.asset(
      asset,

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

      case 'agama':
        return 'assets/images/kategori/hearthicon.png';

      case 'teka-teki':
        return 'assets/images/kategori/mountainicon.png';

      case 'jenaka':
        return 'assets/images/kategori/rumahicon.png';

      case 'kiasan':
        return 'assets/images/kategori/socialicon.png';

      default:
        return null;
    }
  }

  // ============================================================
  // CATEGORY THEME
  // ============================================================

  _CategoryTheme _getTheme(
    String name,
  ) {
    switch (
        name.toLowerCase().trim()) {
      case 'nasihat':
        return const _CategoryTheme(
          color: Color(0xFF4EAD5F),
          backgroundColor: Color(0xFFF0FAE9),
          iconBackground: Color(0xFFE2F6D7),
          chipColor: Color(0xFFDCF3D5),
          buttonColor: Color(0xFFDDF4D7),
        );

      case 'agama':
        return const _CategoryTheme(
          color: Color(0xFFF0657D),
          backgroundColor: Color(0xFFFFF0F2),
          iconBackground: Color(0xFFFFE2E6),
          chipColor: Color(0xFFFFDDE5),
          buttonColor: Color(0xFFFFDDE4),
        );

      case 'teka-teki':
        return const _CategoryTheme(
          color: Color(0xFF5193C1),
          backgroundColor: Color(0xFFEDF7FF),
          iconBackground: Color(0xFFDCEFFC),
          chipColor: Color(0xFFDDEFFC),
          buttonColor: Color(0xFFDCEAF5),
        );

      case 'jenaka':
        return const _CategoryTheme(
          color: Color(0xFFE29536),
          backgroundColor: Color(0xFFFFF6E6),
          iconBackground: Color(0xFFFFECCB),
          chipColor: Color(0xFFFFEAC5),
          buttonColor: Color(0xFFFFE8C0),
        );

      case 'kiasan':
        return const _CategoryTheme(
          color: Color(0xFF8264D0),
          backgroundColor: Color(0xFFF5F1FF),
          iconBackground: Color(0xFFEAE3FF),
          chipColor: Color(0xFFE9E1FF),
          buttonColor: Color(0xFFE9E2FA),
        );

      default:
        return const _CategoryTheme(
          color: primaryColor,
          backgroundColor: Color(0xFFEDF9F7),
          iconBackground: Color(0xFFDDF3EF),
          chipColor: Color(0xFFDDF3EF),
          buttonColor: Color(0xFFDDF3EF),
        );
    }
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 22,
      ),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE0F8F6),
            Color(0xFFEEFBFC),
          ],
        ),

        borderRadius: BorderRadius.circular(
          23,
        ),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.eco_rounded,
            size: 38,
            color: Color(0xFF359E78),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              '“Melestarikan Pantun Serawai,\n'
              'Melangkah ke Masa Depan”',

              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(
                color: const Color(
                  0xFF657891,
                ),
                fontSize: 12,
                height: 1.5,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 10),

          const Icon(
            Icons.eco_outlined,
            size: 38,
            color: Color(0xFF64C7B0),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Icon(
            Icons.auto_stories_outlined,
            size: 70,
            color: primaryColor,
          ),

          const SizedBox(height: 15),

          Text(
            'Belum ada kategori',

            style: GoogleFonts.poppins(
              fontSize: 18,
              color: darkColor,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed:
                controller.loadData,

            icon: const Icon(
              Icons.refresh,
            ),

            label: const Text(
              'Muat Ulang',
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
        padding: const EdgeInsets.all(
          30,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 65,
              color: Color(0xFFE66969),
            ),

            const SizedBox(height: 15),

            Text(
              'Gagal memuat kategori',

              style: GoogleFonts.poppins(
                fontSize: 18,
                color: darkColor,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 7),

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
                  controller.loadData,

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryColor,

                foregroundColor:
                    Colors.white,
              ),

              icon: const Icon(
                Icons.refresh,
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

  // ============================================================
  // CAPITALIZE
  // ============================================================

  String _capitalize(
    String value,
  ) {
    if (value.trim().isEmpty) {
      return value;
    }

    final text =
        value.trim();

    return '${text[0].toUpperCase()}'
        '${text.substring(1).toLowerCase()}';
  }
}

// ============================================================
// CATEGORY THEME MODEL
// ============================================================

class _CategoryTheme {
  final Color color;
  final Color backgroundColor;
  final Color iconBackground;
  final Color chipColor;
  final Color buttonColor;

  const _CategoryTheme({
    required this.color,
    required this.backgroundColor,
    required this.iconBackground,
    required this.chipColor,
    required this.buttonColor,
  });
}