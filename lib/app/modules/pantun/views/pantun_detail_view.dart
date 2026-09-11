import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/category_model.dart';
import '../../../data/models/pantun_model.dart';
import '../../../routes/app_routes.dart';

class PantunDetailView extends StatelessWidget {
  const PantunDetailView({
    super.key,
  });

  static const Color primaryColor =
      Color(0xFF2F9C95);

  static const Color darkColor =
      Color(0xFF14213D);

  static const Color secondaryText =
      Color(0xFF73809A);
  static const Color yellow =
       Color(0xFFFFF6DF);

  @override
  Widget build(
    BuildContext context,
  ) {
    final arguments =
        Get.arguments;

    // ==========================================================
    // VALIDASI
    // ==========================================================

    if (arguments is! Map ||
        arguments['pantun'] is! PantunModel ||
        arguments['category'] is! CategoryModel) {
      return Scaffold(
        backgroundColor:
            const Color(0xFFF8FCFC),

        appBar: AppBar(
          backgroundColor:
              const Color(0xFFF8FCFC),
          elevation: 0,

          title: Text(
            'Detail Pantun',
            style: GoogleFonts.poppins(
              color: darkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        body: Center(
          child: Text(
            'Data pantun atau kategori '
            'tidak ditemukan.',
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    }

    final PantunModel pantun =
        arguments['pantun']
            as PantunModel;

    final CategoryModel category =
        arguments['category']
            as CategoryModel;

    final theme =
        _getTheme(
      category.nama,
    );

    final String level =
        pantun.level.isNotEmpty
            ? pantun.level
            : category.level;

    final double progress =
        category.totalPantun <= 0
            ? 0
            : (pantun.orderInCategory /
                    category.totalPantun)
                .clamp(
                  0.0,
                  1.0,
                );

    return Scaffold(
      backgroundColor:
          const Color(0xFFF8FCFC),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFFF8FCFC),

        surfaceTintColor:
            Colors.transparent,

        elevation: 0,

        leading: IconButton(
          onPressed: Get.back,

          icon: const Icon(
            Icons.arrow_back_rounded,
            color: darkColor,
          ),
        ),

        title: Text(
          'Detail Pantun',

          style: GoogleFonts.poppins(
            color: darkColor,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),

          padding:
              const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            30,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,

            children: [
              // =================================================
              // PROGRESS HEADER
              // =================================================

              _buildProgressCard(
                category,
                pantun,
                progress,
                theme,
              ),

              const SizedBox(height: 16),

              // =================================================
              // MAIN PANTUN CARD
              // =================================================

              Container(
                padding:
                    const EdgeInsets.all(
                  20,
                ),

                decoration:
                    BoxDecoration(
                  gradient:
                      LinearGradient(
                    colors: [
                      theme.background,
                      Colors.white,
                    ],
                    begin:
                        Alignment.topLeft,
                    end:
                        Alignment.bottomRight,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    28,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black
                              .withOpacity(
                        .05,
                      ),

                      blurRadius: 14,

                      offset:
                          const Offset(
                        0,
                        6,
                      ),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    // ================================
                    // IMAGE
                    // ================================

                    Container(
                      width: 100,
                      height: 100,

                      padding:
                          const EdgeInsets.all(
                        19,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            theme.iconBackground,

                        shape:
                            BoxShape.circle,
                      ),

                      child:
                          _buildCategoryImage(
                        category.nama,
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // ================================
                    // CATEGORY CHIP
                    // ================================

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            theme.chipBackground,

                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),
                      ),

                      child: Text(
                        category.nama,

                        style:
                            GoogleFonts.poppins(
                          color:
                              theme.color,

                          fontSize: 10,

                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 11,
                    ),

                    // ================================
                    // TITLE
                    // ================================

                    Text(
                      pantun.judul,

                      textAlign:
                          TextAlign.center,

                      style:
                          GoogleFonts.poppins(
                        color:
                            darkColor,

                        fontSize: 21,

                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    if (category
                        .description
                        .isNotEmpty)
                      Text(
                        category.description,

                        textAlign:
                            TextAlign.center,

                        style:
                            GoogleFonts.poppins(
                          color:
                              secondaryText,

                          fontSize: 11,

                          height: 1.5,
                        ),
                      ),

                    const SizedBox(
                      height: 18,
                    ),

                    // ================================
                    // INSTRUCTION
                    // ================================

                    Container(
                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets
                              .all(
                        14,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white
                                .withOpacity(
                          .85,
                        ),

                        borderRadius:
                            BorderRadius
                                .circular(
                          18,
                        ),
                      ),

                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,

                            decoration:
                                BoxDecoration(
                              color:
                                  const Color(
                                0xFFFFE7A7,
                              ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),
                            ),

                            child:
                                const Icon(
                              Icons
                                  .lightbulb_rounded,

                              color:
                                  Color(
                                0xFFEAA52C,
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child: Text(
                              'Lengkapi pantun Bahasa Serawai '
                              'dengan memilih kata yang paling tepat.',

                              style:
                                  GoogleFonts
                                      .poppins(
                                color:
                                    darkColor,

                                fontSize:
                                    11,

                                height:
                                    1.45,

                                fontWeight:
                                    FontWeight
                                        .w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // =================================================
              // DIFFICULTY + RHYME
              // =================================================

              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      icon:
                          Icons.school_rounded,

                      title:
                          'Tingkat',

                      value:
                          level.isEmpty
                              ? '-'
                              : level,

                      color:
                          theme.color,

                      background:
                          theme.background,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons
                          .music_note_rounded,

                      title: 'Pola Rima',

                      value:
                          pantun
                                  .polaRima
                                  .isEmpty
                              ? '-'
                              : pantun
                                  .polaRima,

                      color:
                          theme.color,

                      background:
                          theme.background,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // =================================================
              // INFO
              // =================================================

              Container(
                padding:
                    const EdgeInsets.all(
                  16,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFEAF8FF,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Container(
                      width: 40,
                      height: 40,

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius
                                .circular(
                          13,
                        ),
                      ),

                      child:
                          const Icon(
                        Icons
                            .info_outline_rounded,

                        color:
                            Color(
                          0xFF5196C7,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            'Setelah latihan',

                            style:
                                GoogleFonts
                                    .poppins(
                              color:
                                  darkColor,

                              fontSize:
                                  12,

                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),

                          const SizedBox(
                            height: 3,
                          ),

                          Text(
                            'Kamu dapat mempelajari pantun lengkap, '
                            'terjemahan Bahasa Indonesia, pola rima, '
                            'dan kosakata.',

                            style:
                                GoogleFonts
                                    .poppins(
                              color:
                                  secondaryText,

                              fontSize:
                                  10,

                              height:
                                  1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // =================================================
              // START BUTTON
              // =================================================

              SizedBox(
                height: 56,

                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(
                      Routes.latihan,

                      arguments: {
                        'pantun':
                            pantun,

                        'category':
                            category,
                      },
                    );
                  },

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
                          BorderRadius
                              .circular(
                        18,
                      ),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [
                      const Icon(
                        Icons
                            .play_circle_fill_rounded,

                        size: 25,
                      ),

                      const SizedBox(
                        width: 9,
                      ),

                      Text(
                        'Mulai Latihan',

                        style:
                            GoogleFonts.poppins(
                          fontSize: 14,

                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      const Icon(
                        Icons
                            .arrow_forward_rounded,

                        size: 20,
                      ),
                    ],
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
  // PROGRESS CARD
  // ============================================================

  Widget _buildProgressCard(
    CategoryModel category,
    PantunModel pantun,
    double progress,
    _DetailTheme theme,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        15,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              .05,
            ),

            blurRadius: 12,

            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  title: 'Kategori',
                  value:
                      category.nama,
                  color:
                      theme.color,
                ),
              ),

              Container(
                width: 1,
                height: 36,
                color:
                    const Color(
                  0xFFE8EDF1,
                ),
              ),

              Expanded(
                child: _InfoItem(
                  title: 'Level',
                  value:
                      category.level,
                  color:
                      theme.color,
                ),
              ),

              Container(
                width: 1,
                height: 36,
                color:
                    const Color(
                  0xFFE8EDF1,
                ),
              ),

              Expanded(
                child: _InfoItem(
                  title: 'Pantun',
                  value:
                      '${pantun.orderInCategory}/${category.totalPantun}',
                  color:
                      theme.color,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 13,
          ),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),

            child:
                LinearProgressIndicator(
              value:
                  progress,

              minHeight:
                  7,

              backgroundColor:
                  const Color(
                0xFFE4ECEB,
              ),

              valueColor:
                  AlwaysStoppedAnimation<
                      Color>(
                theme.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(
        14,
      ),

      decoration:
          BoxDecoration(
        color:
            background,

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Column(
        children: [
          Icon(
            icon,
            color:
                color,
            size: 27,
          ),

          const SizedBox(
            height: 7,
          ),

          Text(
            title,

            style:
                GoogleFonts.poppins(
              color:
                  secondaryText,

              fontSize:
                  9,
            ),
          ),

          const SizedBox(
            height: 2,
          ),

          Text(
            value,

            textAlign:
                TextAlign.center,

            maxLines:
                1,

            overflow:
                TextOverflow
                    .ellipsis,

            style:
                GoogleFonts.poppins(
              color:
                  darkColor,

              fontSize:
                  12,

              fontWeight:
                  FontWeight
                      .w700,
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
    final asset =
        _getCategoryAsset(
      category,
    );

    if (asset == null) {
      return const Icon(
        Icons.auto_stories_rounded,
        color: primaryColor,
      );
    }

    return Image.asset(
      asset,

      fit:
          BoxFit.contain,

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

  _DetailTheme _getTheme(
    String name,
  ) {
    switch (
        name.toLowerCase().trim()) {
      case 'nasihat':
        return const _DetailTheme(
          color: Color(0xFF49A95E),
          background: Color(0xFFF0F9E9),
          iconBackground: Color(0xFFE0F3D6),
          chipBackground: Color(0xFFDDF1D5),
        );

      case 'agama':
        return const _DetailTheme(
          color: Color(0xFFF1657B),
          background: Color(0xFFFFF0F3),
          iconBackground: Color(0xFFFFE1E7),
          chipBackground: Color(0xFFFFDCE4),
        );

      case 'teka-teki':
        return const _DetailTheme(
          color: Color(0xFF5196C7),
          background: Color(0xFFEDF7FE),
          iconBackground: Color(0xFFDCEFFA),
          chipBackground: Color(0xFFDCEEF9),
        );

      case 'jenaka':
        return const _DetailTheme(
          color: Color(0xFFE09536),
          background: Color(0xFFFFF6E6),
          iconBackground: Color(0xFFFFEAC7),
          chipBackground: Color(0xFFFFE8C3),
        );

      case 'kiasan':
        return const _DetailTheme(
          color: Color(0xFF8062D0),
          background: Color(0xFFF5F1FF),
          iconBackground: Color(0xFFEAE2FF),
          chipBackground: Color(0xFFE7DFFF),
        );

      default:
        return const _DetailTheme(
          color: primaryColor,
          background: Color(0xFFEDF9F7),
          iconBackground: Color(0xFFDDF2EF),
          chipBackground: Color(0xFFDDF2EF),
        );
    }
  }
}

// ============================================================
// INFO ITEM
// ============================================================

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _InfoItem({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        Text(
          title,

          style:
              GoogleFonts.poppins(
            color:
                const Color(
              0xFF73809A,
            ),

            fontSize:
                9,
          ),
        ),

        const SizedBox(
          height: 4,
        ),

        Text(
          value.isEmpty
              ? '-'
              : value,

          textAlign:
              TextAlign.center,

          maxLines:
              1,

          overflow:
              TextOverflow
                  .ellipsis,

          style:
              GoogleFonts.poppins(
            color:
                color,

            fontSize:
                11,

            fontWeight:
                FontWeight
                    .w700,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// DETAIL THEME
// ============================================================

class _DetailTheme {
  final Color color;
  final Color background;
  final Color iconBackground;
  final Color chipBackground;

  const _DetailTheme({
    required this.color,
    required this.background,
    required this.iconBackground,
    required this.chipBackground,
  });
}