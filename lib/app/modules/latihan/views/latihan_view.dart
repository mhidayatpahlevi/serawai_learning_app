import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/latihan_controller.dart';

class LatihanView extends GetView<LatihanController> {
  const LatihanView({
    super.key,
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryColor = Color(0xFF2F9C95);
  static const Color primaryLight = Color(0xFFDFF7F3);

  static const Color darkColor = Color(0xFF14213D);

  static const Color secondaryText = Color(
    0xFF72809A,
  );

  static const Color backgroundColor = Color(
    0xFFF6FCFC,
  );

  static const Color successColor = Color(
    0xFF48AF69,
  );

  static const Color errorColor = Color(
    0xFFE96767,
  );

  static const Color warningColor = Color(
    0xFFF2B33D,
  );

  @override
  Widget build(
    BuildContext context,
  ) {
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

          if (controller.questions.isEmpty) {
            return _buildEmpty();
          }

          final question =
              controller.currentQuestion;

          if (question == null) {
            return _buildEmpty();
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
                // SCROLL CONTENT
                // ===============================================

                Expanded(
                  child: SingleChildScrollView(
                    physics:
                        const BouncingScrollPhysics(),

                    padding:
                        const EdgeInsets.fromLTRB(
                      16,
                      6,
                      16,
                      120,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,

                      children: [
                        // =========================================
                        // PROGRESS
                        // =========================================

                        _buildProgress(),

                        const SizedBox(height: 14),

                        // =========================================
                        // PANTUN INFO
                        // =========================================

                        _buildPantunHeader(),

                        const SizedBox(height: 12),

                        // =========================================
                        // INSTRUCTION
                        // =========================================

                        _buildInstruction(),

                        const SizedBox(height: 14),

                        // =========================================
                        // PANTUN
                        // =========================================

                        _buildPantunCard(),

                        const SizedBox(height: 20),

                        // =========================================
                        // PILIH JAWABAN
                        // =========================================

                        Text(
                          'Pilih Jawaban',
                          style: GoogleFonts.poppins(
                            color: darkColor,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          'Pilih satu kata yang menurutmu paling tepat.',
                          style: GoogleFonts.poppins(
                            color: secondaryText,
                            fontSize: 10,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // =========================================
                        // OPTIONS
                        // =========================================

                        ...List.generate(
                          controller
                              .displayedOptions.length,
                          (index) {
                            final option =
                                controller
                                    .displayedOptions[
                                index];

                            return _buildOption(
                              option,
                              index,
                            );
                          },
                        ),

                        // =========================================
                        // NLP FEEDBACK
                        // =========================================

                        if (controller
                            .isAnswered.value) ...[
                          const SizedBox(
                            height: 10,
                          ),

                          _buildFeedback(),
                        ],
                      ],
                    ),
                  ),
                ),

                // ===============================================
                // BOTTOM BUTTON
                // ===============================================

                _buildBottomArea(),
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
            Color(0xFFE8FAFC),
            Color(0xFFF2FCFA),
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
                customBorder:
                    const CircleBorder(),

                onTap: () {
                  Get.back();
                },

                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: darkColor,
                  size: 26,
                ),
              ),
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Text(
                  'Latihan Pantun',
                  style: GoogleFonts.poppins(
                    color: darkColor,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  'Lengkapi pantun dengan kata yang tepat',
                  textAlign: TextAlign.center,

                  style: GoogleFonts.poppins(
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
  // PROGRESS
  // ============================================================

  Widget _buildProgress() {
    final double progress =
        controller.totalQuestions == 0
            ? 0
            : controller.currentNumber /
                controller.totalQuestions;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(
          20,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.04,
            ),

            blurRadius: 10,

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
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              Text(
                'Soal ${controller.currentNumber} '
                'dari ${controller.totalQuestions}',

                style: GoogleFonts.poppins(
                  color: darkColor,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 3,
                ),

                decoration: BoxDecoration(
                  color: primaryLight,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Text(
                  '${(progress * 100).round()}%',

                  style:
                      GoogleFonts.poppins(
                    color:
                        primaryColor,

                    fontSize:
                        10,

                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

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
                  9,

              backgroundColor:
                  const Color(
                0xFFDDEEEE,
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
  // PANTUN HEADER
  // ============================================================

  Widget _buildPantunHeader() {
    final theme =
        _getCategoryTheme(
      controller.pantun.kategori,
    );

    return Container(
      padding:
          const EdgeInsets.all(
        14,
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

      child: Row(
        children: [
          // ====================================================
          // CATEGORY IMAGE
          // ====================================================

          Container(
            width: 58,
            height: 58,

            padding:
                const EdgeInsets.all(
              9,
            ),

            decoration:
                BoxDecoration(
              color:
                  theme.iconBackground,

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child:
                _buildCategoryImage(
              controller
                  .pantun
                  .kategori,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          // ====================================================
          // INFO
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  controller
                      .pantun
                      .judul,

                  maxLines: 2,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      GoogleFonts.poppins(
                    color:
                        darkColor,

                    fontSize:
                        16,

                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 7,
                ),

                Wrap(
                  spacing: 6,
                  runSpacing: 5,

                  children: [
                    _buildSmallChip(
                      icon:
                          Icons.eco_rounded,

                      text:
                          controller
                              .pantun
                              .kategori,

                      color:
                          theme.color,

                      background:
                          theme
                              .chipBackground,
                    ),

                    if (controller
                        .pantun
                        .level
                        .isNotEmpty)
                      _buildSmallChip(
                        icon: Icons
                            .school_rounded,

                        text:
                            'Level: ${_capitalize(controller.pantun.level)}',

                        color:
                            const Color(
                          0xFF4E7AA7,
                        ),

                        background:
                            const Color(
                          0xFFE4F1FA,
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
  // INSTRUCTION
  // ============================================================

  Widget _buildInstruction() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),

      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFE8F7FF,
        ),

        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,

            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFFFE7A5,
              ),

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child:
                const Icon(
              Icons.lightbulb_rounded,

              color:
                  Color(
                0xFFF1A829,
              ),

              size:
                  24,
            ),
          ),

          const SizedBox(
            width: 11,
          ),

          Expanded(
            child: Text(
              'Lengkapi pantun berikut dengan '
              'kata yang paling tepat.',

              style:
                  GoogleFonts.poppins(
                color:
                    darkColor,

                fontSize:
                    11,

                height:
                    1.45,

                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PANTUN CARD
  // ============================================================

  Widget _buildPantunCard() {
    final question =
        controller.currentQuestion;

    if (question == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        18,
        24,
        18,
        24,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          25,
        ),

        border:
            Border.all(
          color:
              const Color(
            0xFFE6F1EF,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              0.04,
            ),

            blurRadius:
                12,

            offset:
                const Offset(
              0,
              5,
            ),
          ),
        ],
      ),

      child: Stack(
        children: [
          // ====================================================
          // LEAF DECORATION
          // ====================================================

          const Positioned(
            top: -5,
            left: -4,

            child: Icon(
              Icons.eco_rounded,

              color:
                  Color(
                0xFF65B97A,
              ),

              size:
                  33,
            ),
          ),

          const Positioned(
            bottom: -5,
            right: -4,

            child: RotatedBox(
              quarterTurns: 2,

              child:
                  Icon(
                Icons.eco_rounded,

                color:
                    Color(
                  0xFF91D4A2,
                ),

                size:
                    31,
              ),
            ),
          ),

          // ====================================================
          // TEXT
          // ====================================================

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),

            child:
                _buildPantunTemplate(
              question.template,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PANTUN TEMPLATE
  // Mendeteksi _____ pada soal
  // ============================================================

  Widget _buildPantunTemplate(
    String template,
  ) {
    final regex =
        RegExp(
      r'_{2,}|\[\s*\]|\.{4,}',
    );

    final matches =
        regex
            .allMatches(
      template,
    )
            .toList();

    // Jika template tidak memiliki tanda rumpang
    if (matches.isEmpty) {
      return Text(
        template,

        textAlign:
            TextAlign.center,

        style:
            GoogleFonts.poppins(
          color:
              darkColor,

          fontSize:
              15,

          height:
              1.8,

          fontWeight:
              FontWeight.w500,
        ),
      );
    }

    final List<InlineSpan> spans =
        [];

    int lastIndex =
        0;

    for (final match
        in matches) {
      if (match.start >
          lastIndex) {
        spans.add(
          TextSpan(
            text:
                template.substring(
              lastIndex,
              match.start,
            ),
          ),
        );
      }

      final String selected =
          controller
              .selectedAnswer
              .value;

      spans.add(
        WidgetSpan(
          alignment:
              PlaceholderAlignment.middle,

          child:
              Container(
            constraints:
                const BoxConstraints(
              minWidth:
                  95,
            ),

            margin:
                const EdgeInsets.symmetric(
              horizontal:
                  4,
            ),

            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  11,
              vertical:
                  4,
            ),

            decoration:
                BoxDecoration(
              color:
                  selected.isEmpty
                      ? const Color(
                          0xFFF3FCFA,
                        )
                      : primaryLight,

              borderRadius:
                  BorderRadius.circular(
                10,
              ),

              border:
                  Border.all(
                color:
                    primaryColor,

                width:
                    1.5,
              ),
            ),

            child:
                Text(
              selected.isEmpty
                  ? '........'
                  : selected,

              textAlign:
                  TextAlign.center,

              style:
                  GoogleFonts.poppins(
                color:
                    selected.isEmpty
                        ? primaryColor
                        : const Color(
                            0xFF267B61,
                          ),

                fontSize:
                    13,

                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
        ),
      );

      lastIndex =
          match.end;
    }

    if (lastIndex <
        template.length) {
      spans.add(
        TextSpan(
          text:
              template.substring(
            lastIndex,
          ),
        ),
      );
    }

    return RichText(
      textAlign:
          TextAlign.center,

      text:
          TextSpan(
        style:
            GoogleFonts.poppins(
          color:
              darkColor,

          fontSize:
              15,

          height:
              1.9,

          fontWeight:
              FontWeight.w500,
        ),

        children:
            spans,
      ),
    );
  }

  // ============================================================
  // OPTION
  // ============================================================

  Widget _buildOption(
    String option,
    int index,
  ) {
    final bool selected =
        controller
                .selectedAnswer
                .value ==
            option;

    final bool answered =
        controller
            .isAnswered
            .value;

    final question =
        controller.currentQuestion;

    final bool referenceOption =
        question != null &&
        option
                .trim()
                .toLowerCase() ==
            question
                .referenceAnswer
                .trim()
                .toLowerCase();

    Color borderColor =
        const Color(
      0xFFDDE7EB,
    );

    Color background =
        Colors.white;

    Color circleColor =
        const Color(
      0xFFDDF3FB,
    );

    Color textColor =
        darkColor;

    IconData trailingIcon =
        Icons
            .radio_button_unchecked_rounded;

    Color trailingColor =
        const Color(
      0xFFAEBCCC,
    );

    // ==========================================================
    // SELECTED BELUM DIJAWAB
    // ==========================================================

    if (!answered &&
        selected) {
      borderColor =
          primaryColor;

      background =
          const Color(
        0xFFF0FBF8,
      );

      circleColor =
          primaryColor;

      trailingIcon =
          Icons
              .radio_button_checked_rounded;

      trailingColor =
          primaryColor;
    }

    // ==========================================================
    // BENAR
    // ==========================================================

    if (answered &&
        selected &&
        controller
            .isCorrect.value) {
      borderColor =
          successColor;

      background =
          const Color(
        0xFFECF9F0,
      );

      circleColor =
          successColor;

      trailingIcon =
          Icons.check_circle_rounded;

      trailingColor =
          successColor;
    }

    // ==========================================================
    // SALAH
    // ==========================================================

    if (answered &&
        selected &&
        !controller
            .isCorrect.value) {
      borderColor =
          errorColor;

      background =
          const Color(
        0xFFFFF0F0,
      );

      circleColor =
          errorColor;

      trailingIcon =
          Icons.cancel_rounded;

      trailingColor =
          errorColor;
    }

    // ==========================================================
    // JAWABAN REFERENSI
    // ==========================================================

    if (answered &&
        !controller
            .isCorrect.value &&
        referenceOption &&
        !selected) {
      borderColor =
          successColor;

      background =
          const Color(
        0xFFECF9F0,
      );

      trailingIcon =
          Icons.check_circle_outline;

      trailingColor =
          successColor;
    }

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),

      decoration:
          BoxDecoration(
        color:
            background,

        borderRadius:
            BorderRadius.circular(
          17,
        ),

        border:
            Border.all(
          color:
              borderColor,

          width:
              selected ||
                      referenceOption
                  ? 1.5
                  : 1,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              0.025,
            ),

            blurRadius:
                7,

            offset:
                const Offset(
              0,
              3,
            ),
          ),
        ],
      ),

      child:
          Material(
        color:
            Colors.transparent,

        borderRadius:
            BorderRadius.circular(
          17,
        ),

        child:
            InkWell(
          borderRadius:
              BorderRadius.circular(
            17,
          ),

          onTap:
              answered ||
                      controller
                          .isChecking
                          .value
                  ? null
                  : () {
                      controller
                          .selectAnswer(
                        option,
                      );
                    },

          child:
              Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  13,
              vertical:
                  13,
            ),

            child:
                Row(
              children: [
                // ===============================================
                // A B C D
                // ===============================================

                Container(
                  width:
                      37,

                  height:
                      37,

                  alignment:
                      Alignment.center,

                  decoration:
                      BoxDecoration(
                    color:
                        circleColor,

                    shape:
                        BoxShape.circle,
                  ),

                  child:
                      Text(
                    _optionLetter(
                      index,
                    ),

                    style:
                        GoogleFonts.poppins(
                      color:
                          selected ||
                                  (answered &&
                                      referenceOption)
                              ? Colors.white
                              : const Color(
                                  0xFF36779D,
                                ),

                      fontSize:
                          13,

                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child:
                      Text(
                    option,

                    style:
                        GoogleFonts.poppins(
                      color:
                          textColor,

                      fontSize:
                          13,

                      fontWeight:
                          selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                Icon(
                  trailingIcon,

                  color:
                      trailingColor,

                  size:
                      25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FEEDBACK NLP
  // ============================================================

  Widget _buildFeedback() {
    final question =
        controller.currentQuestion;

    final result =
        controller.nlpResult.value;

    if (question == null ||
        result == null) {
      return const SizedBox.shrink();
    }

    final bool correct =
        result.isCorrect;

    final Color resultColor =
        correct
            ? successColor
            : errorColor;

    final Color resultBackground =
        correct
            ? const Color(
                0xFFF0FAF2,
              )
            : const Color(
                0xFFFFF2F2,
              );

    return Container(
      padding:
          const EdgeInsets.all(
        16,
      ),

      decoration:
          BoxDecoration(
        color:
            resultBackground,

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        border:
            Border.all(
          color:
              resultColor
                  .withOpacity(
            0.20,
          ),
        ),
      ),

      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ====================================================
          // RESULT HEADER
          // ====================================================

          Row(
            children: [
              Container(
                width:
                    48,

                height:
                    48,

                decoration:
                    BoxDecoration(
                  color:
                      resultColor,

                  shape:
                      BoxShape.circle,
                ),

                child:
                    Icon(
                  correct
                      ? Icons
                          .check_rounded
                      : Icons
                          .close_rounded,

                  color:
                      Colors.white,

                  size:
                      29,
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
                      correct
                          ? 'Jawaban Benar! 🎉'
                          : 'Belum Tepat',

                      style:
                          GoogleFonts.poppins(
                        color:
                            correct
                                ? const Color(
                                    0xFF23784A,
                                  )
                                : const Color(
                                    0xFFA43B3B,
                                  ),

                        fontSize:
                            18,

                        fontWeight:
                            FontWeight
                                .w800,
                      ),
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    Text(
                      correct
                          ? 'Hebat! Jawabanmu cocok dengan pantun.'
                          : 'Tidak apa-apa, mari pelajari jawabannya.',

                      style:
                          GoogleFonts.poppins(
                        color:
                            secondaryText,

                        fontSize:
                            10,

                        height:
                            1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          // ====================================================
          // SCORES
          // ====================================================

          Container(
            padding:
                const EdgeInsets.all(
              14,
            ),

            decoration:
                BoxDecoration(
              color:
                  Colors.white,

              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),

            child:
                Column(
              children: [
                _buildScoreItem(
                  icon:
                      Icons
                          .auto_stories_rounded,

                  title:
                      'Kesesuaian Makna',

                  score:
                      result.semanticScore,

                  color:
                      const Color(
                    0xFF44A96F,
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                _buildScoreItem(
                  icon:
                      Icons
                          .chat_bubble_rounded,

                  title:
                      'Kesesuaian Konteks',

                  score:
                      result.contextScore,

                  color:
                      const Color(
                    0xFF3AAE9E,
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                _buildScoreItem(
                  icon:
                      Icons
                          .music_note_rounded,

                  title:
                      'Kesesuaian Rima',

                  score:
                      result.rhymeScore,

                  color:
                      const Color(
                    0xFF43AEB5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 13,
          ),

          // ====================================================
          // NLP SCORE
          // ====================================================

          Container(
            width:
                double.infinity,

            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  14,
              vertical:
                  12,
            ),

            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFFFF2CF,
              ),

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child:
                Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,

              children: [
                const Icon(
                  Icons
                      .star_rounded,

                  color:
                      Color(
                    0xFFF0A928,
                  ),

                  size:
                      27,
                ),

                const SizedBox(
                  width: 7,
                ),

                Text(
                  'Nilai NLP: ',

                  style:
                      GoogleFonts.poppins(
                    color:
                        darkColor,

                    fontSize:
                        13,

                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                Text(
                  '${(result.finalScore * 100).round()}%',

                  style:
                      GoogleFonts.poppins(
                    color:
                        const Color(
                      0xFF278C70,
                    ),

                    fontSize:
                        20,

                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          // ====================================================
          // EXPLANATION
          // ====================================================

          Text(
            'Penjelasan',

            style:
                GoogleFonts.poppins(
              color:
                  darkColor,

              fontSize:
                  13,

              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Text(
            result.explanation,

            style:
                GoogleFonts.poppins(
              color:
                  const Color(
                0xFF53617B,
              ),

              fontSize:
                  10,

              height:
                  1.6,
            ),
          ),

          // ====================================================
          // REFERENCE ANSWER
          // ====================================================

          if (!result.isCorrect) ...[
            const SizedBox(
              height: 15,
            ),

            Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets.all(
                13,
              ),

              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFEAF8EF,
                ),

                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),

              child:
                  Row(
                children: [
                  const Icon(
                    Icons
                        .lightbulb_outline_rounded,

                    color:
                        successColor,

                    size:
                        22,
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child:
                        Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        Text(
                          'Jawaban yang tepat',

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
                          question
                              .referenceAnswer,

                          style:
                              GoogleFonts.poppins(
                            color:
                                const Color(
                              0xFF267B50,
                            ),

                            fontSize:
                                14,

                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),
                      ],
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
  // SCORE
  // ============================================================

  Widget _buildScoreItem({
    required IconData icon,
    required String title,
    required double score,
    required Color color,
  }) {
    final double safeScore =
        score
            .clamp(
              0.0,
              1.0,
            )
            .toDouble();

    final int percentage =
        (safeScore * 100)
            .round();

    return Row(
      children: [
        Container(
          width:
              31,

          height:
              31,

          decoration:
              BoxDecoration(
            color:
                color.withOpacity(
              0.11,
            ),

            borderRadius:
                BorderRadius.circular(
              9,
            ),
          ),

          child:
              Icon(
            icon,

            color:
                color,

            size:
                17,
          ),
        ),

        const SizedBox(
          width: 9,
        ),

        Expanded(
          flex: 2,

          child:
              Text(
            title,

            style:
                GoogleFonts.poppins(
              color:
                  darkColor,

              fontSize:
                  9,

              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),

        Expanded(
          flex: 2,

          child:
              ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),

            child:
                LinearProgressIndicator(
              value:
                  safeScore,

              minHeight:
                  7,

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
        ),

        const SizedBox(
          width: 9,
        ),

        SizedBox(
          width:
              36,

          child:
              Text(
            '$percentage%',

            textAlign:
                TextAlign.right,

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
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM AREA
  // ============================================================

  Widget _buildBottomArea() {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        18,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              0.07,
            ),

            blurRadius:
                15,

            offset:
                const Offset(
              0,
              -4,
            ),
          ),
        ],
      ),

      child:
          SafeArea(
        top:
            false,

        child:
            _buildButton(),
      ),
    );
  }

  // ============================================================
  // BUTTON
  // ============================================================

  Widget _buildButton() {
    // ==========================================================
    // BELUM DIJAWAB
    // ==========================================================

    if (!controller
        .isAnswered.value) {
      final bool loading =
          controller
              .isChecking
              .value;

      final bool hasAnswer =
          controller
              .selectedAnswer
              .value
              .isNotEmpty;

      return SizedBox(
        height:
            55,

        child:
            ElevatedButton(
          onPressed:
              loading ||
                      !hasAnswer
                  ? null
                  : controller
                      .checkAnswer,

          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                primaryColor,

            foregroundColor:
                Colors.white,

            disabledBackgroundColor:
                const Color(
              0xFFDCE7E6,
            ),

            disabledForegroundColor:
                const Color(
              0xFF94A4A5,
            ),

            elevation:
                0,

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
          ),

          child:
              loading
                  ? Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [
                        const SizedBox(
                          width:
                              20,
                          height:
                              20,

                          child:
                              CircularProgressIndicator(
                            color:
                                Colors.white,

                            strokeWidth:
                                2,
                          ),
                        ),

                        const SizedBox(
                          width:
                              10,
                        ),

                        Text(
                          'Menganalisis...',

                          style:
                              GoogleFonts.poppins(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [
                        const Icon(
                          Icons
                              .check_circle_rounded,

                          size:
                              23,
                        ),

                        const SizedBox(
                          width:
                              8,
                        ),

                        Text(
                          'Periksa Jawaban',

                          style:
                              GoogleFonts.poppins(
                            fontSize:
                                13,

                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        const SizedBox(
                          width:
                              8,
                        ),

                        const Icon(
                          Icons
                              .arrow_forward_rounded,

                          size:
                              19,
                        ),
                      ],
                    ),
        ),
      );
    }

    // ==========================================================
    // SUDAH DIJAWAB
    // ==========================================================

    final bool saving =
        controller
            .isSavingResult
            .value;

    return SizedBox(
      height:
          55,

      child:
          ElevatedButton(
        onPressed:
            saving
                ? null
                : controller
                    .nextQuestion,

        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              primaryColor,

          foregroundColor:
              Colors.white,

          disabledBackgroundColor:
              const Color(
            0xFFDCE7E6,
          ),

          elevation:
              0,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),
        ),

        child:
            saving
                ? Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [
                      const SizedBox(
                        width:
                            20,
                        height:
                            20,

                        child:
                            CircularProgressIndicator(
                          strokeWidth:
                              2,

                          color:
                              Colors.white,
                        ),
                      ),

                      const SizedBox(
                        width:
                            10,
                      ),

                      Text(
                        'Menyimpan...',

                        style:
                            GoogleFonts.poppins(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [
                      Icon(
                        controller
                                .isLastQuestion
                            ? Icons
                                .flag_rounded
                            : Icons
                                .arrow_circle_right_rounded,

                        size:
                            24,
                      ),

                      const SizedBox(
                        width:
                            9,
                      ),

                      Text(
                        controller
                                .isLastQuestion
                            ? 'Lihat Hasil'
                            : 'Soal Berikutnya',

                        style:
                            GoogleFonts.poppins(
                          fontSize:
                              13,

                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      if (!controller
                          .isLastQuestion) ...[
                        const SizedBox(
                          width:
                              7,
                        ),

                        const Icon(
                          Icons
                              .arrow_forward_rounded,

                          size:
                              18,
                        ),
                      ],
                    ],
                  ),
      ),
    );
  }

  // ============================================================
  // CHIP
  // ============================================================

  Widget _buildSmallChip({
    required IconData icon,
    required String text,
    required Color color,
    required Color background,
  }) {
    return Container(
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
            background,

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
            icon,
            color:
                color,
            size:
                13,
          ),

          const SizedBox(
            width: 4,
          ),

          Text(
            text,

            style:
                GoogleFonts.poppins(
              color:
                  color,

              fontSize:
                  8,

              fontWeight:
                  FontWeight.w600,
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
    final String? asset =
        _getCategoryAsset(
      category,
    );

    if (asset ==
        null) {
      return const Icon(
        Icons.auto_stories_rounded,
        color: primaryColor,
        size: 36,
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
          size: 36,
        );
      },
    );
  }

  // ============================================================
  // CATEGORY ASSET
  // ============================================================

  String? _getCategoryAsset(
    String category,
  ) {
    final String value =
        category
            .toLowerCase()
            .trim();

    if (value.contains(
      'nasihat',
    )) {
      return 'assets/images/kategori/daunicon.png';
    }

    if (value.contains(
      'jenaka',
    )) {
      return 'assets/images/kategori/jenakaicon.png';
    }

    if (value.contains(
      'teka',
    )) {
      return 'assets/images/kategori/teka_teki_icon.png';
    }

    if (value.contains(
      'kiasan',
    )) {
      return 'assets/images/kategori/kiasanicon.png';
    }

    if (value.contains(
      'agama',
    )) {
      return 'assets/images/kategori/agamaicon.png';
    }

    return null;
  }

  // ============================================================
  // CATEGORY THEME
  // ============================================================

  _CategoryTheme _getCategoryTheme(
    String category,
  ) {
    final String value =
        category
            .toLowerCase()
            .trim();

    if (value.contains(
      'nasihat',
    )) {
      return const _CategoryTheme(
        color: Color(
          0xFF49A95D,
        ),

        background: Color(
          0xFFF1F9EB,
        ),

        iconBackground: Color(
          0xFFE1F3D8,
        ),

        chipBackground: Color(
          0xFFDCF1D5,
        ),
      );
    }

    if (value.contains(
      'jenaka',
    )) {
      return const _CategoryTheme(
        color: Color(
          0xFFF09B36,
        ),

        background: Color(
          0xFFFFF6E8,
        ),

        iconBackground: Color(
          0xFFFFEBC9,
        ),

        chipBackground: Color(
          0xFFFFE8C0,
        ),
      );
    }

    if (value.contains(
      'teka',
    )) {
      return const _CategoryTheme(
        color: Color(
          0xFF5196C7,
        ),

        background: Color(
          0xFFEDF7FE,
        ),

        iconBackground: Color(
          0xFFDDEFFA,
        ),

        chipBackground: Color(
          0xFFDDEFFA,
        ),
      );
    }

    if (value.contains(
      'kiasan',
    )) {
      return const _CategoryTheme(
        color: Color(
          0xFF8062D0,
        ),

        background: Color(
          0xFFF5F1FF,
        ),

        iconBackground: Color(
          0xFFEAE3FF,
        ),

        chipBackground: Color(
          0xFFE8E0FF,
        ),
      );
    }

    if (value.contains(
      'agama',
    )) {
      return const _CategoryTheme(
        color: Color(
          0xFF359C7A,
        ),

        background: Color(
          0xFFEDF9F5,
        ),

        iconBackground: Color(
          0xFFDDF3EB,
        ),

        chipBackground: Color(
          0xFFDDF2EA,
        ),
      );
    }

    return const _CategoryTheme(
      color: primaryColor,

      background: Color(
        0xFFF0FAF8,
      ),

      iconBackground: Color(
        0xFFDFF4F0,
      ),

      chipBackground: Color(
        0xFFDDF4F0,
      ),
    );
  }

  // ============================================================
  // OPTION LETTER
  // ============================================================

  String _optionLetter(
    int index,
  ) {
    const letters = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
    ];

    if (index >= 0 &&
        index <
            letters.length) {
      return letters[index];
    }

    return '${index + 1}';
  }

  // ============================================================
  // CAPITALIZE
  // ============================================================

  String _capitalize(
    String text,
  ) {
    if (text
        .trim()
        .isEmpty) {
      return '-';
    }

    final value =
        text.trim();

    return '${value[0].toUpperCase()}'
        '${value.substring(1).toLowerCase()}';
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError() {
    return Scaffold(
      backgroundColor:
          backgroundColor,

      body:
          SafeArea(
        child:
            Center(
          child:
              Padding(
            padding:
                const EdgeInsets.all(
              30,
            ),

            child:
                Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                Container(
                  width:
                      80,

                  height:
                      80,

                  decoration:
                      const BoxDecoration(
                    color:
                        Color(
                      0xFFFFEAEA,
                    ),

                    shape:
                        BoxShape.circle,
                  ),

                  child:
                      const Icon(
                    Icons
                        .cloud_off_rounded,

                    color:
                        errorColor,

                    size:
                        39,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                Text(
                  'Ups, terjadi masalah',

                  textAlign:
                      TextAlign.center,

                  style:
                      GoogleFonts.poppins(
                    color:
                        darkColor,

                    fontSize:
                        18,

                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 7,
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
                      controller
                          .loadQuestions,

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
                          22,

                      vertical:
                          13,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),

                  icon:
                      const Icon(
                    Icons
                        .refresh_rounded,
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
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty() {
    return Scaffold(
      backgroundColor:
          backgroundColor,

      body:
          SafeArea(
        child:
            Center(
          child:
              Padding(
            padding:
                const EdgeInsets.all(
              30,
            ),

            child:
                Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                Container(
                  width:
                      85,

                  height:
                      85,

                  decoration:
                      const BoxDecoration(
                    color:
                        primaryLight,

                    shape:
                        BoxShape.circle,
                  ),

                  child:
                      const Icon(
                    Icons
                        .quiz_outlined,

                    color:
                        primaryColor,

                    size:
                        43,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                Text(
                  'Belum Ada Soal',

                  style:
                      GoogleFonts.poppins(
                    color:
                        darkColor,

                    fontSize:
                        18,

                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  'Belum ada soal untuk pantun ini.',

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
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CATEGORY THEME
// ============================================================

class _CategoryTheme {
  final Color color;
  final Color background;
  final Color iconBackground;
  final Color chipBackground;

  const _CategoryTheme({
    required this.color,
    required this.background,
    required this.iconBackground,
    required this.chipBackground,
  });
}