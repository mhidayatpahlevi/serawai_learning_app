import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/latihan_controller.dart';

class LatihanView
    extends GetView<LatihanController> {
  const LatihanView({
    super.key,
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryColor =
      Color(0xFF2F9C95);

  static const Color primaryLight =
      Color(0xFFDFF7F3);

  static const Color darkColor =
      Color(0xFF14213D);

  static const Color secondaryText =
      Color(0xFF72809A);

  static const Color backgroundColor =
      Color(0xFFF6FCFC);

  static const Color successColor =
      Color(0xFF48AF69);

  static const Color errorColor =
      Color(0xFFE96767);

  static const Color warningColor =
      Color(0xFFF2B33D);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          backgroundColor,

      body: Obx(
        () {
          // ====================================================
          // LOADING
          // ====================================================

          if (controller
              .isLoading
              .value) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color:
                    primaryColor,
              ),
            );
          }

          // ====================================================
          // ERROR
          // ====================================================

          if (controller
              .errorMessage
              .value
              .isNotEmpty) {
            return _buildError();
          }

          // ====================================================
          // EMPTY
          // ====================================================

          if (controller
              .questions
              .isEmpty) {
            return _buildEmpty();
          }

          final question =
              controller
                  .currentQuestion;

          if (question == null) {
            return _buildEmpty();
          }

          return SafeArea(
            bottom:
                false,

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
                  child:
                      SingleChildScrollView(
                    physics:
                        const BouncingScrollPhysics(),

                    padding:
                        const EdgeInsets.fromLTRB(
                      16,
                      6,
                      16,
                      120,
                    ),

                    child:
                        Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,

                      children: [
                        // =========================================
                        // PROGRESS
                        // =========================================

                        _buildProgress(),

                        const SizedBox(
                          height: 14,
                        ),

                        // =========================================
                        // HEADER
                        // =========================================

                        _buildPantunHeader(),

                        const SizedBox(
                          height: 12,
                        ),

                        // =========================================
                        // PETUNJUK
                        // =========================================

                        _buildInstruction(),

                        const SizedBox(
                          height: 14,
                        ),

                        // =========================================
                        // PANTUN
                        // =========================================

                        _buildPantunCard(),

                        const SizedBox(
                          height: 20,
                        ),

                        // =========================================
                        // INPUT BERDASARKAN LEVEL
                        // =========================================

                        if (controller
                                .inputType ==
                            LatihanInputType
                                .pilihan)
                          _buildPilihanSection()
                        else
                          _buildKetikSection(),

                        // =========================================
                        // NLP FEEDBACK
                        // =========================================

                        if (controller
                            .isAnswered
                            .value) ...[
                          const SizedBox(
                            height: 14,
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
      padding:
          const EdgeInsets.fromLTRB(
        10,
        8,
        10,
        10,
      ),

      decoration:
          const BoxDecoration(
        gradient:
            LinearGradient(
          colors: [
            Color(
              0xFFE8FAFC,
            ),
            Color(
              0xFFF2FCFA,
            ),
          ],
        ),
      ),

      child: Row(
        children: [
          SizedBox(
            width:
                44,

            height:
                44,

            child:
                Material(
              color:
                  Colors.white,

              shape:
                  const CircleBorder(),

              child:
                  InkWell(
                customBorder:
                    const CircleBorder(),

                onTap:
                    () {
                  Get.back();
                },

                child:
                    const Icon(
                  Icons
                      .arrow_back_rounded,

                  color:
                      darkColor,

                  size:
                      26,
                ),
              ),
            ),
          ),

          Expanded(
            child:
                Column(
              children: [
                Text(
                  'Latihan Pantun',

                  style:
                      GoogleFonts.poppins(
                    color:
                        darkColor,

                    fontSize:
                        20,

                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                Text(
                  controller
                          .isPilihanMode
                      ? 'Pilih kata yang tepat'
                      : 'Tulis kata yang tepat',

                  style:
                      GoogleFonts.poppins(
                    color:
                        secondaryText,

                    fontSize:
                        9,
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
        controller
                    .totalQuestions ==
                0
            ? 0
            : controller
                    .currentNumber /
                controller
                    .totalQuestions;

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
          20,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              0.04,
            ),

            blurRadius:
                10,

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
                child:
                    Text(
                  'Soal ${controller.currentNumber} '
                  'dari ${controller.totalQuestions}',

                  style:
                      GoogleFonts.poppins(
                    color:
                        darkColor,

                    fontSize:
                        12,

                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),

              // ===============================================
              // MODE
              // ===============================================

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
                      _modeBackground(),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child:
                    Row(
                  children: [
                    Icon(
                      controller
                              .isPilihanMode
                          ? Icons
                              .touch_app_rounded
                          : Icons
                              .keyboard_alt_rounded,

                      color:
                          _modeColor(),

                      size:
                          13,
                    ),

                    const SizedBox(
                      width: 4,
                    ),

                    Text(
                      controller
                          .inputModeLabel,

                      style:
                          GoogleFonts.poppins(
                        color:
                            _modeColor(),

                        fontSize:
                            8,

                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 6,
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
                      primaryLight,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child:
                    Text(
                  '${(progress * 100).round()}%',

                  style:
                      GoogleFonts.poppins(
                    color:
                        primaryColor,

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
            height: 10,
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
                  9,

              backgroundColor:
                  const Color(
                0xFFDDEEEE,
              ),

              color:
                  primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MODE COLORS
  // ============================================================

  Color _modeColor() {
    if (controller
        .isMixedLevel) {
      return const Color(
        0xFF8062D0,
      );
    }

    if (controller
        .isPilihanMode) {
      return const Color(
        0xFF5196C7,
      );
    }

    return const Color(
      0xFFE18A28,
    );
  }

  Color _modeBackground() {
    if (controller
        .isMixedLevel) {
      return const Color(
        0xFFF0EBFF,
      );
    }

    if (controller
        .isPilihanMode) {
      return const Color(
        0xFFE7F4FC,
      );
    }

    return const Color(
      0xFFFFF0DD,
    );
  }

  // ============================================================
  // PANTUN HEADER
  // ============================================================

  Widget _buildPantunHeader() {
    return Container(
      padding:
          const EdgeInsets.all(
        15,
      ),

      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFF0FAF8,
        ),

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Row(
        children: [
          Container(
            width:
                55,

            height:
                55,

            decoration:
                BoxDecoration(
              color:
                  primaryLight,

              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),

            child:
                const Icon(
              Icons
                  .auto_stories_rounded,

              color:
                  primaryColor,

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
                  CrossAxisAlignment.start,

              children: [
                Text(
                  controller
                      .pantun
                      .judul,

                  maxLines:
                      2,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      GoogleFonts.poppins(
                    color:
                        darkColor,

                    fontSize:
                        15,

                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Wrap(
                  spacing:
                      5,

                  runSpacing:
                      5,

                  children: [
                    _chip(
                      'Level ${controller.levelNumber}',

                      Icons
                          .school_rounded,

                      const Color(
                        0xFF4E7AA7,
                      ),

                      const Color(
                        0xFFE4F1FA,
                      ),
                    ),

                    _chip(
                      controller
                          .inputModeLabel,

                      controller
                              .isPilihanMode
                          ? Icons
                              .touch_app_rounded
                          : Icons
                              .keyboard_alt_rounded,

                      _modeColor(),

                      _modeBackground(),
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

  Widget _chip(
    String text,
    IconData icon,
    Color color,
    Color background,
  ) {
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

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          Icon(
            icon,

            color:
                color,

            size:
                12,
          ),

          const SizedBox(
            width: 3,
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
  // INSTRUCTION
  // ============================================================

  Widget _buildInstruction() {
    return Container(
      padding:
          const EdgeInsets.all(
        13,
      ),

      decoration:
          BoxDecoration(
        color:
            controller
                    .isPilihanMode
                ? const Color(
                    0xFFEAF7FE,
                  )
                : const Color(
                    0xFFFFF5E5,
                  ),

        borderRadius:
            BorderRadius.circular(
          17,
        ),
      ),

      child: Row(
        children: [
          Icon(
            controller
                    .isPilihanMode
                ? Icons
                    .touch_app_rounded
                : Icons
                    .edit_rounded,

            color:
                controller
                        .isPilihanMode
                    ? const Color(
                        0xFF5196C7,
                      )
                    : warningColor,

            size:
                25,
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child:
                Text(
              controller
                      .isPilihanMode
                  ? 'Pilih satu kata yang paling tepat '
                      'untuk melengkapi pantun.'
                  : 'Ketik sendiri kata yang paling tepat. '
                      'Perhatikan makna, konteks, dan rima.',

              style:
                  GoogleFonts.poppins(
                color:
                    darkColor,

                fontSize:
                    10,

                height:
                    1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PANTUN
  // ============================================================

  Widget _buildPantunCard() {
    final question =
        controller
            .currentQuestion;

    if (question == null) {
      return const SizedBox
          .shrink();
    }

    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        22,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        border:
            Border.all(
          color:
              const Color(
            0xFFE5EFEE,
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

      child:
          _buildPantunTemplate(
        question.template,
      ),
    );
  }

  // ============================================================
  // TEMPLATE RUMPANG
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

    final List<InlineSpan>
        spans = [];

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

      final selected =
          controller
              .selectedAnswer
              .value;

      Color color =
          primaryColor;

      Color background =
          selected.isEmpty
              ? const Color(
                  0xFFF4FBFA,
                )
              : primaryLight;

      if (controller
          .isAnswered
          .value) {
        color =
            controller
                    .isCorrect
                    .value
                ? successColor
                : errorColor;

        background =
            controller
                    .isCorrect
                    .value
                ? const Color(
                    0xFFECF9F0,
                  )
                : const Color(
                    0xFFFFF0F0,
                  );
      }

      spans.add(
        WidgetSpan(
          alignment:
              PlaceholderAlignment
                  .middle,

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
                  5,
            ),

            decoration:
                BoxDecoration(
              color:
                  background,

              borderRadius:
                  BorderRadius.circular(
                10,
              ),

              border:
                  Border.all(
                color:
                    color,

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
                    color,

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
  // PILIHAN SECTION
  // ============================================================

  Widget _buildPilihanSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,

      children: [
        Text(
          'Pilih Jawaban',

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
          height: 3,
        ),

        Text(
          'Pilih satu kata yang '
          'menurutmu paling tepat.',

          style:
              GoogleFonts.poppins(
            color:
                secondaryText,

            fontSize:
                10,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        ...List.generate(
          controller
              .displayedOptions
              .length,

          (
            index,
          ) {
            return _buildOption(
              controller
                      .displayedOptions[
                  index],

              index,
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // KETIK SECTION
  // ============================================================

  Widget _buildKetikSection() {
    final bool answered =
        controller
            .isAnswered
            .value;

    final bool correct =
        controller
            .isCorrect
            .value;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,

      children: [
        Text(
          'Tulis Jawaban',

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
          height: 3,
        ),

        Text(
          controller
                  .isMixedLevel
              ? 'Mode campuran: tulis jawaban untuk soal ini.'
              : 'Ketik kata yang tepat untuk melengkapi pantun.',

          style:
              GoogleFonts.poppins(
            color:
                secondaryText,

            fontSize:
                10,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        TextField(
          controller:
              controller
                  .answerTextController,

          enabled:
              !answered &&
                  !controller
                      .isChecking
                      .value,

          onChanged:
              controller
                  .updateTypedAnswer,

          onSubmitted:
              (
            value,
          ) {
            if (!answered &&
                controller
                    .selectedAnswer
                    .value
                    .isNotEmpty) {
              controller
                  .checkAnswer();
            }
          },

          textInputAction:
              TextInputAction.done,

          autocorrect:
              false,

          style:
              GoogleFonts.poppins(
            color:
                darkColor,

            fontSize:
                14,

            fontWeight:
                FontWeight.w600,
          ),

          decoration:
              InputDecoration(
            hintText:
                'Ketik jawabanmu di sini...',

            hintStyle:
                GoogleFonts.poppins(
              color:
                  secondaryText,

              fontSize:
                  11,
            ),

            prefixIcon:
                Icon(
              Icons
                  .edit_rounded,

              color:
                  answered
                      ? correct
                          ? successColor
                          : errorColor
                      : primaryColor,
            ),

            suffixIcon:
                answered
                    ? Icon(
                        correct
                            ? Icons
                                .check_circle_rounded
                            : Icons
                                .cancel_rounded,

                        color:
                            correct
                                ? successColor
                                : errorColor,
                      )
                    : controller
                            .typedAnswer
                            .value
                            .isNotEmpty
                        ? IconButton(
                            onPressed:
                                controller
                                    .clearTypedAnswer,

                            icon:
                                const Icon(
                              Icons
                                  .close_rounded,
                            ),
                          )
                        : null,

            filled:
                true,

            fillColor:
                answered
                    ? correct
                        ? const Color(
                            0xFFECF9F0,
                          )
                        : const Color(
                            0xFFFFF0F0,
                          )
                    : Colors.white,

            contentPadding:
                const EdgeInsets.symmetric(
              horizontal:
                  16,

              vertical:
                  18,
            ),

            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                17,
              ),

              borderSide:
                  const BorderSide(
                color:
                    Color(
                  0xFFDDE7EB,
                ),
              ),
            ),

            disabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                17,
              ),

              borderSide:
                  BorderSide(
                color:
                    correct
                        ? successColor
                        : errorColor,

                width:
                    1.5,
              ),
            ),

            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                17,
              ),

              borderSide:
                  const BorderSide(
                color:
                    primaryColor,

                width:
                    1.7,
              ),
            ),
          ),
        ),

        if (!answered) ...[
          const SizedBox(
            height: 9,
          ),

          Container(
            padding:
                const EdgeInsets.all(
              11,
            ),

            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFFFF7E8,
              ),

              borderRadius:
                  BorderRadius.circular(
                13,
              ),
            ),

            child:
                Row(
              children: [
                const Icon(
                  Icons
                      .lightbulb_outline_rounded,

                  color:
                      warningColor,

                  size:
                      17,
                ),

                const SizedBox(
                  width: 7,
                ),

                Expanded(
                  child:
                      Text(
                    'Perhatikan makna, konteks, '
                    'dan rima sebelum menulis jawaban.',

                    style:
                        GoogleFonts.poppins(
                      color:
                          const Color(
                        0xFF77694A,
                      ),

                      fontSize:
                          9,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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
        controller
            .currentQuestion;

    final bool reference =
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

    IconData icon =
        Icons
            .radio_button_unchecked_rounded;

    Color iconColor =
        const Color(
      0xFFAEBCCC,
    );

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

      icon =
          Icons
              .radio_button_checked_rounded;

      iconColor =
          primaryColor;
    }

    if (answered &&
        selected &&
        controller
            .isCorrect
            .value) {
      borderColor =
          successColor;

      background =
          const Color(
        0xFFECF9F0,
      );

      circleColor =
          successColor;

      icon =
          Icons
              .check_circle_rounded;

      iconColor =
          successColor;
    }

    if (answered &&
        selected &&
        !controller
            .isCorrect
            .value) {
      borderColor =
          errorColor;

      background =
          const Color(
        0xFFFFF0F0,
      );

      circleColor =
          errorColor;

      icon =
          Icons.cancel_rounded;

      iconColor =
          errorColor;
    }

    if (answered &&
        !controller
            .isCorrect
            .value &&
        reference &&
        !selected) {
      borderColor =
          successColor;

      background =
          const Color(
        0xFFECF9F0,
      );

      circleColor =
          successColor;

      icon =
          Icons
              .check_circle_outline_rounded;

      iconColor =
          successColor;
    }

    return Container(
      margin:
          const EdgeInsets.only(
        bottom:
            10,
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
                      reference
                  ? 1.5
                  : 1,
        ),
      ),

      child:
          InkWell(
        onTap:
            answered
                ? null
                : () {
                    controller
                        .selectAnswer(
                      option,
                    );
                  },

        borderRadius:
            BorderRadius.circular(
          17,
        ),

        child:
            Padding(
          padding:
              const EdgeInsets.all(
            13,
          ),

          child:
              Row(
            children: [
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
                  _letter(
                    index,
                  ),

                  style:
                      GoogleFonts.poppins(
                    color:
                        selected ||
                                (answered &&
                                    reference)
                            ? Colors.white
                            : const Color(
                                0xFF36779D,
                              ),

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
                        darkColor,

                    fontSize:
                        13,

                    fontWeight:
                        selected
                            ? FontWeight
                                .w700
                            : FontWeight
                                .w500,
                  ),
                ),
              ),

              Icon(
                icon,

                color:
                    iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // NLP FEEDBACK
  // ============================================================

  Widget _buildFeedback() {
    final question =
        controller
            .currentQuestion;

    final result =
        controller
            .nlpResult
            .value;

    if (question == null ||
        result == null) {
      return const SizedBox
          .shrink();
    }

    final bool correct =
        result.isCorrect;

    return Container(
      padding:
          const EdgeInsets.all(
        16,
      ),

      decoration:
          BoxDecoration(
        color:
            correct
                ? const Color(
                    0xFFF0FAF2,
                  )
                : const Color(
                    0xFFFFF2F2,
                  ),

        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),

      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                correct
                    ? Icons
                        .check_circle_rounded
                    : Icons
                        .cancel_rounded,

                color:
                    correct
                        ? successColor
                        : errorColor,

                size:
                    35,
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child:
                    Text(
                  correct
                      ? 'Jawaban Benar! 🎉'
                      : 'Belum Tepat',

                  style:
                      GoogleFonts.poppins(
                    color:
                        correct
                            ? successColor
                            : errorColor,

                    fontSize:
                        17,

                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 15,
          ),

          _scoreItem(
            'Makna',

            result.semanticScore,

            const Color(
              0xFF44A96F,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          _scoreItem(
            'Konteks',

            result.contextScore,

            const Color(
              0xFF3AAE9E,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          _scoreItem(
            'Rima',

            result.rhymeScore,

            const Color(
              0xFF5196C7,
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          Text(
            'Penjelasan',

            style:
                GoogleFonts.poppins(
              color:
                  darkColor,

              fontSize:
                  12,

              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            result.explanation,

            style:
                GoogleFonts.poppins(
              color:
                  secondaryText,

              fontSize:
                  10,

              height:
                  1.5,
            ),
          ),

          if (!correct) ...[
            const SizedBox(
              height: 12,
            ),

            Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets.all(
                12,
              ),

              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFEAF8EF,
                ),

                borderRadius:
                    BorderRadius.circular(
                  13,
                ),
              ),

              child:
                  Text(
                'Jawaban tepat: '
                '${question.referenceAnswer}',

                style:
                    GoogleFonts.poppins(
                  color:
                      const Color(
                    0xFF267B50,
                  ),

                  fontSize:
                      11,

                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _scoreItem(
    String title,
    double score,
    Color color,
  ) {
    final value =
        score
            .clamp(
              0.0,
              1.0,
            )
            .toDouble();

    return Row(
      children: [
        SizedBox(
          width:
              65,

          child:
              Text(
            title,

            style:
                GoogleFonts.poppins(
              fontSize:
                  9,

              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),

        Expanded(
          child:
              LinearProgressIndicator(
            value:
                value,

            minHeight:
                7,

            backgroundColor:
                color.withOpacity(
              0.15,
            ),

            color:
                color,
          ),
        ),

        const SizedBox(
          width: 8,
        ),

        Text(
          '${(value * 100).round()}%',

          style:
              GoogleFonts.poppins(
            fontSize:
                9,

            fontWeight:
                FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM
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
    if (!controller
        .isAnswered
        .value) {
      final bool loading =
          controller
              .isChecking
              .value;

      final bool hasAnswer =
          controller
              .selectedAnswer
              .value
              .trim()
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
              ElevatedButton
                  .styleFrom(
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
                        Icon(
                          controller
                                  .isKetikMode
                              ? Icons
                                  .psychology_alt_rounded
                              : Icons
                                  .check_circle_rounded,
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
                      ],
                    ),
        ),
      );
    }

    return SizedBox(
      height:
          55,

      child:
          ElevatedButton(
        onPressed:
            controller
                    .isSavingResult
                    .value
                ? null
                : controller
                    .nextQuestion,

        style:
            ElevatedButton
                .styleFrom(
          backgroundColor:
              primaryColor,

          foregroundColor:
              Colors.white,

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
      ),
    );
  }

  // ============================================================
  // LETTER
  // ============================================================

  String _letter(
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

    if (index <
        letters.length) {
      return letters[index];
    }

    return '${index + 1}';
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError() {
    return Center(
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
            const Icon(
              Icons
                  .error_outline_rounded,

              color:
                  errorColor,

              size:
                  60,
            ),

            const SizedBox(
              height: 15,
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
                    darkColor,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            ElevatedButton.icon(
              onPressed:
                  controller
                      .loadQuestions,

              icon:
                  const Icon(
                Icons
                    .refresh_rounded,
              ),

              label:
                  const Text(
                'Coba Lagi',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty() {
    return Center(
      child:
          Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          const Icon(
            Icons.quiz_outlined,

            color:
                primaryColor,

            size:
                60,
          ),

          const SizedBox(
            height: 12,
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
                  FontWeight.w700,
            ),
          ),

          Text(
            'Belum ada soal untuk pantun ini.',

            style:
                GoogleFonts.poppins(
              color:
                  secondaryText,

              fontSize:
                  10,
            ),
          ),
        ],
      ),
    );
  }
}