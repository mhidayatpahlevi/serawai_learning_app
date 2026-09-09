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
  static const Color darkColor = Color(0xFF17233F);
  static const Color secondaryText = Color(0xFF718096);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF7),

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
            return _buildErrorState();
          }

          // ====================================================
          // EMPTY
          // ====================================================

          if (controller.categories.isEmpty) {
            return _buildEmptyState();
          }

          // ====================================================
          // CONTENT
          // ====================================================

          return RefreshIndicator(
            color: primaryColor,
            onRefresh: controller.loadData,

            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),

              slivers: [
                // ==============================================
                // HEADER + BANNER
                // ==============================================

                SliverToBoxAdapter(
                  child: _buildHeader(
                    context,
                  ),
                ),

                // ==============================================
                // LEVEL
                // ==============================================

                SliverToBoxAdapter(
                  child: _buildLevelInfo(),
                ),

                // ==============================================
                // LEARNING PATH
                // ==============================================

                SliverToBoxAdapter(
                  child: _buildLearningPath(),
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

  Widget _buildHeader(
    BuildContext context,
  ) {
    final double statusBar =
        MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFBEEAF8),
            Color(0xFFDDF7F1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

      child: Column(
        children: [
          // ====================================================
          // APPBAR MANUAL
          // ====================================================

          Padding(
            padding: EdgeInsets.fromLTRB(
              12,
              statusBar + 5,
              12,
              8,
            ),

            child: Row(
              children: [
                SizedBox(
                  width: 44,
                  height: 44,

                  child: Material(
                    color: Colors.transparent,

                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),

                      onTap: () {
                        Get.back();
                      },

                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: darkColor,
                        size: 27,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Kategori Pantun',

                        textAlign: TextAlign.center,

                        style: GoogleFonts.poppins(
                          color: darkColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 1),

                      Text(
                        'Jelajahi perjalanan belajarmu',

                        textAlign: TextAlign.center,

                        style: GoogleFonts.poppins(
                          color: secondaryText,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                // supaya judul benar-benar center
                const SizedBox(
                  width: 44,
                ),
              ],
            ),
          ),

          // ====================================================
          // BANNER FULL WIDTH
          // ====================================================

          SizedBox(
            width: double.infinity,

            child: AspectRatio(
              aspectRatio: 16 / 8.5,

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
        color: Color(0xFFDDF6EE),
      ),

      padding: const EdgeInsets.all(
        22,
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              '“Setiap pantun\n'
              'menyimpan pelajaran\n'
              'untuk kehidupan”',

              style: GoogleFonts.poppins(
                color: darkColor,
                fontSize: 16,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const Icon(
            Icons.auto_stories_rounded,
            size: 70,
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LEVEL INFO
  // ============================================================

  Widget _buildLevelInfo() {
    final int totalCategory =
        controller.categories.length;

    final int unlocked =
        controller.highestUnlockedCategory.value
            .clamp(
              0,
              totalCategory,
            )
            .toInt();

    final double progress =
        totalCategory == 0
            ? 0.0
            : unlocked / totalCategory;

    return Container(
      // jarak kecil agar dekat dengan banner
      margin: const EdgeInsets.fromLTRB(
        16,
        6,
        16,
        10,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(
          22,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.07,
            ),
            blurRadius: 14,
            offset: const Offset(
              0,
              5,
            ),
          ),
        ],
      ),

      child: Row(
        children: [
          // ====================================================
          // BADGE
          // ====================================================

          Container(
            width: 58,
            height: 58,

            decoration: const BoxDecoration(
              color: Color(0xFFFFE7A5),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.workspace_premium_rounded,
              size: 33,
              color: Color(0xFFF2A126),
            ),
          ),

          const SizedBox(width: 13),

          // ====================================================
          // LEVEL TEXT
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Level Anda',

                  style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  controller.userLevel.value
                      .toUpperCase(),

                  maxLines: 1,

                  overflow:
                      TextOverflow.ellipsis,

                  style: GoogleFonts.poppins(
                    color: darkColor,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 7),

                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,

                    backgroundColor:
                        const Color(
                      0xFFDCEDEA,
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

          const SizedBox(width: 16),

          // ====================================================
          // COUNTER
          // ====================================================

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,

            children: [
              Text(
                '$unlocked/$totalCategory',

                style: GoogleFonts.poppins(
                  color: darkColor,
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              Text(
                'Terbuka',

                style: GoogleFonts.poppins(
                  color: secondaryText,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LEARNING PATH
  // ============================================================

  Widget _buildLearningPath() {
    final List<CategoryModel> categories =
        controller.categories;

    return Stack(
      children: [
        // ======================================================
        // BACKGROUND IMAGE
        // ======================================================

        Positioned.fill(
          child: Image.asset(
            'assets/images/kategori/learning_path_bg.png',

            fit: BoxFit.fill,

            alignment: Alignment.topCenter,

            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return Container(
                color: const Color(
                  0xFFC8E7A4,
                ),
              );
            },
          ),
        ),

        // ======================================================
        // OVERLAY TIPIS
        // ======================================================

        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(
                      0.02,
                    ),
                    Colors.white.withOpacity(
                      0.01,
                    ),
                    const Color(
                      0xFFEAF7D8,
                    ).withOpacity(
                      0.05,
                    ),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),

        // ======================================================
        // CONTENT
        // ======================================================

        Padding(
          padding: const EdgeInsets.fromLTRB(
            14,
            25,
            14,
            28,
          ),

          child: Column(
            children: [
              // =================================================
              // TITLE
              // =================================================

              Container(
                width: double.infinity,

                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),

                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.87,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  border: Border.all(
                    color: Colors.white.withOpacity(
                      0.7,
                    ),
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.05,
                      ),
                      blurRadius: 10,
                      offset: const Offset(
                        0,
                        4,
                      ),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Text(
                      'Mulai Perjalanan Belajarmu',

                      textAlign: TextAlign.center,

                      style: GoogleFonts.poppins(
                        color: darkColor,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      'Selesaikan setiap kategori untuk '
                      'membuka perjalanan berikutnya',

                      textAlign: TextAlign.center,

                      style: GoogleFonts.poppins(
                        color: secondaryText,
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // =================================================
              // CATEGORY PATH
              // =================================================

              ...List.generate(
                categories.length,
                (index) {
                  return _buildPathItem(
                    category:
                        categories[index],
                    index: index,
                  );
                },
              ),

              const SizedBox(height: 20),

              // =================================================
              // QUOTE
              // =================================================

              _buildQuote(),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PATH ITEM
  // ============================================================

  Widget _buildPathItem({
    required CategoryModel category,
    required int index,
  }) {
    final bool unlocked =
        controller.isUnlocked(
      category,
    );

    final bool isLeft =
        index.isEven;

    final Color color =
        _getCategoryColor(
      category.nama,
    );

    return SizedBox(
      height: 150,

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,

        children:
            isLeft

                // =================================================
                // POSISI KIRI
                // =================================================

                ? [
                    _buildNumberNode(
                      category,
                      unlocked,
                      color,
                    ),

                    const SizedBox(
                      width: 7,
                    ),

                    Expanded(
                      child:
                          _buildCategoryCard(
                        category,
                        unlocked,
                        color,
                      ),
                    ),

                    const SizedBox(
                      width: 28,
                    ),
                  ]

                // =================================================
                // POSISI KANAN
                // =================================================

                : [
                    const SizedBox(
                      width: 28,
                    ),

                    Expanded(
                      child:
                          _buildCategoryCard(
                        category,
                        unlocked,
                        color,
                      ),
                    ),

                    const SizedBox(
                      width: 7,
                    ),

                    _buildNumberNode(
                      category,
                      unlocked,
                      color,
                    ),
                  ],
      ),
    );
  }

  // ============================================================
  // NUMBER NODE
  // ============================================================

  Widget _buildNumberNode(
    CategoryModel category,
    bool unlocked,
    Color color,
  ) {
    return SizedBox(
      width: 68,
      height: 88,

      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,

        children: [
          // ====================================================
          // NUMBER
          // ====================================================

          Container(
            width: 65,
            height: 65,

            alignment: Alignment.center,

            decoration: BoxDecoration(
              color: unlocked
                  ? color
                  : const Color(
                      0xFF8999A5,
                    ),

              shape: BoxShape.circle,

              border: Border.all(
                color: Colors.white,
                width: 5,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    0.15,
                  ),
                  blurRadius: 8,
                  offset: const Offset(
                    0,
                    4,
                  ),
                ),
              ],
            ),

            child: Text(
              '${category.order}',

              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 25,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),

          // ====================================================
          // LOCK / CHECK KECIL
          // ====================================================

          Positioned(
            top: 57,

            child: Container(
              width: 25,
              height: 25,

              decoration: BoxDecoration(
                color: Colors.white,

                shape: BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.08,
                    ),
                    blurRadius: 4,
                  ),
                ],
              ),

              child: Icon(
                unlocked
                    ? Icons.check_rounded
                    : Icons.lock_rounded,

                size: 15,

                color: unlocked
                    ? color
                    : const Color(
                        0xFF939EA8,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORY CARD
  // ============================================================

  Widget _buildCategoryCard(
    CategoryModel category,
    bool unlocked,
    Color color,
  ) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(
          19,
        ),

        onTap: () {
          controller.openCategory(
            category,
          );
        },

        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 88,
          ),

          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),

            decoration: BoxDecoration(
              // sedikit transparan supaya background terlihat
              color: unlocked
                  ? Colors.white.withOpacity(
                      0.91,
                    )
                  : const Color(
                      0xFFE4E8EA,
                    ).withOpacity(
                      0.89,
                    ),

              borderRadius:
                  BorderRadius.circular(
                19,
              ),

              border: Border.all(
                color: Colors.white.withOpacity(
                  0.7,
                ),
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    0.09,
                  ),
                  blurRadius: 12,
                  offset: const Offset(
                    0,
                    5,
                  ),
                ),
              ],
            ),

            child: Row(
              children: [
                // ===============================================
                // CATEGORY IMAGE
                // ===============================================

                Container(
                  width: 52,
                  height: 52,

                  padding:
                      const EdgeInsets.all(
                    5,
                  ),

                  decoration:
                      BoxDecoration(
                    color: unlocked
                        ? color.withOpacity(
                            0.11,
                          )
                        : const Color(
                            0xFFF1F3F4,
                          ),

                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),

                  child:
                      _buildCategoryImage(
                    category.nama,
                    unlocked,
                  ),
                ),

                const SizedBox(width: 10),

                // ===============================================
                // INFORMATION
                // ===============================================

                Expanded(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        category.nama,

                        maxLines: 1,

                        overflow:
                            TextOverflow.ellipsis,

                        style:
                            GoogleFonts.poppins(
                          color: unlocked
                              ? darkColor
                              : const Color(
                                  0xFF89949F,
                                ),

                          fontSize: 14,

                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),

                      const SizedBox(
                        height: 2,
                      ),

                      Text(
                        '${category.totalPantun} pantun',

                        maxLines: 1,

                        overflow:
                            TextOverflow.ellipsis,

                        style:
                            GoogleFonts.poppins(
                          color: unlocked
                              ? secondaryText
                              : const Color(
                                  0xFFA3AAB1,
                                ),

                          fontSize: 9,
                        ),
                      ),

                      if (category
                          .level
                          .isNotEmpty) ...[
                        const SizedBox(
                          height: 4,
                        ),

                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),

                          decoration:
                              BoxDecoration(
                            color: unlocked
                                ? color.withOpacity(
                                    0.11,
                                  )
                                : const Color(
                                    0xFFD7DCE0,
                                  ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),
                          ),

                          child: Text(
                            'Level ${_capitalize(category.level)}',

                            maxLines: 1,

                            overflow:
                                TextOverflow.ellipsis,

                            style:
                                GoogleFonts.poppins(
                              color: unlocked
                                  ? color
                                  : const Color(
                                      0xFF969EA6,
                                    ),

                              fontSize: 8,

                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 4),

                // ===============================================
                // ARROW / LOCK
                // ===============================================

                Icon(
                  unlocked
                      ? Icons
                          .chevron_right_rounded
                      : Icons.lock_rounded,

                  size: 21,

                  color: unlocked
                      ? color
                      : const Color(
                          0xFF9BA4AC,
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
  // CATEGORY IMAGE
  // ============================================================

  Widget _buildCategoryImage(
    String categoryName,
    bool unlocked,
  ) {
    final String? asset =
        _getCategoryAsset(
      categoryName,
    );

    if (asset == null) {
      return Icon(
        Icons.auto_stories_rounded,

        size: 32,

        color: unlocked
            ? primaryColor
            : const Color(
                0xFF9EA7AF,
              ),
      );
    }

    return Opacity(
      opacity: unlocked
          ? 1
          : 0.38,

      child: Image.asset(
        asset,

        fit: BoxFit.contain,

        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return Icon(
            Icons.auto_stories_rounded,

            color: unlocked
                ? primaryColor
                : Colors.grey,
          );
        },
      ),
    );
  }

  // ============================================================
  // ASSET MAPPING
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
  // CATEGORY COLOR
  // ============================================================

  Color _getCategoryColor(
    String name,
  ) {
    switch (
        name.toLowerCase().trim()) {
      case 'nasihat':
        return const Color(
          0xFF47AC60,
        );

      case 'cinta':
        return const Color(
          0xFFF15E79,
        );

      case 'alam':
        return const Color(
          0xFF5598C3,
        );

      case 'budaya':
        return const Color(
          0xFFB87C4C,
        );

      case 'sosial':
        return const Color(
          0xFF8163D4,
        );

      default:
        return primaryColor;
    }
  }

  // ============================================================
  // QUOTE
  // ============================================================

  Widget _buildQuote() {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.symmetric(
        horizontal: 8,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),

      decoration: BoxDecoration(
        color: const Color(
          0xFFFFF8E7,
        ).withOpacity(
          0.92,
        ),

        borderRadius: BorderRadius.circular(
          22,
        ),

        border: Border.all(
          color: Colors.white,
          width: 2,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.07,
            ),
            blurRadius: 10,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Text(
        '“Pantun Serawai,\n'
        'Warisan Kata untuk Generasi Mendatang”',

        textAlign: TextAlign.center,

        style: GoogleFonts.poppins(
          color: const Color(
            0xFF52637A,
          ),
          fontSize: 11,
          height: 1.5,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
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
              Icons.auto_stories_outlined,
              size: 70,
              color: primaryColor,
            ),

            const SizedBox(height: 16),

            Text(
              'Belum Ada Kategori',

              style: GoogleFonts.poppins(
                color: darkColor,
                fontSize: 18,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Kategori pantun belum tersedia.',

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

              icon: const Icon(
                Icons.refresh_rounded,
              ),

              label: const Text(
                'Muat Ulang',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          30,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Container(
              width: 78,
              height: 78,

              decoration:
                  const BoxDecoration(
                color: Color(
                  0xFFFFEDED,
                ),

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.cloud_off_rounded,

                size: 38,

                color: Color(
                  0xFFE26868,
                ),
              ),
            ),

            const SizedBox(height: 17),

            Text(
              'Gagal Memuat Kategori',

              style: GoogleFonts.poppins(
                color: darkColor,
                fontSize: 18,
                fontWeight:
                    FontWeight.w800,
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

                elevation: 0,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),

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

              label: Text(
                'Coba Lagi',

                style: GoogleFonts.poppins(
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HELPER
  // ============================================================

  String _capitalize(
    String value,
  ) {
    if (value.trim().isEmpty) {
      return value;
    }

    final String text =
        value.trim();

    return '${text[0].toUpperCase()}'
        '${text.substring(1).toLowerCase()}';
  }
}