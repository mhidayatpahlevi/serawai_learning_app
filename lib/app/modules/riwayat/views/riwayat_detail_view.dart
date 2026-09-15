import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/answer_history_model.dart';
import '../../../data/models/latihan_history_model.dart';

class RiwayatDetailView extends StatelessWidget {
  const RiwayatDetailView({
    super.key,
  });

  static const Color primaryColor = Color(0xFF2F9C95);
  static const Color darkColor = Color(0xFF14213D);
  static const Color secondaryText = Color(0xFF73809A);
  static const Color backgroundColor = Color(0xFFF8FCFC);

  static const Color successColor = Color(0xFF45B969);
  static const Color errorColor = Color(0xFFEB5F6C);
  static const Color warningColor = Color(0xFFF3A934);

  @override
  Widget build(
    BuildContext context,
  ) {
    final argument =
        Get.arguments;

    if (argument
        is! LatihanHistoryModel) {
      return Scaffold(
        backgroundColor:
            backgroundColor,

        body: Center(
          child: Text(
            'Data riwayat tidak ditemukan.',

            style: GoogleFonts.poppins(
              color: darkColor,
            ),
          ),
        ),
      );
    }

    final LatihanHistoryModel history =
        argument;

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        bottom: false,

        child: Column(
          children: [
            // ==================================================
            // APP BAR
            // ==================================================

            _buildAppBar(),

            // ==================================================
            // CONTENT
            // ==================================================

            Expanded(
              child: ListView(
                physics:
                    const BouncingScrollPhysics(),

                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  35,
                ),

                children: [
                  // =============================================
                  // PANTUN INFO
                  // =============================================

                  _buildPantunCard(
                    history,
                  ),

                  const SizedBox(height: 12),

                  // =============================================
                  // RESULT SUMMARY
                  // =============================================

                  _buildResultSummary(
                    history,
                  ),

                  const SizedBox(height: 12),

                  // =============================================
                  // MOTIVATION
                  // =============================================

                  _buildMotivationCard(),

                  const SizedBox(height: 25),

                  // =============================================
                  // DETAIL TITLE
                  // =============================================

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Detail Jawaban',

                          style:
                              GoogleFonts.poppins(
                            color: darkColor,
                            fontSize: 20,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFE7F6F4,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),

                        child: Text(
                          '${history.answers.length} Soal',

                          style:
                              GoogleFonts.poppins(
                            color: primaryColor,
                            fontSize: 9,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // =============================================
                  // ANSWERS
                  // =============================================

                  if (history.answers.isEmpty)
                    _buildEmptyAnswer()
                  else
                    ...List.generate(
                      history.answers.length,
                      (
                        index,
                      ) {
                        return _answerCard(
                          index + 1,
                          history.answers[index],
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================

  Widget _buildAppBar() {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        10,
        8,
        10,
        10,
      ),

      decoration:
          const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE8F9FC),
            Color(0xFFF4FCFB),
          ],
        ),
      ),

      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,

            child: Material(
              color: Colors.white,

              shape:
                  const CircleBorder(),

              child: InkWell(
                customBorder:
                    const CircleBorder(),

                onTap: () {
                  Get.back();
                },

                child: const Icon(
                  Icons
                      .arrow_back_ios_new_rounded,

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
                  'Detail Riwayat',

                  style:
                      GoogleFonts.poppins(
                    color: darkColor,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                Text(
                  'Lihat hasil dan pembahasan',

                  style:
                      GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 44,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PANTUN CARD
  // ============================================================

  Widget _buildPantunCard(
    LatihanHistoryModel history,
  ) {
    final theme =
        _getCategoryTheme(
      history.kategori,
    );

    return Container(
      padding: const EdgeInsets.all(
        15,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(
          23,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.035,
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
            width: 70,
            height: 70,

            padding: const EdgeInsets.all(
              12,
            ),

            decoration: BoxDecoration(
              color: theme.background,

              borderRadius:
                  BorderRadius.circular(
                19,
              ),
            ),

            child: _buildCategoryImage(
              history.kategori,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  history.pantunTitle,

                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,

                  style: GoogleFonts.poppins(
                    color: darkColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 7),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: theme.background,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Text(
                    history.kategori,

                    style: GoogleFonts.poppins(
                      color: theme.color,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons
                          .calendar_today_outlined,
                      size: 13,
                      color: secondaryText,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      _formatDate(
                        history.createdAt,
                      ),

                      style:
                          GoogleFonts.poppins(
                        color: secondaryText,
                        fontSize: 9,
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
  // RESULT SUMMARY
  // ============================================================

  Widget _buildResultSummary(
    LatihanHistoryModel history,
  ) {
    final double accuracy =
        history.totalQuestions == 0
            ? 0
            : history.correctCount /
                history.totalQuestions *
                100;

    final Color scoreColor =
        _getScoreColor(
      history.score,
    );

    return Container(
      padding:
          const EdgeInsets.all(
        16,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          23,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.035,
            ),

            blurRadius:
                12,

            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child:
          Column(
        children: [
          Row(
            children: [
              Container(
                width:
                    54,

                height:
                    54,

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFFFF4D5,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),
                ),

                child:
                    const Icon(
                  Icons
                      .emoji_events_rounded,

                  color:
                      warningColor,

                  size:
                      30,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      'Skor Akhir',

                      style:
                          GoogleFonts.poppins(
                        color:
                            secondaryText,

                        fontSize:
                            10,

                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    Text(
                      '${history.score.toStringAsFixed(0)}/100',

                      style:
                          GoogleFonts.poppins(
                        color:
                            darkColor,

                        fontSize:
                            25,

                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      10,
                  vertical:
                      6,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      scoreColor.withOpacity(
                    0.13,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child:
                    Row(
                  mainAxisSize:
                      MainAxisSize.min,

                  children: [
                    Icon(
                      Icons
                          .star_rounded,

                      color:
                          scoreColor,

                      size:
                          16,
                    ),

                    const SizedBox(
                      width: 3,
                    ),

                    Text(
                      _scoreLabel(
                        history.score,
                      ),

                      style:
                          GoogleFonts.poppins(
                        color:
                            scoreColor,

                        fontSize:
                            9,

                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          Row(
            children: [
              Expanded(
                child:
                    _buildResultStat(
                  icon:
                      Icons
                          .check_circle_rounded,

                  value:
                      '${history.correctCount}',

                  label:
                      'Jawaban Benar',

                  color:
                      successColor,

                  background:
                      const Color(
                    0xFFEAF9EE,
                  ),
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              Expanded(
                child:
                    _buildResultStat(
                  icon:
                      Icons
                          .cancel_rounded,

                  value:
                      '${history.wrongCount}',

                  label:
                      'Jawaban Salah',

                  color:
                      errorColor,

                  background:
                      const Color(
                    0xFFFFEDF0,
                  ),
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              Expanded(
                child:
                    _buildResultStat(
                  icon:
                      Icons.quiz_rounded,

                  value:
                      '${history.totalQuestions}',

                  label:
                      'Total Soal',

                  color:
                      const Color(
                    0xFF4B9DD8,
                  ),

                  background:
                      const Color(
                    0xFFE8F5FD,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 13,
          ),

          Row(
            children: [
              Text(
                'Akurasi',

                style:
                    GoogleFonts.poppins(
                  color:
                      secondaryText,

                  fontSize:
                      10,
                ),
              ),

              const Spacer(),

              Text(
                '${accuracy.toStringAsFixed(0)}%',

                style:
                    GoogleFonts.poppins(
                  color:
                      primaryColor,

                  fontSize:
                      11,

                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 6,
          ),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),

            child:
                LinearProgressIndicator(
              value:
                  (accuracy / 100)
                      .clamp(
                        0.0,
                        1.0,
                      )
                      .toDouble(),

              minHeight:
                  8,

              backgroundColor:
                  const Color(
                0xFFDCEBEA,
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
    );
  }

  // ============================================================
  // RESULT STAT
  // ============================================================

  Widget _buildResultStat({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 11,
      ),

      decoration: BoxDecoration(
        color: background,

        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),

      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),

          const SizedBox(
            height: 3,
          ),

          Text(
            value,

            style:
                GoogleFonts.poppins(
              color:
                  color,

              fontSize:
                  16,

              fontWeight:
                  FontWeight.w800,
            ),
          ),

          Text(
            label,

            maxLines:
                1,

            overflow:
                TextOverflow.ellipsis,

            style:
                GoogleFonts.poppins(
              color:
                  secondaryText,

              fontSize:
                  7,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOTIVATION
  // ============================================================

  Widget _buildMotivationCard() {
    return Container(
      padding:
          const EdgeInsets.all(
        16,
      ),

      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFEAF7FC,
        ),

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child:
          Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Icon(
            Icons
                .format_quote_rounded,

            color:
                Color(
              0xFF7190B1,
            ),

            size:
                30,
          ),

          const SizedBox(
            width: 9,
          ),

          Expanded(
            child:
                Text(
              'Teruslah belajar, karena setiap '
              'kesalahan adalah kesempatan untuk '
              'menjadi lebih baik.',

              style:
                  GoogleFonts.poppins(
                color:
                    const Color(
                  0xFF526B89,
                ),

                fontSize:
                    10,

                height:
                    1.5,

                fontStyle:
                    FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ANSWER CARD
  // ============================================================

  Widget _answerCard(
    int number,
    AnswerHistoryModel answer,
  ) {
    final bool correct =
        answer.isCorrect;

    final Color statusColor =
        correct
            ? successColor
            : errorColor;

    final Color statusBackground =
        correct
            ? const Color(
                0xFFF0FAF2,
              )
            : const Color(
                0xFFFFF1F2,
              );

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

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

        border:
            Border.all(
          color:
              statusColor.withOpacity(
            0.13,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.025,
            ),

            blurRadius:
                10,

            offset:
                const Offset(
              0,
              3,
            ),
          ),
        ],
      ),

      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,

        children: [
          // ====================================================
          // HEADER
          // ====================================================

          Row(
            children: [
              Container(
                width:
                    34,

                height:
                    34,

                alignment:
                    Alignment.center,

                decoration:
                    BoxDecoration(
                  color:
                      statusColor,

                  shape:
                      BoxShape.circle,
                ),

                child:
                    Text(
                  '$number',

                  style:
                      GoogleFonts.poppins(
                    color:
                        Colors.white,

                    fontSize:
                        12,

                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(
                width: 9,
              ),

              Expanded(
                child:
                    Row(
                  children: [
                    Flexible(
                      child:
                          Text(
                        correct
                            ? 'Jawaban Benar'
                            : 'Jawaban Belum Tepat',

                        style:
                            GoogleFonts.poppins(
                          color:
                              statusColor,

                          fontSize:
                              12,

                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 5,
                    ),

                    Icon(
                      correct
                          ? Icons
                              .check_circle_rounded
                          : Icons
                              .cancel_rounded,

                      color:
                          statusColor,

                      size:
                          17,
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      8,
                  vertical:
                      4,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      statusBackground,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child:
                    Text(
                  'NLP ${(answer.finalScore * 100).toStringAsFixed(0)}%',

                  style:
                      GoogleFonts.poppins(
                    color:
                        statusColor,

                    fontSize:
                        8,

                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 14,
          ),

          // ====================================================
          // ANSWER
          // ====================================================

          Row(
            children: [
              Expanded(
                child:
                    _buildAnswerBox(
                  title:
                      'Jawaban Anda',

                  answer:
                      answer.selectedAnswer,

                  background:
                      correct
                          ? const Color(
                              0xFFE9F8ED,
                            )
                          : const Color(
                              0xFFFFEBEE,
                            ),
                ),
              ),

              const SizedBox(
                width: 9,
              ),

              Expanded(
                child:
                    _buildAnswerBox(
                  title:
                      'Jawaban Referensi',

                  answer:
                      answer.referenceAnswer,

                  background:
                      const Color(
                    0xFFEEF4F8,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          // ====================================================
          // NLP SCORES
          // ====================================================

          Row(
            children: [
              Expanded(
                child:
                    _nlpScore(
                  'Makna',
                  answer.semanticScore,
                  const Color(
                    0xFF45B969,
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child:
                    _nlpScore(
                  'Konteks',
                  answer.contextScore,
                  const Color(
                    0xFF3CAAA2,
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child:
                    _nlpScore(
                  'Rima',
                  answer.rhymeScore,
                  const Color(
                    0xFF4E9DD4,
                  ),
                ),
              ),
            ],
          ),

          // ====================================================
          // EXPLANATION
          // ====================================================

          if (answer
              .explanation
              .trim()
              .isNotEmpty) ...[
            const SizedBox(
              height: 16,
            ),

            Container(
              padding:
                  const EdgeInsets.all(
                12,
              ),

              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFF7FAFB,
                ),

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),

              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons
                            .lightbulb_outline_rounded,

                        color:
                            warningColor,

                        size:
                            18,
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      Text(
                        'Penjelasan',

                        style:
                            GoogleFonts.poppins(
                          color:
                              darkColor,

                          fontSize:
                              10,

                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    answer.explanation,

                    style:
                        GoogleFonts.poppins(
                      color:
                          secondaryText,

                      fontSize:
                          9,

                      height:
                          1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // ANSWER BOX
  // ============================================================

  Widget _buildAnswerBox({
    required String title,
    required String answer,
    required Color background,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style:
              GoogleFonts.poppins(
            color:
                secondaryText,

            fontSize:
                8,
          ),
        ),

        const SizedBox(
          height: 5,
        ),

        Container(
          width:
              double.infinity,

          padding:
              const EdgeInsets.symmetric(
            horizontal:
                10,
            vertical:
                8,
          ),

          decoration:
              BoxDecoration(
            color:
                background,

            borderRadius:
                BorderRadius.circular(
              10,
            ),
          ),

          child:
              Text(
            answer.isEmpty
                ? '-'
                : answer,

            maxLines:
                2,

            overflow:
                TextOverflow.ellipsis,

            style:
                GoogleFonts.poppins(
              color:
                  darkColor,

              fontSize:
                  10,

              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // NLP SCORE
  // ============================================================

  Widget _nlpScore(
    String title,
    double score,
    Color color,
  ) {
    final double safe =
        score
            .clamp(
              0.0,
              1.0,
            )
            .toDouble();

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,

      children: [
        Row(
          children: [
            Expanded(
              child:
                  Text(
                title,

                style:
                    GoogleFonts.poppins(
                  color:
                      secondaryText,

                  fontSize:
                      8,
                ),
              ),
            ),

            Text(
              '${(safe * 100).toStringAsFixed(0)}%',

              style:
                  GoogleFonts.poppins(
                color:
                    darkColor,

                fontSize:
                    8,

                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 5,
        ),

        ClipRRect(
          borderRadius:
              BorderRadius.circular(
            20,
          ),

          child:
              LinearProgressIndicator(
            value:
                safe,

            minHeight:
                6,

            backgroundColor:
                color.withOpacity(
              0.13,
            ),

            valueColor:
                AlwaysStoppedAnimation<
                    Color>(
              color,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY ANSWERS
  // ============================================================

  Widget _buildEmptyAnswer() {
    return Container(
      padding:
          const EdgeInsets.all(
        25,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child:
          Column(
        children: [
          const Icon(
            Icons
                .assignment_outlined,

            color:
                primaryColor,

            size:
                45,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            'Detail jawaban belum tersedia.',

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
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  String _categoryKey(
    String value,
  ) {
    final text = value
        .toLowerCase()
        .trim()
        .replaceAll(
          '-',
          ' ',
        )
        .replaceAll(
          '_',
          ' ',
        )
        .replaceAll(
          RegExp(r'\s+'),
          ' ',
        );

    if (text.contains(
      'nasihat',
    )) {
      return 'nasihat';
    }

    if (text.contains(
      'jenaka',
    )) {
      return 'jenaka';
    }

    if (text.contains(
      'teka',
    )) {
      return 'teka teki';
    }

    if (text.contains(
      'kiasan',
    )) {
      return 'kiasan';
    }

    if (text.contains(
      'agama',
    )) {
      return 'agama';
    }

    return text;
  }

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

  Widget _buildCategoryImage(
    String category,
  ) {
    final path =
        _getCategoryAsset(
      category,
    );

    final theme =
        _getCategoryTheme(
      category,
    );

    if (path == null) {
      return Icon(
        _fallbackIcon(
          category,
        ),
        color: theme.color,
      );
    }

    return Image.asset(
      path,

      fit:
          BoxFit.contain,

      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return Icon(
          _fallbackIcon(
            category,
          ),
          color:
              theme.color,

          size:
              40,
        );
      },
    );
  }

  IconData _fallbackIcon(
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

  _DetailCategoryTheme _getCategoryTheme(
    String category,
  ) {
    switch (_categoryKey(category)) {
      case 'nasihat':
        return const _DetailCategoryTheme(
          color: Color(0xFF4EAD5F),
          background: Color(0xFFE9F8E5),
        );

      case 'jenaka':
        return const _DetailCategoryTheme(
          color: Color(0xFFF39A35),
          background: Color(0xFFFFF2DD),
        );

      case 'teka teki':
        return const _DetailCategoryTheme(
          color: Color(0xFF5196C7),
          background: Color(0xFFE7F4FD),
        );

      case 'kiasan':
        return const _DetailCategoryTheme(
          color: Color(0xFF8062D0),
          background: Color(0xFFF0EBFF),
        );

      case 'agama':
        return const _DetailCategoryTheme(
          color: Color(0xFF3DA586),
          background: Color(0xFFE6F7F1),
        );

      default:
        return const _DetailCategoryTheme(
          color: primaryColor,
          background: Color(0xFFE5F7F4),
        );
    }
  }

  // ============================================================
  // SCORE
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

  String _scoreLabel(
    double score,
  ) {
    if (score >= 90) {
      return 'Sangat Baik';
    }

    if (score >= 80) {
      return 'Baik';
    }

    if (score >= 60) {
      return 'Cukup';
    }

    return 'Perlu Belajar';
  }

  // ============================================================
  // DATE
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
        '${date.year}  '
        '$hour:$minute';
  }
}

// ============================================================
// CATEGORY THEME
// ============================================================

class _DetailCategoryTheme {
  final Color color;
  final Color background;

  const _DetailCategoryTheme({
    required this.color,
    required this.background,
  });
}