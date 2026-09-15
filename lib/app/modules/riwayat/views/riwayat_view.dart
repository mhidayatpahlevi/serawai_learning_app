import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/latihan_history_model.dart';
import '../controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({
    super.key,
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryColor = Color(0xFF2F9C95);
  static const Color darkColor = Color(0xFF14213D);
  static const Color secondaryText = Color(0xFF73809A);
  static const Color backgroundColor = Color(0xFFF8FCFC);

  static const Color successColor = Color(0xFF48B568);
  static const Color errorColor = Color(0xFFED6671);
  static const Color warningColor = Color(0xFFF3AE3D);
  static const Color blueColor = Color(0xFF4B9DDA);

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
          // CONTENT
          // ====================================================

          return SafeArea(
            bottom: false,

            child: Column(
              children: [
                // ===============================================
                // APP BAR
                // ===============================================

                _buildAppBar(),

                // ===============================================
                // CONTENT
                // ===============================================

                Expanded(
                  child: RefreshIndicator(
                    color: primaryColor,
                    onRefresh: controller.refreshHistories,

                    child: ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),

                      padding: const EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        35,
                      ),

                      children: [
                        // =========================================
                        // MOTIVATION
                        // =========================================

                        _buildMotivationCard(),

                        const SizedBox(height: 22),

                        // =========================================
                        // PROGRESS
                        // =========================================

                        _buildProgressSummary(),

                        const SizedBox(height: 28),

                        // =========================================
                        // HISTORY TITLE
                        // =========================================

                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Riwayat Latihan',

                                style: GoogleFonts.poppins(
                                  color: darkColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFE5F6F4,
                                ),

                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),

                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min,

                                children: [
                                  const Icon(
                                    Icons.history_rounded,
                                    color: primaryColor,
                                    size: 15,
                                  ),

                                  const SizedBox(width: 4),

                                  Text(
                                    '${controller.histories.length}',

                                    style: GoogleFonts.poppins(
                                      color: primaryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // =========================================
                        // HISTORY
                        // =========================================

                        if (controller.histories.isEmpty)
                          _buildEmpty()
                        else
                          ...controller.histories.map(
                            _buildHistoryCard,
                          ),

                        const SizedBox(height: 15),

                        _buildFooter(),
                      ],
                    ),
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
  // APP BAR
  // ============================================================

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        10,
        8,
        10,
        10,
      ),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE8F9FC),
            Color(0xFFF4FCFB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,

            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),

              child: InkWell(
                customBorder: const CircleBorder(),

                onTap: () {
                  Get.back();
                },

                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: darkColor,
                ),
              ),
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Text(
                  'Riwayat & Progres',

                  style: GoogleFonts.poppins(
                    color: darkColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  'Lihat perjalanan belajarmu',

                  style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 44),
        ],
      ),
    );
  }

  // ============================================================
  // MOTIVATION
  // ============================================================

  Widget _buildMotivationCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(
        16,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(
          24,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.04,
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
          Container(
            width: 66,
            height: 66,

            decoration: BoxDecoration(
              color: const Color(
                0xFFE4F7F5,
              ),

              borderRadius: BorderRadius.circular(
                19,
              ),
            ),

            child: const Icon(
              Icons.bar_chart_rounded,
              color: primaryColor,
              size: 38,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Teruslah Belajar!',

                  style: GoogleFonts.poppins(
                    color: darkColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '“Setiap pantun yang kamu pelajari '
                  'adalah langkah kecil untuk melestarikan '
                  'Bahasa Serawai.”',

                  style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
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
  // PROGRESS SUMMARY
  // ============================================================

  Widget _buildProgressSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        Text(
          'Progres Belajar',

          style: GoogleFonts.poppins(
            color: darkColor,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 14),

        // ======================================================
        // SUMMARY GRID
        // ======================================================

        LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            int crossAxisCount = 2;

            if (constraints.maxWidth >= 900) {
              crossAxisCount = 4;
            } else if (constraints.maxWidth >= 650) {
              crossAxisCount = 3;
            }

            final items = [
              _SummaryItem(
                icon: Icons.assignment_rounded,
                title: 'Total Latihan',
                value: '${controller.totalLatihan}',
                color: const Color(0xFF2FA99E),
                background: const Color(0xFFE3F8F5),
              ),
              _SummaryItem(
                icon: Icons.auto_stories_rounded,
                title: 'Pantun Dipelajari',
                value:
                    '${controller.totalPantunDipelajari}',
                color: const Color(0xFF4A9EDB),
                background: const Color(0xFFE8F5FF),
              ),
              _SummaryItem(
                icon: Icons.bar_chart_rounded,
                title: 'Rata-rata Nilai',
                value: controller.averageScore
                    .toStringAsFixed(0),
                color: const Color(0xFFF19D3A),
                background: const Color(0xFFFFF3E3),
              ),
              _SummaryItem(
                icon:
                    Icons.emoji_events_rounded,
                title: 'Nilai Tertinggi',
                value: controller.highestScore
                    .toStringAsFixed(0),
                color: const Color(0xFFEAA927),
                background: const Color(0xFFFFF7D9),
              ),
              _SummaryItem(
                icon:
                    Icons.check_circle_rounded,
                title: 'Jawaban Benar',
                value: '${controller.totalBenar}',
                color: successColor,
                background: const Color(0xFFE8F8ED),
              ),
              _SummaryItem(
                icon: Icons.cancel_rounded,
                title: 'Jawaban Salah',
                value: '${controller.totalSalah}',
                color: errorColor,
                background: const Color(0xFFFFECEE),
              ),
            ];

            return GridView.builder(
              shrinkWrap: true,

              physics:
                  const NeverScrollableScrollPhysics(),

              itemCount: items.length,

              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 130,
              ),

              itemBuilder: (
                context,
                index,
              ) {
                return _buildSummaryCard(
                  items[index],
                );
              },
            );
          },
        ),

        const SizedBox(height: 18),

        // ======================================================
        // ACCURACY
        // ======================================================

        _buildAccuracyCard(),
      ],
    );
  }

  // ============================================================
  // SUMMARY CARD
  // ============================================================

  Widget _buildSummaryCard(
    _SummaryItem item,
  ) {
    return Container(
      padding: const EdgeInsets.all(
        12,
      ),

      decoration: BoxDecoration(
        color: item.background,

        borderRadius: BorderRadius.circular(
          20,
        ),
      ),

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(
                0.75,
              ),

              borderRadius: BorderRadius.circular(
                12,
              ),
            ),

            child: Icon(
              item.icon,
              color: item.color,
              size: 22,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            item.value,

            maxLines: 1,

            style: GoogleFonts.poppins(
              color: darkColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 2),

          Flexible(
            child: Text(
              item.title,

              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(
                color: const Color(
                  0xFF536681,
                ),
                fontSize: 9,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACCURACY
  // ============================================================

  Widget _buildAccuracyCard() {
    final double accuracy =
        (controller.accuracy / 100)
            .clamp(
              0.0,
              1.0,
            )
            .toDouble();

    return Container(
      padding: const EdgeInsets.all(
        16,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(
          22,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.04,
            ),
            blurRadius: 12,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              color: const Color(
                0xFFE3F7F6,
              ),

              borderRadius: BorderRadius.circular(
                17,
              ),
            ),

            child: const Icon(
              Icons.track_changes_rounded,
              color: primaryColor,
              size: 33,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Akurasi Jawaban',

                        style: GoogleFonts.poppins(
                          color: darkColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Text(
                      '${controller.accuracy.toStringAsFixed(0)}%',

                      style: GoogleFonts.poppins(
                        color: darkColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 9),

                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  child: LinearProgressIndicator(
                    value: accuracy,
                    minHeight: 9,
                    backgroundColor:
                        const Color(
                      0xFFDDECEB,
                    ),

                    valueColor:
                        const AlwaysStoppedAnimation<
                            Color>(
                      primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '${controller.totalBenar} jawaban benar '
                  'dari ${controller.totalSoal} soal.',

                  style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 9,
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
  // HISTORY CARD
  // ============================================================

  Widget _buildHistoryCard(
    LatihanHistoryModel history,
  ) {
    final _HistoryTheme theme =
        _getCategoryTheme(
      history.kategori,
    );

    final Color scoreColor =
        _getScoreColor(
      history.score,
    );

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),

      child: Material(
        color: Colors.transparent,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        child: InkWell(
          borderRadius:
              BorderRadius.circular(
            20,
          ),

          onTap: () {
            controller.openHistory(
              history,
            );
          },

          child: Ink(
            padding:
                const EdgeInsets.all(
              12,
            ),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                20,
              ),

              border: Border.all(
                color: const Color(
                  0xFFEAF0F2,
                ),
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(
                    0.025,
                  ),

                  blurRadius: 8,
                  offset: const Offset(
                    0,
                    3,
                  ),
                ),
              ],
            ),

            child: Row(
              children: [
                // ===============================================
                // CATEGORY ICON
                // ===============================================

                Container(
                  width: 58,
                  height: 58,

                  padding: const EdgeInsets.all(
                    10,
                  ),

                  decoration: BoxDecoration(
                    color:
                        theme.background,

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),

                  child: _buildCategoryImage(
                    history.kategori,
                  ),
                ),

                const SizedBox(width: 12),

                // ===============================================
                // INFORMATION
                // ===============================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        history.pantunTitle,

                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,

                        style:
                            GoogleFonts.poppins(
                          color: darkColor,
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),

                            decoration:
                                BoxDecoration(
                              color:
                                  theme.background,

                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),

                            child: Text(
                              history.kategori,

                              style:
                                  GoogleFonts.poppins(
                                color:
                                    theme.color,

                                fontSize: 8,

                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(width: 6),

                          const Icon(
                            Icons.circle,
                            size: 4,
                            color: secondaryText,
                          ),

                          const SizedBox(width: 6),

                          Flexible(
                            child: Text(
                              '${history.correctCount} benar • '
                              '${history.totalQuestions} soal',

                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,

                              style:
                                  GoogleFonts.poppins(
                                color:
                                    secondaryText,

                                fontSize: 8,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: secondaryText,
                          ),

                          const SizedBox(width: 5),

                          Text(
                            _formatDate(
                              history.createdAt,
                            ),

                            style: GoogleFonts.poppins(
                              color: secondaryText,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ===============================================
                // SCORE
                // ===============================================

                Container(
                  width: 52,
                  height: 52,

                  alignment: Alignment.center,

                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(
                      0.12,
                    ),

                    shape: BoxShape.circle,
                  ),

                  child: Text(
                    history.score.toStringAsFixed(
                      0,
                    ),

                    style: GoogleFonts.poppins(
                      color: scoreColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF8CA0B6),
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
    String category,
  ) {
    final String? path =
        _getCategoryAsset(
      category,
    );

    final theme =
        _getCategoryTheme(
      category,
    );

    if (path == null) {
      return Icon(
        _getFallbackIcon(
          category,
        ),
        color: theme.color,
        size: 37,
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
        return Icon(
          _getFallbackIcon(
            category,
          ),
          color: theme.color,
          size: 37,
        );
      },
    );
  }

  // ============================================================
  // CATEGORY NORMALIZATION
  // ============================================================

  String _categoryKey(
    String value,
  ) {
    final text = value
        .toLowerCase()
        .trim()
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .replaceAll(
          RegExp(r'\s+'),
          ' ',
        );

    if (text.contains('nasihat')) {
      return 'nasihat';
    }

    if (text.contains('jenaka')) {
      return 'jenaka';
    }

    if (text.contains('teka')) {
      return 'teka teki';
    }

    if (text.contains('kiasan')) {
      return 'kiasan';
    }

    if (text.contains('agama')) {
      return 'agama';
    }

    return text;
  }

  // ============================================================
  // CATEGORY ASSET
  // ============================================================

  String? _getCategoryAsset(
    String category,
  ) {
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

  IconData _getFallbackIcon(
    String category,
  ) {
    switch (_categoryKey(category)) {
      case 'nasihat':
        return Icons.eco_rounded;

      case 'jenaka':
        return Icons.sentiment_very_satisfied_rounded;

      case 'teka teki':
        return Icons.help_rounded;

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

  _HistoryTheme _getCategoryTheme(
    String category,
  ) {
    switch (_categoryKey(category)) {
      case 'nasihat':
        return const _HistoryTheme(
          color: Color(0xFF4EAD5F),
          background: Color(0xFFEAF8E5),
        );

      case 'jenaka':
        return const _HistoryTheme(
          color: Color(0xFFF39A35),
          background: Color(0xFFFFF2DD),
        );

      case 'teka teki':
        return const _HistoryTheme(
          color: Color(0xFF5196C7),
          background: Color(0xFFE6F4FD),
        );

      case 'kiasan':
        return const _HistoryTheme(
          color: Color(0xFF8062D0),
          background: Color(0xFFF0EBFF),
        );

      case 'agama':
        return const _HistoryTheme(
          color: Color(0xFF3DA586),
          background: Color(0xFFE5F7F0),
        );

      default:
        return const _HistoryTheme(
          color: primaryColor,
          background: Color(0xFFE4F7F4),
        );
    }
  }

  // ============================================================
  // SCORE COLOR
  // ============================================================

  Color _getScoreColor(
    double score,
  ) {
    if (score >= 80) {
      return successColor;
    }

    if (score >= 60) {
      return warningColor;
    }

    return errorColor;
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE4F8F5),
            Color(0xFFF1FBFC),
          ],
        ),

        borderRadius: BorderRadius.circular(
          22,
        ),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.eco_rounded,
            color: primaryColor,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              '“Terus belajar dan lestarikan '
              'Bahasa Serawai melalui pantun.”',

              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(
                color: secondaryText,
                fontSize: 10,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(width: 8),

          const Icon(
            Icons.auto_stories_rounded,
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(
    DateTime? date,
  ) {
    if (date == null) {
      return 'Waktu tidak tersedia';
    }

    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final hour =
        date.hour.toString().padLeft(
              2,
              '0',
            );

    final minute =
        date.minute.toString().padLeft(
              2,
              '0',
            );

    return '${date.day} '
        '${months[date.month]} '
        '${date.year} • '
        '$hour:$minute';
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(
        28,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),

      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,

            decoration:
                const BoxDecoration(
              color: Color(
                0xFFE4F7F5,
              ),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.history_toggle_off_rounded,
              size: 35,
              color: primaryColor,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'Belum Ada Riwayat',

            style: GoogleFonts.poppins(
              color: darkColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Selesaikan latihan pantun untuk '
            'melihat progres belajar.',

            textAlign: TextAlign.center,

            style: GoogleFonts.poppins(
              color: secondaryText,
              fontSize: 10,
              height: 1.5,
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
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(
            30,
          ),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Container(
                width: 80,
                height: 80,

                decoration:
                    const BoxDecoration(
                  color: Color(
                    0xFFFFEEEE,
                  ),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.cloud_off_rounded,
                  color: errorColor,
                  size: 40,
                ),
              ),

              const SizedBox(height: 17),

              Text(
                'Gagal Memuat Riwayat',

                style: GoogleFonts.poppins(
                  color: darkColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                controller.errorMessage.value,

                textAlign: TextAlign.center,

                style: GoogleFonts.poppins(
                  color: secondaryText,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed:
                    controller.loadHistories,

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
                      15,
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
      ),
    );
  }
}

// ============================================================
// SUMMARY ITEM
// ============================================================

class _SummaryItem {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final Color background;

  const _SummaryItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.background,
  });
}

// ============================================================
// CATEGORY THEME
// ============================================================

class _HistoryTheme {
  final Color color;
  final Color background;

  const _HistoryTheme({
    required this.color,
    required this.background,
  });
}