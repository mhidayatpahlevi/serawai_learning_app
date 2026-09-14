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
  static const Color backgroundColor = Color(0xFFF9FCFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

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

          // ====================================================
          // CONTENT
          // ====================================================

          return RefreshIndicator(
            color: primaryColor,
            onRefresh: controller.loadData,

            child: ListView(
              padding: EdgeInsets.zero,

              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),

              children: [
                // ===============================================
                // TOP
                // ===============================================

                _buildTopSection(
                  context,
                ),

                // ===============================================
                // CONTENT
                // ===============================================

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
                      _buildSectionHeader(),

                      const SizedBox(
                        height: 14,
                      ),

                      // ==========================================
                      // CATEGORY LIST
                      // ==========================================

                      ...controller.categories.map(
                        (category) {
                          return _buildCategoryCard(
                            category,
                          );
                        },
                      ),

                      const SizedBox(
                        height: 8,
                      ),

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
    const double levelCardHeight = 116;

    final double headerHeight =
        statusBar + appBarHeight;

    final double totalHeight =
        headerHeight +
        bannerHeight +
        levelCardHeight -
        28;

    return SizedBox(
      height: totalHeight,

      child: Stack(
        clipBehavior: Clip.none,

        children: [
          // ====================================================
          // BACKGROUND
          // ====================================================

          Positioned(
            top: 0,
            left: 0,
            right: 0,

            height:
                headerHeight +
                bannerHeight,

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
          // APP BAR MANUAL
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
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      Text(
                        'Kategori Pantun',

                        textAlign: TextAlign.center,

                        style: GoogleFonts.poppins(
                          fontSize: 21,
                          color: darkColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(
                        height: 1,
                      ),

                      Text(
                        'Pilih kategori untuk memulai belajar',

                        textAlign: TextAlign.center,

                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                // Supaya judul benar-benar berada di tengah
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

              width: double.infinity,

              fit: BoxFit.cover,

              alignment: Alignment.center,

              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return _buildBannerFallback();
              },
            ),
          ),

          // ====================================================
          // LEVEL CARD
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
  // BANNER FALLBACK
  // ============================================================

  Widget _buildBannerFallback() {
    return Container(
      width: double.infinity,

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFDDF8F4),
            Color(0xFFE8F9FF),
          ],
        ),
      ),

      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 28,
              ),

              child: Text(
                '“Setiap pantun\n'
                'menyimpan pelajaran\n'
                'untuk kehidupan”',

                style: GoogleFonts.poppins(
                  color: darkColor,
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(
              right: 28,
            ),

            child: Icon(
              Icons.auto_stories_rounded,
              color: primaryColor,
              size: 80,
            ),
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
            ? 0.0
            : unlocked / total;

    return Container(
      constraints: const BoxConstraints(
        minHeight: 112,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.97,
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
            width: 68,
            height: 68,

            decoration: BoxDecoration(
              color: const Color(
                0xFFE5F8F5,
              ),

              borderRadius: BorderRadius.circular(
                22,
              ),
            ),

            child: Center(
              child: Container(
                width: 50,
                height: 50,

                decoration: const BoxDecoration(
                  color: Color(
                    0xFFFFD769,
                  ),

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.workspace_premium_rounded,
                  size: 32,
                  color: Color(
                    0xFFF4A72C,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            width: 13,
          ),

          // ====================================================
          // LEVEL
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              mainAxisSize:
                  MainAxisSize.min,

              children: [
                Text(
                  'Level Anda',

                  style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 10,
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
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  'Terbuka sampai kategori $unlocked',

                  maxLines: 1,

                  overflow:
                      TextOverflow.ellipsis,

                  style: GoogleFonts.poppins(
                    color: const Color(
                      0xFF586A88,
                    ),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          // ====================================================
          // COUNTER
          // ====================================================

          SizedBox(
            width: 82,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,

              mainAxisSize:
                  MainAxisSize.min,

              children: [
                Text(
                  '$unlocked/$total',

                  style: GoogleFonts.poppins(
                    color: darkColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                Text(
                  'Kategori',

                  style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 9,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  child:
                      LinearProgressIndicator(
                    value: progress,

                    minHeight: 7,

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

        Material(
          color: Colors.transparent,

          child: InkWell(
            borderRadius: BorderRadius.circular(
              30,
            ),

            onTap: () {
              Get.snackbar(
                'Panduan Belajar',
                'Pilih kategori yang terbuka dan selesaikan latihan untuk membuka kategori berikutnya.',

                snackPosition:
                    SnackPosition.BOTTOM,

                margin:
                    const EdgeInsets.all(
                  16,
                ),

                borderRadius:
                    16,

                backgroundColor:
                    Colors.white,

                colorText:
                    darkColor,

                icon:
                    const Icon(
                  Icons.menu_book_rounded,
                  color: primaryColor,
                ),
              );
            },

            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),

              decoration: BoxDecoration(
                color: const Color(
                  0xFFE1F7F4,
                ),

                borderRadius:
                    BorderRadius.circular(
                  30,
                ),
              ),

              child: Row(
                mainAxisSize:
                    MainAxisSize.min,

                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    color: primaryColor,
                    size: 17,
                  ),

                  const SizedBox(
                    width: 5,
                  ),

                  Text(
                    'Panduan',

                    style: GoogleFonts.poppins(
                      color: const Color(
                        0xFF187E77,
                      ),
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
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

    final Color cardColor =
        unlocked
            ? theme.backgroundColor
            : const Color(
                0xFFF1F3F5,
              );

    final Color titleColor =
        unlocked
            ? darkColor
            : const Color(
                0xFF838D9B,
              );

    final Color descriptionColor =
        unlocked
            ? secondaryText
            : const Color(
                0xFFA0A8B2,
              );

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      child: Material(
        color: Colors.transparent,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        child: InkWell(
          borderRadius:
              BorderRadius.circular(
            22,
          ),

          // Tetap panggil controller,
          // karena controller Anda sudah menangani kategori terkunci.
          onTap: () {
            controller.openCategory(
              category,
            );
          },

          child: Ink(
            padding:
                const EdgeInsets.all(
              13,
            ),

            decoration: BoxDecoration(
              color: cardColor,

              borderRadius:
                  BorderRadius.circular(
                22,
              ),

              border: Border.all(
                color: unlocked
                    ? theme.color.withOpacity(
                        0.05,
                      )
                    : const Color(
                        0xFFE5E8EC,
                      ),
              ),
            ),

            child: Row(
              children: [
                // =================================================
                // IMAGE + NUMBER
                // =================================================

                Stack(
                  clipBehavior:
                      Clip.none,

                  children: [
                    Container(
                      width: 82,
                      height: 82,

                      padding:
                          const EdgeInsets.all(
                        13,
                      ),

                      decoration:
                          BoxDecoration(
                        color: unlocked
                            ? theme
                                .iconBackground
                            : const Color(
                                0xFFE5E8EA,
                              ),

                        borderRadius:
                            BorderRadius
                                .circular(
                          19,
                        ),
                      ),

                      child: Opacity(
                        opacity:
                            unlocked
                                ? 1.0
                                : 0.40,

                        child:
                            _buildCategoryImage(
                          category.nama,
                        ),
                      ),
                    ),

                    // =================================================
                    // NUMBER
                    // =================================================

                    Positioned(
                      top: -5,
                      left: -5,

                      child: Container(
                        width: 36,
                        height: 36,

                        alignment:
                            Alignment.center,

                        decoration:
                            BoxDecoration(
                          color: unlocked
                              ? theme.color
                              : const Color(
                                  0xFF9CA5AF,
                                ),

                          shape:
                              BoxShape.circle,

                          border:
                              Border.all(
                            color:
                                Colors.white,
                            width:
                                2,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black
                                      .withOpacity(
                                0.08,
                              ),

                              blurRadius:
                                  5,
                            ),
                          ],
                        ),

                        child: Text(
                          '${category.order}',

                          style:
                              GoogleFonts.poppins(
                            color:
                                Colors.white,

                            fontSize:
                                14,

                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  width: 14,
                ),

                // =================================================
                // INFORMATION
                // =================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      // =============================================
                      // NAME
                      // =============================================

                      Text(
                        category.nama,

                        maxLines:
                            1,

                        overflow:
                            TextOverflow.ellipsis,

                        style:
                            GoogleFonts.poppins(
                          color:
                              titleColor,

                          fontSize:
                              16,

                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),

                      // =============================================
                      // DESCRIPTION
                      // =============================================

                      if (category
                          .description
                          .trim()
                          .isNotEmpty) ...[
                        const SizedBox(
                          height: 2,
                        ),

                        Text(
                          category.description,

                          maxLines:
                              2,

                          overflow:
                              TextOverflow.ellipsis,

                          style:
                              GoogleFonts.poppins(
                            color:
                                descriptionColor,

                            fontSize:
                                10,

                            height:
                                1.35,
                          ),
                        ),
                      ],

                      const SizedBox(
                        height: 8,
                      ),

                      // =============================================
                      // BOTTOM INFORMATION
                      // =============================================

                      Wrap(
                        spacing: 8,
                        runSpacing: 6,

                        crossAxisAlignment:
                            WrapCrossAlignment.center,

                        children: [
                          // =========================================
                          // LEVEL
                          // =========================================

                          Row(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [
                              _buildLevelBars(
                                unlocked
                                    ? theme.color
                                    : const Color(
                                        0xFF9EA7B0,
                                      ),
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      7,

                                  vertical:
                                      3,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: unlocked
                                      ? theme.chipColor
                                      : const Color(
                                          0xFFE1E4E7,
                                        ),

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
                                    color: unlocked
                                        ? theme.color
                                        : const Color(
                                            0xFF8A939D,
                                          ),

                                    fontSize:
                                        8,

                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // =========================================
                          // TOTAL PANTUN
                          // =========================================

                          Row(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [
                              Icon(
                                Icons
                                    .description_outlined,

                                size:
                                    15,

                                color: unlocked
                                    ? secondaryText
                                    : const Color(
                                        0xFFA0A8B2,
                                      ),
                              ),

                              const SizedBox(
                                width: 4,
                              ),

                              Text(
                                '${category.totalPantun} pantun',

                                style:
                                    GoogleFonts.poppins(
                                  color: unlocked
                                      ? secondaryText
                                      : const Color(
                                          0xFFA0A8B2,
                                        ),

                                  fontSize:
                                      9,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 7,
                ),

                // =================================================
                // ARROW / LOCK
                // =================================================

                Container(
                  width: 46,
                  height: 46,

                  decoration:
                      BoxDecoration(
                    color: unlocked
                        ? theme.buttonColor
                        : const Color(
                            0xFFE1E4E8,
                          ),

                    shape:
                        BoxShape.circle,
                  ),

                  child: Icon(
                    unlocked
                        ? Icons
                            .chevron_right_rounded
                        : Icons
                            .lock_rounded,

                    size:
                        unlocked
                            ? 28
                            : 22,

                    color:
                        unlocked
                            ? theme.color
                            : const Color(
                                0xFF9CA5B0,
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
          width: 4,
          height: 8,

          decoration:
              BoxDecoration(
            color: color,

            borderRadius:
                BorderRadius.circular(
              2,
            ),
          ),
        ),

        const SizedBox(
          width: 2,
        ),

        Container(
          width: 4,
          height: 13,

          decoration:
              BoxDecoration(
            color: color,

            borderRadius:
                BorderRadius.circular(
              2,
            ),
          ),
        ),

        const SizedBox(
          width: 2,
        ),

        Container(
          width: 4,
          height: 17,

          decoration:
              BoxDecoration(
            color: color.withOpacity(
              0.55,
            ),

            borderRadius:
                BorderRadius.circular(
              2,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // NORMALISASI CATEGORY
  // ============================================================

  String _categoryKey(
    String name,
  ) {
    final String value =
        name
            .toLowerCase()
            .trim()
            .replaceAll(
              '_',
              ' ',
            )
            .replaceAll(
              '-',
              ' ',
            )
            .replaceAll(
              RegExp(r'\s+'),
              ' ',
            );

    if (value.contains(
      'nasihat',
    )) {
      return 'nasihat';
    }

    if (value.contains(
      'jenaka',
    )) {
      return 'jenaka';
    }

    if (value.contains(
          'teka teki',
        ) ||
        value.contains(
          'teka',
        )) {
      return 'teka teki';
    }

    if (value.contains(
      'kiasan',
    )) {
      return 'kiasan';
    }

    if (value.contains(
      'agama',
    )) {
      return 'agama';
    }

    return value;
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

    final IconData fallbackIcon =
        _getCategoryFallbackIcon(
      name,
    );

    final Color color =
        _getTheme(
      name,
    ).color;

    // ==========================================================
    // JIKA ASSET TIDAK DITEMUKAN
    // ==========================================================

    if (asset == null) {
      return Icon(
        fallbackIcon,
        color: color,
        size: 42,
      );
    }

    // ==========================================================
    // ASSET
    // ==========================================================

    return Image.asset(
      asset,

      width: 55,
      height: 55,

      fit: BoxFit.contain,

      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        // Kalau file asset belum tersedia,
        // aplikasi tetap menampilkan icon fallback.

        return Icon(
          fallbackIcon,
          color: color,
          size: 42,
        );
      },
    );
  }

  // ============================================================
  // CATEGORY ASSET
  // ============================================================

  String? _getCategoryAsset(
    String name,
  ) {
    switch (_categoryKey(name)) {
      // ========================================================
      // NASIHAT
      // ========================================================

      case 'nasihat':
        return 'assets/images/kategori/daunicon.png';

      // ========================================================
      // JENAKA
      // ========================================================

      case 'jenaka':

        // Saat ini memakai asset yang sudah ada di project Anda.
        // Kalau nanti punya jenakaicon.png, ubah path ini.
        return 'assets/images/kategori/jenaka.png';

      // ========================================================
      // TEKA-TEKI
      // ========================================================

      case 'teka teki':

        // Saat ini memakai asset yang sudah ada.
        return 'assets/images/kategori/teki.png';

      // ========================================================
      // KIASAN
      // ========================================================

      case 'kiasan':

        // Saat ini memakai asset yang sudah ada.
        return 'assets/images/kategori/socialicon.png';

      // ========================================================
      // AGAMA
      // ========================================================

      case 'agama':

        // Saat ini memakai asset yang sudah ada.
        return 'assets/images/kategori/hearthicon.png';

      default:
        return null;
    }
  }

  // ============================================================
  // FALLBACK ICON
  // ============================================================

  IconData _getCategoryFallbackIcon(
    String name,
  ) {
    switch (_categoryKey(name)) {
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
  // CATEGORY THEME
  // ============================================================

  _CategoryTheme _getTheme(
    String name,
  ) {
    switch (_categoryKey(name)) {
      // ========================================================
      // NASIHAT - HIJAU
      // ========================================================

      case 'nasihat':
        return const _CategoryTheme(
          color: Color(
            0xFF4EAD5F,
          ),

          backgroundColor: Color(
            0xFFF0FAE9,
          ),

          iconBackground: Color(
            0xFFE2F6D7,
          ),

          chipColor: Color(
            0xFFDCF3D5,
          ),

          buttonColor: Color(
            0xFFDDF4D7,
          ),
        );

      // ========================================================
      // JENAKA - ORANGE
      // ========================================================

      case 'jenaka':
        return const _CategoryTheme(
          color: Color(
            0xFFF29B38,
          ),

          backgroundColor: Color(
            0xFFFFF6E6,
          ),

          iconBackground: Color(
            0xFFFFEAC8,
          ),

          chipColor: Color(
            0xFFFFEAC5,
          ),

          buttonColor: Color(
            0xFFFFE8C0,
          ),
        );

      // ========================================================
      // TEKA-TEKI - BIRU
      // ========================================================

      case 'teka teki':
        return const _CategoryTheme(
          color: Color(
            0xFF5193C1,
          ),

          backgroundColor: Color(
            0xFFEDF7FF,
          ),

          iconBackground: Color(
            0xFFDCEFFC,
          ),

          chipColor: Color(
            0xFFDDEFFC,
          ),

          buttonColor: Color(
            0xFFDCEAF5,
          ),
        );

      // ========================================================
      // KIASAN - UNGU
      // ========================================================

      case 'kiasan':
        return const _CategoryTheme(
          color: Color(
            0xFF8264D0,
          ),

          backgroundColor: Color(
            0xFFF5F1FF,
          ),

          iconBackground: Color(
            0xFFEAE3FF,
          ),

          chipColor: Color(
            0xFFE9E1FF,
          ),

          buttonColor: Color(
            0xFFE9E2FA,
          ),
        );

      // ========================================================
      // AGAMA - TOSCA
      // ========================================================

      case 'agama':
        return const _CategoryTheme(
          color: Color(
            0xFF359F83,
          ),

          backgroundColor: Color(
            0xFFECF9F5,
          ),

          iconBackground: Color(
            0xFFDDF4EC,
          ),

          chipColor: Color(
            0xFFD9F1E9,
          ),

          buttonColor: Color(
            0xFFDDF3EC,
          ),
        );

      // ========================================================
      // DEFAULT
      // ========================================================

      default:
        return const _CategoryTheme(
          color: primaryColor,

          backgroundColor: Color(
            0xFFEDF9F7,
          ),

          iconBackground: Color(
            0xFFDDF3EF,
          ),

          chipColor: Color(
            0xFFDDF3EF,
          ),

          buttonColor: Color(
            0xFFDDF3EF,
          ),
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
        horizontal: 18,
        vertical: 20,
      ),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE0F8F6),
            Color(0xFFEEFBFC),
          ],

          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),

        borderRadius:
            BorderRadius.circular(
          23,
        ),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.eco_rounded,
            size: 35,
            color: Color(
              0xFF359E78,
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          Expanded(
            child: Text(
              '“Melestarikan Pantun Serawai,\n'
              'Melangkah ke Masa Depan”',

              textAlign:
                  TextAlign.center,

              style:
                  GoogleFonts.poppins(
                color:
                    const Color(
                  0xFF657891,
                ),

                fontSize:
                    11,

                height:
                    1.5,

                fontStyle:
                    FontStyle.italic,

                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          const Icon(
            Icons.eco_outlined,
            size: 35,
            color: Color(
              0xFF64C7B0,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(
            30,
          ),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Container(
                width: 82,
                height: 82,

                decoration:
                    const BoxDecoration(
                  color: Color(
                    0xFFE3F7F3,
                  ),

                  shape:
                      BoxShape.circle,
                ),

                child: const Icon(
                  Icons.auto_stories_outlined,
                  size: 43,
                  color: primaryColor,
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              Text(
                'Belum Ada Kategori',

                style:
                    GoogleFonts.poppins(
                  fontSize:
                      18,

                  color:
                      darkColor,

                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(
                height: 5,
              ),

              Text(
                'Kategori pantun belum tersedia.',

                textAlign:
                    TextAlign.center,

                style:
                    GoogleFonts.poppins(
                  color:
                      secondaryText,

                  fontSize:
                      11,
                ),
              ),

              const SizedBox(
                height: 22,
              ),

              ElevatedButton.icon(
                onPressed:
                    controller.loadData,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      primaryColor,

                  foregroundColor:
                      Colors.white,

                  elevation:
                      0,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal:
                        20,

                    vertical:
                        12,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),

                icon:
                    const Icon(
                  Icons.refresh_rounded,
                ),

                label:
                    Text(
                  'Muat Ulang',

                  style:
                      GoogleFonts.poppins(
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(
            30,
          ),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Container(
                width: 82,
                height: 82,

                decoration:
                    const BoxDecoration(
                  color: Color(
                    0xFFFFEDED,
                  ),

                  shape:
                      BoxShape.circle,
                ),

                child:
                    const Icon(
                  Icons.cloud_off_rounded,
                  size: 40,
                  color: Color(
                    0xFFE66969,
                  ),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              Text(
                'Gagal Memuat Kategori',

                style:
                    GoogleFonts.poppins(
                  fontSize:
                      18,

                  color:
                      darkColor,

                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(
                controller
                    .errorMessage
                    .value,

                textAlign:
                    TextAlign.center,

                style:
                    GoogleFonts.poppins(
                  color:
                      secondaryText,

                  fontSize:
                      11,

                  height:
                      1.5,
                ),
              ),

              const SizedBox(
                height: 22,
              ),

              ElevatedButton.icon(
                onPressed:
                    controller.loadData,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      primaryColor,

                  foregroundColor:
                      Colors.white,

                  elevation:
                      0,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal:
                        20,

                    vertical:
                        12,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),

                icon:
                    const Icon(
                  Icons.refresh_rounded,
                ),

                label:
                    Text(
                  'Coba Lagi',

                  style:
                      GoogleFonts.poppins(
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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
    if (value
        .trim()
        .isEmpty) {
      return '-';
    }

    final String text =
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