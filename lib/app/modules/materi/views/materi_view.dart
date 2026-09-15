import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/materi_controller.dart';

class MateriView extends GetView<MateriController> {
  const MateriView({
    super.key,
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryColor =
      Color(0xFF2F9C95);

  static const Color darkColor =
      Color(0xFF14213D);

  static const Color secondaryText =
      Color(0xFF73809A);

  static const Color backgroundColor =
      Color(0xFFF8FCFC);

  static const Color greenColor =
      Color(0xFF4EAD5F);

  static const Color blueColor =
      Color(0xFF5196C7);

  static const Color orangeColor =
      Color(0xFFF4A340);

  static const Color purpleColor =
      Color(0xFF8062D0);

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
          // ERROR
          // ====================================================

          if (controller
              .errorMessage
              .value
              .isNotEmpty) {
            return _buildError();
          }

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
                  child:
                      RefreshIndicator(
                    color:
                        primaryColor,

                    onRefresh:
                        controller
                            .refreshVocabulary,

                    child:
                        ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(
                        parent:
                            BouncingScrollPhysics(),
                      ),

                      padding:
                          const EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        35,
                      ),

                      children: [
                        // =========================================
                        // HERO
                        // =========================================

                        _buildHeroCard(),

                        const SizedBox(
                          height: 16,
                        ),

                        // =========================================
                        // POLA RIMA
                        // =========================================

                        _buildRhymeCard(),

                        const SizedBox(
                          height: 28,
                        ),

                        // =========================================
                        // PANTUN SERAWAI
                        // =========================================

                        _buildSectionTitle(
                          icon:
                              Icons
                                  .auto_stories_rounded,

                          iconColor:
                              blueColor,

                          iconBackground:
                              const Color(
                            0xFFE6F3FD,
                          ),

                          title:
                              'Pantun Bahasa Serawai',

                          subtitle:
                              'Bacalah pantun dalam Bahasa Serawai berikut.',
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        _buildPantunCard(),

                        const SizedBox(
                          height: 28,
                        ),

                        // =========================================
                        // TERJEMAHAN
                        // =========================================

                        _buildSectionTitle(
                          icon:
                              Icons
                                  .menu_book_rounded,

                          iconColor:
                              blueColor,

                          iconBackground:
                              const Color(
                            0xFFE4F4FD,
                          ),

                          title:
                              'Terjemahan Bahasa Indonesia',

                          subtitle:
                              'Pahami arti pantun dalam Bahasa Indonesia.',
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        _buildTranslationCard(),

                        const SizedBox(
                          height: 28,
                        ),

                        // =========================================
                        // MAKNA PER BARIS
                        // =========================================

                        _buildSectionTitle(
                          icon:
                              Icons
                                  .tips_and_updates_rounded,

                          iconColor:
                              greenColor,

                          iconBackground:
                              const Color(
                            0xFFE8F8EB,
                          ),

                          title:
                              'Makna Setiap Baris',

                          subtitle:
                              'Pahami arti dan pesan dari setiap baris pantun.',
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        _buildLineTranslation(),

                        const SizedBox(
                          height: 28,
                        ),

                        // =========================================
                        // KOSAKATA
                        // =========================================

                        _buildSectionTitle(
                          icon:
                              Icons
                                  .translate_rounded,

                          iconColor:
                              const Color(
                            0xFFE06C56,
                          ),

                          iconBackground:
                              const Color(
                            0xFFFFEAE5,
                          ),

                          title:
                              'Kosakata Bahasa Serawai',

                          subtitle:
                              'Pelajari kosakata penting yang terdapat dalam pantun.',
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        // =========================================
                        // VOCABULARY
                        // =========================================

                        if (controller
                            .isLoading.value)
                          _buildVocabularyLoading()
                        else if (controller
                            .vocabularyList
                            .isEmpty)
                          _buildEmptyVocabulary()
                        else
                          ...controller
                              .vocabularyList
                              .map(
                            (
                              vocabulary,
                            ) {
                              return _buildVocabularyCard(
                                serawai:
                                    vocabulary
                                        .serawai,

                                indonesia:
                                    vocabulary
                                        .indonesia,

                                keterangan:
                                    vocabulary
                                        .keterangan,
                              );
                            },
                          ),

                        const SizedBox(
                          height: 24,
                        ),

                        // =========================================
                        // MOTIVATION
                        // =========================================

                        _buildMotivationCard(),

                        const SizedBox(
                          height: 16,
                        ),

                        // =========================================
                        // SELESAI
                        // =========================================

                        _buildFinishButton(),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          'Teruslah belajar, jaga dan lestarikan '
                          'Bahasa serta budaya Serawai.',

                          textAlign:
                              TextAlign.center,

                          style:
                              GoogleFonts.poppins(
                            color:
                                secondaryText,

                            fontSize:
                                9,

                            fontStyle:
                                FontStyle
                                    .italic,
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),
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
      padding:
          const EdgeInsets.fromLTRB(
        10,
        7,
        10,
        10,
      ),

      decoration:
          const BoxDecoration(
        color:
            Colors.white,

        border:
            Border(
          bottom:
              BorderSide(
            color:
                Color(
              0xFFEAF0F2,
            ),
          ),
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
                  const Color(
                0xFFF3F8FA,
              ),

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
                      .arrow_back_ios_new_rounded,

                  size:
                      19,

                  color:
                      darkColor,
                ),
              ),
            ),
          ),

          Expanded(
            child:
                Column(
              children: [
                Text(
                  'Pelajari Pantun',

                  style:
                      GoogleFonts.poppins(
                    color:
                        darkColor,

                    fontSize:
                        19,

                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 1,
                ),

                Text(
                  'Kenali makna dan keindahan pantun',

                  style:
                      GoogleFonts.poppins(
                    color:
                        secondaryText,

                    fontSize:
                        8,
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
  // HERO
  // ============================================================

  Widget _buildHeroCard() {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        20,
      ),

      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(
              0xFFDDF5F4,
            ),

            Color(
              0xFFE8F7FB,
            ),

            Color(
              0xFFFFF5E7,
            ),
          ],

          begin:
              Alignment.topLeft,

          end:
              Alignment.bottomRight,
        ),

        borderRadius:
            BorderRadius.circular(
          26,
        ),
      ),

      child:
          Stack(
        children: [
          // ====================================================
          // DECORATION
          // ====================================================

          Positioned(
            right:
                -10,

            bottom:
                -12,

            child:
                Icon(
              Icons
                  .auto_stories_rounded,

              color:
                  Colors.white
                      .withOpacity(
                0.65,
              ),

              size:
                  100,
            ),
          ),

          Positioned(
            right:
                15,

            top:
                5,

            child:
                Icon(
              Icons
                  .eco_rounded,

              color:
                  primaryColor
                      .withOpacity(
                0.14,
              ),

              size:
                  70,
            ),
          ),

          // ====================================================
          // CONTENT
          // ====================================================

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Wrap(
                spacing:
                    7,

                runSpacing:
                    7,

                children: [
                  _buildHeroChip(
                    icon:
                        Icons
                            .category_rounded,

                    text:
                        controller
                            .pantun
                            .kategori,

                    color:
                        primaryColor,

                    background:
                        Colors.white
                            .withOpacity(
                      0.75,
                    ),
                  ),

                  _buildHeroChip(
                    icon:
                        Icons
                            .signal_cellular_alt_rounded,

                    text:
                        controller
                            .pantun
                            .level,

                    color:
                        const Color(
                      0xFF5682A0,
                    ),

                    background:
                        Colors.white
                            .withOpacity(
                      0.75,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 16,
              ),

              SizedBox(
                width:
                    275,

                child:
                    Text(
                  controller
                      .pantun
                      .judul,

                  style:
                      GoogleFonts.poppins(
                    color:
                        darkColor,

                    fontSize:
                        24,

                    height:
                        1.25,

                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              SizedBox(
                width:
                    270,

                child:
                    Text(
                  '“Pantun adalah warisan budaya '
                  'yang menyimpan nilai kehidupan.”',

                  style:
                      GoogleFonts.poppins(
                    color:
                        const Color(
                      0xFF456E78,
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
        ],
      ),
    );
  }

  // ============================================================
  // HERO CHIP
  // ============================================================

  Widget _buildHeroChip({
    required IconData icon,
    required String text,
    required Color color,
    required Color background,
  }) {
    return Container(
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

            size:
                13,

            color:
                color,
          ),

          const SizedBox(
            width: 5,
          ),

          Text(
            text,

            style:
                GoogleFonts.poppins(
              color:
                  color,

              fontSize:
                  9,

              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle({
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Container(
          width:
              42,

          height:
              42,

          decoration:
              BoxDecoration(
            color:
                iconBackground,

            borderRadius:
                BorderRadius.circular(
              13,
            ),
          ),

          child:
              Icon(
            icon,

            color:
                iconColor,

            size:
                22,
          ),
        ),

        const SizedBox(
          width: 11,
        ),

        Expanded(
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,

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
                height: 2,
              ),

              Text(
                subtitle,

                style:
                    GoogleFonts.poppins(
                  color:
                      secondaryText,

                  fontSize:
                      9,

                  height:
                      1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RIMA
  // ============================================================

  Widget _buildRhymeCard() {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        16,
      ),

      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(
              0xFFDDF8F3,
            ),

            Color(
              0xFFEAF9F6,
            ),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),

      child:
          Row(
        children: [
          Container(
            width:
                56,

            height:
                56,

            decoration:
                BoxDecoration(
              color:
                  primaryColor,

              borderRadius:
                  BorderRadius.circular(
                17,
              ),
            ),

            child:
                const Icon(
              Icons
                  .music_note_rounded,

              color:
                  Colors.white,

              size:
                  30,
            ),
          ),

          const SizedBox(
            width: 13,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Pola Rima',

                  style:
                      GoogleFonts.poppins(
                    color:
                        const Color(
                      0xFF156E68,
                    ),

                    fontSize:
                        15,

                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  'Pola bunyi akhir setiap baris',

                  style:
                      GoogleFonts.poppins(
                    color:
                        const Color(
                      0xFF4E7C79,
                    ),

                    fontSize:
                        8,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  15,

              vertical:
                  11,
            ),

            decoration:
                BoxDecoration(
              color:
                  Colors.white
                      .withOpacity(
                0.70,
              ),

              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),

            child:
                Text(
              controller
                  .pantun
                  .polaRima
                  .toUpperCase(),

              style:
                  GoogleFonts.poppins(
                color:
                    const Color(
                  0xFF156E68,
                ),

                fontSize:
                    17,

                fontWeight:
                    FontWeight.w800,

                letterSpacing:
                    1,
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
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        17,
      ),

      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(
              0xFFFFF9EE,
            ),

            Color(
              0xFFFFF4E4,
            ),
          ],

          begin:
              Alignment.topLeft,

          end:
              Alignment.bottomRight,
        ),

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border:
            Border.all(
          color:
              const Color(
            0xFFFFEBD2,
          ),
        ),
      ),

      child:
          Column(
        children:
            List.generate(
          controller
              .pantun
              .baris
              .length,

          (
            index,
          ) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(
                vertical:
                    6,
              ),

              child:
                  Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center,

                children: [
                  Container(
                    width:
                        35,

                    height:
                        35,

                    alignment:
                        Alignment.center,

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFFFE5B8,
                      ),

                      shape:
                          BoxShape.circle,
                    ),

                    child:
                        Text(
                      '${index + 1}',

                      style:
                          GoogleFonts.poppins(
                        color:
                            const Color(
                          0xFF9B662C,
                        ),

                        fontSize:
                            11,

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
                      controller
                          .pantun
                          .baris[index],

                      style:
                          GoogleFonts.poppins(
                        color:
                            darkColor,

                        fontSize:
                            13,

                        height:
                            1.5,

                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // TRANSLATION
  // ============================================================

  Widget _buildTranslationCard() {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        17,
      ),

      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(
              0xFFEAF7FE,
            ),

            Color(
              0xFFF1FAFE,
            ),
          ],

          begin:
              Alignment.topLeft,

          end:
              Alignment.bottomRight,
        ),

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border:
            Border.all(
          color:
              const Color(
            0xFFDCEFFB,
          ),
        ),
      ),

      child:
          Column(
        children:
            List.generate(
          controller
              .pantun
              .terjemahan
              .length,

          (
            index,
          ) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(
                vertical:
                    6,
              ),

              child:
                  Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center,

                children: [
                  Container(
                    width:
                        35,

                    height:
                        35,

                    alignment:
                        Alignment.center,

                    decoration:
                        const BoxDecoration(
                      color:
                          Color(
                        0xFFD8EEFC,
                      ),

                      shape:
                          BoxShape.circle,
                    ),

                    child:
                        Text(
                      '${index + 1}',

                      style:
                          GoogleFonts.poppins(
                        color:
                            blueColor,

                        fontSize:
                            11,

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
                      controller
                          .pantun
                          .terjemahan[index],

                      style:
                          GoogleFonts.poppins(
                        color:
                            darkColor,

                        fontSize:
                            12,

                        height:
                            1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // MAKNA SETIAP BARIS
  // ============================================================

  Widget _buildLineTranslation() {
    final pantunLines =
        controller.pantun.baris;

    final translations =
        controller
            .pantun
            .terjemahan;

    final int count =
        pantunLines.length <
                translations.length
            ? pantunLines.length
            : translations.length;

    return Column(
      children:
          List.generate(
        count,
        (
          index,
        ) {
          final theme =
              _getLineTheme(
            index,
          );

          return Container(
            margin:
                const EdgeInsets.only(
              bottom:
                  10,
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
                20,
              ),

              border:
                  Border.all(
                color:
                    const Color(
                  0xFFE8EFF2,
                ),
              ),

              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black
                          .withOpacity(
                    0.025,
                  ),

                  blurRadius:
                      8,

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
                  CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Container(
                      width:
                          38,

                      height:
                          38,

                      alignment:
                          Alignment.center,

                      decoration:
                          BoxDecoration(
                        color:
                            theme.color,

                        shape:
                            BoxShape.circle,
                      ),

                      child:
                          Text(
                        '${index + 1}',

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

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal:
                            10,

                        vertical:
                            5,
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

                      child:
                          Text(
                        'Baris ${index + 1}',

                        style:
                            GoogleFonts.poppins(
                          color:
                              theme.color,

                          fontSize:
                              9,

                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 11,
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(
                    left:
                        47,
                  ),

                  child:
                      Text(
                    pantunLines[index],

                    style:
                        GoogleFonts.poppins(
                      color:
                          darkColor,

                      fontSize:
                          12,

                      fontWeight:
                          FontWeight.w600,

                      height:
                          1.45,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 11,
                ),

                Container(
                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets.all(
                    11,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFFFF5E8,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),

                  child:
                      Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Container(
                        width:
                            31,

                        height:
                            31,

                        decoration:
                            const BoxDecoration(
                          color:
                              Color(
                            0xFFFFE7C2,
                          ),

                          shape:
                              BoxShape.circle,
                        ),

                        child:
                            const Icon(
                          Icons
                              .lightbulb_rounded,

                          color:
                              orangeColor,

                          size:
                              18,
                        ),
                      ),

                      const SizedBox(
                        width: 9,
                      ),

                      Expanded(
                        child:
                            Text(
                          translations[index],

                          style:
                              GoogleFonts.poppins(
                            color:
                                const Color(
                              0xFF4D5D72,
                            ),

                            fontSize:
                                10,

                            height:
                                1.5,
                          ),
                        ),
                      ),
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
  // VOCABULARY CARD
  // ============================================================

  Widget _buildVocabularyCard({
    required String serawai,
    required String indonesia,
    required String keterangan,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom:
            10,
      ),

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
          20,
        ),

        border:
            Border.all(
          color:
              const Color(
            0xFFE6EDF0,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              0.025,
            ),

            blurRadius:
                8,

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
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width:
                    45,

                height:
                    45,

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFEAF7FC,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),

                child:
                    const Icon(
                  Icons
                      .translate_rounded,

                  color:
                      blueColor,

                  size:
                      23,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      serawai,

                      style:
                          GoogleFonts.poppins(
                        color:
                            darkColor,

                        fontSize:
                            14,

                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(
                      height: 1,
                    ),

                    Text(
                      'Bahasa Serawai',

                      style:
                          GoogleFonts.poppins(
                        color:
                            secondaryText,

                        fontSize:
                            8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              Container(
                constraints:
                    const BoxConstraints(
                  minWidth:
                      90,

                  maxWidth:
                      140,
                ),

                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      11,

                  vertical:
                      8,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFE7F7F2,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    13,
                  ),
                ),

                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      indonesia,

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
                            FontWeight.w700,
                      ),
                    ),

                    Text(
                      'Bahasa Indonesia',

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
              ),
            ],
          ),

          if (keterangan
              .trim()
              .isNotEmpty) ...[
            const SizedBox(
              height: 10,
            ),

            Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets.all(
                10,
              ),

              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFF6F9FA,
                ),

                borderRadius:
                    BorderRadius.circular(
                  13,
                ),
              ),

              child:
                  Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Icon(
                    Icons
                        .info_outline_rounded,

                    color:
                        Color(
                      0xFF8A9CB1,
                    ),

                    size:
                        16,
                  ),

                  const SizedBox(
                    width: 7,
                  ),

                  Expanded(
                    child:
                        RichText(
                      text:
                          TextSpan(
                        style:
                            GoogleFonts.poppins(
                          color:
                              secondaryText,

                          fontSize:
                              8,

                          height:
                              1.5,
                        ),

                        children: [
                          TextSpan(
                            text:
                                'Keterangan: ',

                            style:
                                GoogleFonts.poppins(
                              color:
                                  const Color(
                                0xFF586A80,
                              ),

                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),

                          TextSpan(
                            text:
                                keterangan,
                          ),
                        ],
                      ),
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
  // VOCABULARY LOADING
  // ============================================================

  Widget _buildVocabularyLoading() {
    return Container(
      padding:
          const EdgeInsets.all(
        26,
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
          const CircularProgressIndicator(
            color:
                primaryColor,

            strokeWidth:
                3,
          ),

          const SizedBox(
            height: 12,
          ),

          Text(
            'Memuat kosakata...',

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

  // ============================================================
  // EMPTY VOCABULARY
  // ============================================================

  Widget _buildEmptyVocabulary() {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        24,
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
          Container(
            width:
                55,

            height:
                55,

            decoration:
                const BoxDecoration(
              color:
                  Color(
                0xFFE7F7F4,
              ),

              shape:
                  BoxShape.circle,
            ),

            child:
                const Icon(
              Icons
                  .translate_rounded,

              color:
                  primaryColor,

              size:
                  28,
            ),
          ),

          const SizedBox(
            height: 11,
          ),

          Text(
            'Belum Ada Kosakata',

            style:
                GoogleFonts.poppins(
              color:
                  darkColor,

              fontSize:
                  13,

              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            'Kosakata untuk pantun ini belum tersedia.',

            textAlign:
                TextAlign.center,

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
    );
  }

  // ============================================================
  // MOTIVATION
  // ============================================================

  Widget _buildMotivationCard() {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        15,
      ),

      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(
              0xFFE7F7F5,
            ),

            Color(
              0xFFF0FBFC,
            ),
          ],
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
                primaryColor,

            size:
                27,
          ),

          const SizedBox(
            width: 8,
          ),

          Expanded(
            child:
                Text(
              'Setiap pantun yang kamu pelajari '
              'adalah satu langkah untuk mengenal '
              'dan melestarikan Bahasa Serawai.',

              style:
                  GoogleFonts.poppins(
                color:
                    const Color(
                  0xFF537879,
                ),

                fontSize:
                    9,

                height:
                    1.6,

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
  // FINISH BUTTON
  // ============================================================

  Widget _buildFinishButton() {
    return SizedBox(
      width:
          double.infinity,

      height:
          54,

      child:
          ElevatedButton(
        onPressed:
            () {
          Get.back();
        },

        style:
            ElevatedButton.styleFrom(
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
              17,
            ),
          ),
        ),

        child:
            Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            const Icon(
              Icons
                  .check_circle_rounded,

              size:
                  20,
            ),

            const SizedBox(
              width: 8,
            ),

            Text(
              'Selesai Belajar',

              style:
                  GoogleFonts.poppins(
                fontSize:
                    12,

                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LINE THEME
  // ============================================================

  _LineTheme _getLineTheme(
    int index,
  ) {
    final themes = [
      const _LineTheme(
        color:
            Color(
          0xFF2FA88F,
        ),

        background:
            Color(
          0xFFE2F7F1,
        ),
      ),

      const _LineTheme(
        color:
            Color(
          0xFF3D92D1,
        ),

        background:
            Color(
          0xFFE7F4FE,
        ),
      ),

      const _LineTheme(
        color:
            Color(
          0xFFE57C23,
        ),

        background:
            Color(
          0xFFFFEFE0,
        ),
      ),

      const _LineTheme(
        color:
            Color(
          0xFF7C5BD1,
        ),

        background:
            Color(
          0xFFF0EBFF,
        ),
      ),
    ];

    return themes[
        index %
            themes.length];
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
              28,
            ),

            child:
                Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                Container(
                  width:
                      82,

                  height:
                      82,

                  decoration:
                      const BoxDecoration(
                    color:
                        Color(
                      0xFFFFECEE,
                    ),

                    shape:
                        BoxShape.circle,
                  ),

                  child:
                      const Icon(
                    Icons
                        .error_outline_rounded,

                    color:
                        Color(
                      0xFFE96570,
                    ),

                    size:
                        42,
                  ),
                ),

                const SizedBox(
                  height: 17,
                ),

                Text(
                  'Materi Tidak Dapat Dimuat',

                  textAlign:
                      TextAlign.center,

                  style:
                      GoogleFonts.poppins(
                    color:
                        darkColor,

                    fontSize:
                        17,

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
                        10,

                    height:
                        1.5,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  height:
                      48,

                  child:
                      ElevatedButton.icon(
                    onPressed:
                        controller
                            .loadVocabulary,

                    style:
                        ElevatedButton.styleFrom(
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
                          15,
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
// LINE THEME
// ============================================================

class _LineTheme {
  final Color color;

  final Color background;

  const _LineTheme({
    required this.color,
    required this.background,
  });
}