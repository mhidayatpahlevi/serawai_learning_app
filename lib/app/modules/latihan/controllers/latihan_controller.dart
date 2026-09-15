import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/answer_history_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/latihan_history_model.dart';
import '../../../data/models/nlp_result_model.dart';
import '../../../data/models/pantun_model.dart';
import '../../../data/models/question_model.dart';

import '../../../data/services/history_service.dart';
import '../../../data/services/nlp_service.dart';
import '../../../data/services/pantun_service.dart';
import '../../../data/services/progress_service.dart';

import '../../../routes/app_routes.dart';

import '../../kategori/controllers/kategori_controller.dart';

class LatihanController extends GetxController {
  // ============================================================
  // UI COLORS
  // ============================================================

  static const Color primaryColor =
      Color(0xFF2F9C95);

  static const Color darkColor =
      Color(0xFF14213D);

  static const Color secondaryText =
      Color(0xFF73809A);

  static const Color successColor =
      Color(0xFF45B96B);

  static const Color errorColor =
      Color(0xFFE96570);

  static const Color warningColor =
      Color(0xFFF3AE35);

  static const Color blueColor =
      Color(0xFF4A9DDA);

  // ============================================================
  // SERVICES
  // ============================================================

  final PantunService _pantunService =
      Get.find<PantunService>();

  final HistoryService _historyService =
      Get.find<HistoryService>();

  final NlpService _nlpService =
      Get.find<NlpService>();

  final ProgressService _progressService =
      Get.find<ProgressService>();

  // ============================================================
  // DATA UTAMA
  // ============================================================

  late final PantunModel pantun;

  late final CategoryModel category;

  // ============================================================
  // STATE SOAL
  // ============================================================

  final questions =
      <QuestionModel>[].obs;

  final currentIndex =
      0.obs;

  final selectedAnswer =
      ''.obs;

  final displayedOptions =
      <String>[].obs;

  final isLoading =
      false.obs;

  final isChecking =
      false.obs;

  final isAnswered =
      false.obs;

  final isCorrect =
      false.obs;

  final errorMessage =
      ''.obs;

  // ============================================================
  // STATE HASIL
  // ============================================================

  final correctCount =
      0.obs;

  final wrongCount =
      0.obs;

  final isSavingResult =
      false.obs;

  final resultSaved =
      false.obs;

  final progressSaved =
      false.obs;

  // ============================================================
  // NLP
  // ============================================================

  final nlpResult =
      Rxn<NlpResultModel>();

  // ============================================================
  // HISTORY JAWABAN
  // ============================================================

  final answerHistory =
      <AnswerHistoryModel>[].obs;

  // ============================================================
  // GETTERS
  // ============================================================

  QuestionModel? get currentQuestion {
    if (questions.isEmpty) {
      return null;
    }

    if (currentIndex.value < 0 ||
        currentIndex.value >=
            questions.length) {
      return null;
    }

    return questions[
        currentIndex.value];
  }

  int get currentNumber {
    if (questions.isEmpty) {
      return 0;
    }

    return currentIndex.value + 1;
  }

  int get totalQuestions {
    return questions.length;
  }

  bool get isLastQuestion {
    if (questions.isEmpty) {
      return true;
    }

    return currentIndex.value ==
        questions.length - 1;
  }

  double get score {
    if (questions.isEmpty) {
      return 0;
    }

    return correctCount.value /
        questions.length *
        100;
  }

  bool get isPassed {
    return score >=
        ProgressService.passingScore;
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    final arguments =
        Get.arguments;

    if (arguments is Map &&
        arguments['pantun']
            is PantunModel &&
        arguments['category']
            is CategoryModel) {
      pantun =
          arguments['pantun']
              as PantunModel;

      category =
          arguments['category']
              as CategoryModel;

      loadQuestions();

      return;
    }

    errorMessage.value =
        'Data pantun atau kategori '
        'tidak ditemukan.';

    debugPrint(
      'ERROR ARGUMENT LATIHAN: '
      '$arguments',
    );
  }

  // ============================================================
  // LOAD QUESTIONS
  // ============================================================

  Future<void> loadQuestions() async {
    try {
      isLoading.value =
          true;

      errorMessage.value =
          '';

      final result =
          await _pantunService
              .getQuestions(
        pantun.id,
      );

      questions.assignAll(
        result,
      );

      currentIndex.value =
          0;

      correctCount.value =
          0;

      wrongCount.value =
          0;

      answerHistory.clear();

      resultSaved.value =
          false;

      progressSaved.value =
          false;

      nlpResult.value =
          null;

      _prepareCurrentQuestion();
    } catch (e) {
      errorMessage.value =
          'Gagal mengambil soal latihan.';

      debugPrint(
        'ERROR LOAD QUESTIONS: $e',
      );
    } finally {
      isLoading.value =
          false;
    }
  }

  // ============================================================
  // SIAPKAN SOAL
  // ============================================================

  void _prepareCurrentQuestion() {
    selectedAnswer.value =
        '';

    isAnswered.value =
        false;

    isCorrect.value =
        false;

    nlpResult.value =
        null;

    final question =
        currentQuestion;

    if (question == null) {
      displayedOptions.clear();

      return;
    }

    final options =
        List<String>.from(
      question.options,
    );

    options.shuffle();

    displayedOptions.assignAll(
      options,
    );
  }

  // ============================================================
  // PILIH JAWABAN
  // ============================================================

  void selectAnswer(
    String answer,
  ) {
    if (isAnswered.value ||
        isChecking.value) {
      return;
    }

    selectedAnswer.value =
        answer;
  }

  // ============================================================
  // ANALISIS NLP
  // ============================================================

  Future<void> checkAnswer() async {
    if (selectedAnswer
        .value
        .isEmpty) {
      Get.snackbar(
        'Pilih jawaban',
        'Silakan pilih salah satu '
            'jawaban terlebih dahulu.',
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return;
    }

    if (isAnswered.value ||
        isChecking.value) {
      return;
    }

    final question =
        currentQuestion;

    if (question == null) {
      return;
    }

    try {
      isChecking.value =
          true;

      // ========================================================
      // KIRIM KE NLP BACKEND
      // ========================================================

      final result =
          await _nlpService
              .analyzeAnswer(
        template:
            question.template,

        userAnswer:
            selectedAnswer.value,

        referenceAnswer:
            question.referenceAnswer,

        targetRhyme:
            question.targetRhyme,
      );

      // ========================================================
      // SIMPAN HASIL NLP
      // ========================================================

      nlpResult.value =
          result;

      isCorrect.value =
          result.isCorrect;

      isAnswered.value =
          true;

      // ========================================================
      // HITUNG BENAR / SALAH
      // ========================================================

      if (result.isCorrect) {
        correctCount.value++;
      } else {
        wrongCount.value++;
      }

      // ========================================================
      // SIMPAN DETAIL JAWABAN
      // ========================================================

      answerHistory.add(
        AnswerHistoryModel(
          questionId:
              question.id,

          lineIndex:
              question.lineIndex,

          selectedAnswer:
              selectedAnswer.value,

          referenceAnswer:
              question.referenceAnswer,

          semanticScore:
              result.semanticScore,

          contextScore:
              result.contextScore,

          rhymeScore:
              result.rhymeScore,

          finalScore:
              result.finalScore,

          isCorrect:
              result.isCorrect,

          explanation:
              result.explanation,
        ),
      );

      // ========================================================
      // DEBUG
      // ========================================================

      debugPrint(
        '==============================',
      );

      debugPrint(
        'HASIL ANALISIS NLP',
      );

      debugPrint(
        'Question ID : '
        '${question.id}',
      );

      debugPrint(
        'Jawaban User: '
        '${selectedAnswer.value}',
      );

      debugPrint(
        'Referensi   : '
        '${question.referenceAnswer}',
      );

      debugPrint(
        'Makna       : '
        '${result.semanticScore}',
      );

      debugPrint(
        'Konteks     : '
        '${result.contextScore}',
      );

      debugPrint(
        'Rima        : '
        '${result.rhymeScore}',
      );

      debugPrint(
        'Final NLP   : '
        '${result.finalScore}',
      );

      debugPrint(
        'Benar       : '
        '${result.isCorrect}',
      );

      debugPrint(
        '==============================',
      );
    } catch (e) {
      debugPrint(
        'ERROR CHECK ANSWER NLP: $e',
      );

      Get.snackbar(
        'NLP tidak dapat diakses',
        'Pastikan server NLP sedang berjalan '
            'dan alamat API sudah benar.',
        snackPosition:
            SnackPosition.BOTTOM,
      );
    } finally {
      isChecking.value =
          false;
    }
  }

  // ============================================================
  // SOAL BERIKUTNYA
  // ============================================================

  Future<void> nextQuestion() async {
    if (!isAnswered.value) {
      Get.snackbar(
        'Periksa jawaban',
        'Periksa jawaban terlebih dahulu.',
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return;
    }

    if (isLastQuestion) {
      await finishQuiz();

      return;
    }

    currentIndex.value++;

    _prepareCurrentQuestion();
  }

  // ============================================================
  // SELESAIKAN LATIHAN
  // ============================================================

  Future<void> finishQuiz() async {
    if (isSavingResult.value) {
      return;
    }

    try {
      isSavingResult.value =
          true;

      // ========================================================
      // 1. SIMPAN HISTORY
      // ========================================================

      if (!resultSaved.value) {
        final history =
            LatihanHistoryModel(
          pantunId:
              pantun.id,

          pantunTitle:
              pantun.judul,

          kategori:
              category.nama,

          totalQuestions:
              questions.length,

          correctCount:
              correctCount.value,

          wrongCount:
              wrongCount.value,

          score:
              score,

          answers:
              List<
                  AnswerHistoryModel>.from(
            answerHistory,
          ),
        );

        await _historyService
            .saveHistory(
          history,
        );

        resultSaved.value =
            true;

        debugPrint(
          'History berhasil disimpan.',
        );
      }

      // ========================================================
      // 2. UPDATE PROGRESS
      // ========================================================

      if (!progressSaved.value) {
        await _progressService
            .updatePantunProgress(
          categoryId:
              category.id,

          categoryOrder:
              category.order,

          totalPantun:
              category.totalPantun,

          pantunId:
              pantun.id,

          score:
              score,
        );

        progressSaved.value =
            true;

        debugPrint(
          'Progress Firestore '
          'berhasil diperbarui.',
        );

        // ======================================================
        // 3. REFRESH KATEGORI
        // ======================================================

        await _refreshKategori();

        debugPrint(
          'Progress pantun '
          'berhasil diperbarui.',
        );

        debugPrint(
          'Kategori : '
          '${category.id}',
        );

        debugPrint(
          'Pantun   : '
          '${pantun.id}',
        );

        debugPrint(
          'Nilai    : $score',
        );

        debugPrint(
          'Lulus    : $isPassed',
        );
      }

      // ========================================================
      // 4. TAMPILKAN HASIL
      // ========================================================

      showResult();
    } catch (e) {
      debugPrint(
        'ERROR FINISH QUIZ: $e',
      );

      Get.snackbar(
        'Penyimpanan bermasalah',
        'Hasil latihan dapat dilihat, '
            'tetapi sebagian data mungkin '
            'belum tersimpan.',
        snackPosition:
            SnackPosition.BOTTOM,
      );

      showResult();
    } finally {
      isSavingResult.value =
          false;
    }
  }

  // ============================================================
  // REFRESH KATEGORI
  // ============================================================

  Future<void> _refreshKategori() async {
    try {
      if (Get.isRegistered<
          KategoriController>()) {
        final kategoriController =
            Get.find<
                KategoriController>();

        await kategoriController
            .loadData();

        debugPrint(
          'KategoriController '
          'berhasil di-refresh.',
        );

        debugPrint(
          'Kategori terbuka sampai: '
          '${kategoriController.highestUnlockedCategory.value}',
        );
      } else {
        debugPrint(
          'KategoriController '
          'tidak sedang aktif.',
        );
      }
    } catch (e) {
      debugPrint(
        'ERROR REFRESH KATEGORI: $e',
      );
    }
  }

  // ============================================================
  // TAMPILKAN HASIL
  // ============================================================

  void showResult() {
    final double accuracy =
        questions.isEmpty
            ? 0
            : correctCount.value /
                questions.length *
                100;

    final Color scoreColor =
        _getScoreColor(
      score,
    );

    Get.dialog(
      Dialog(
        backgroundColor:
            Colors.transparent,

        insetPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),

        child: Container(
          constraints: BoxConstraints(
            maxWidth: 520,

            maxHeight:
                Get.height *
                0.90,
          ),

          decoration: BoxDecoration(
            color: const Color(
              0xFFFCFEFF,
            ),

            borderRadius:
                BorderRadius.circular(
              30,
            ),

            boxShadow: [
              BoxShadow(
                color:
                    Colors.black
                        .withOpacity(
                  0.18,
                ),

                blurRadius: 35,

                offset: const Offset(
                  0,
                  15,
                ),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(
              30,
            ),

            child:
                SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),

              padding:
                  const EdgeInsets.fromLTRB(
                18,
                18,
                18,
                20,
              ),

              child: Column(
                mainAxisSize:
                    MainAxisSize.min,

                children: [
                  // =============================================
                  // HEADER
                  // =============================================

                  _buildResultHeader(),

                  const SizedBox(
                    height: 16,
                  ),

                  // =============================================
                  // SCORE
                  // =============================================

                  _buildScoreCard(
                    accuracy:
                        accuracy,

                    scoreColor:
                        scoreColor,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // =============================================
                  // STATUS
                  // =============================================

                  _buildPassedCard(),

                  // =============================================
                  // SAVED INFORMATION
                  // =============================================

                  if (resultSaved.value ||
                      progressSaved.value) ...[
                    const SizedBox(
                      height: 12,
                    ),

                    _buildSavedInformation(),
                  ],

                  const SizedBox(
                    height: 12,
                  ),

                  // =============================================
                  // QUOTE
                  // =============================================

                  _buildResultQuote(),

                  const SizedBox(
                    height: 18,
                  ),

                  // =============================================
                  // BUTTON
                  // =============================================

                  _buildResultButtons(),
                ],
              ),
            ),
          ),
        ),
      ),

      barrierDismissible:
          false,
    );
  }

  // ============================================================
  // RESULT HEADER
  // ============================================================

  Widget _buildResultHeader() {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        14,
      ),

      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(
              0xFFE8FAFC,
            ),

            Color(
              0xFFF0FBF7,
            ),
          ],

          begin:
              Alignment.topLeft,

          end:
              Alignment.bottomRight,
        ),

        borderRadius:
            BorderRadius.circular(
          24,
        ),
      ),

      child: Row(
        children: [
          // ====================================================
          // TROPHY
          // ====================================================

          Container(
            width:
                78,

            height:
                78,

            decoration:
                const BoxDecoration(
              color:
                  Color(
                0xFFFFF3D2,
              ),

              shape:
                  BoxShape.circle,
            ),

            child: Stack(
              alignment:
                  Alignment.center,

              children: [
                const Icon(
                  Icons
                      .emoji_events_rounded,

                  color:
                      warningColor,

                  size:
                      46,
                ),

                if (isPassed)
                  Positioned(
                    right:
                        2,

                    top:
                        3,

                    child:
                        Container(
                      width:
                          25,

                      height:
                          25,

                      decoration:
                          const BoxDecoration(
                        color:
                            successColor,

                        shape:
                            BoxShape.circle,
                      ),

                      child:
                          const Icon(
                        Icons
                            .check_rounded,

                        color:
                            Colors.white,

                        size:
                            16,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(
            width: 13,
          ),

          // ====================================================
          // TITLE
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFDDF5F1,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Text(
                    isPassed
                        ? 'Hebat! 🎉'
                        : 'Tetap Semangat! 💪',

                    style:
                        GoogleFonts.poppins(
                      color:
                          primaryColor,

                      fontSize:
                          9,

                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  'Latihan Selesai!',

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

                const SizedBox(
                  height: 3,
                ),

                Text(
                  pantun.judul,

                  maxLines:
                      2,

                  overflow:
                      TextOverflow.ellipsis,

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
    );
  }

  // ============================================================
  // SCORE CARD
  // ============================================================

  Widget _buildScoreCard({
    required double accuracy,
    required Color scoreColor,
  }) {
    return Container(
      width:
          double.infinity,

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
          23,
        ),

        border:
            Border.all(
          color:
              const Color(
            0xFFE9F0F2,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              0.035,
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
          // ====================================================
          // HEADER
          // ====================================================

          Row(
            children: [
              Expanded(
                child: Text(
                  'Hasil Latihan',

                  style:
                      GoogleFonts.poppins(
                    color:
                        darkColor,

                    fontSize:
                        14,

                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      9,

                  vertical:
                      5,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      scoreColor
                          .withOpacity(
                    0.12,
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
                    Icon(
                      Icons.star_rounded,

                      color:
                          scoreColor,

                      size:
                          15,
                    ),

                    const SizedBox(
                      width: 3,
                    ),

                    Text(
                      _getScoreLabel(
                        score,
                      ),

                      style:
                          GoogleFonts.poppins(
                        color:
                            scoreColor,

                        fontSize:
                            8,

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

          // ====================================================
          // SCORE & STAT
          // ====================================================

          Row(
            children: [
              // =================================================
              // CIRCLE SCORE
              // =================================================

              SizedBox(
                width:
                    105,

                height:
                    105,

                child: Stack(
                  alignment:
                      Alignment.center,

                  children: [
                    SizedBox(
                      width:
                          98,

                      height:
                          98,

                      child:
                          CircularProgressIndicator(
                        value:
                            (score / 100)
                                .clamp(
                                  0.0,
                                  1.0,
                                )
                                .toDouble(),

                        strokeWidth:
                            9,

                        backgroundColor:
                            const Color(
                          0xFFE1ECEB,
                        ),

                        valueColor:
                            AlwaysStoppedAnimation<
                                Color>(
                          scoreColor,
                        ),
                      ),
                    ),

                    Column(
                      mainAxisSize:
                          MainAxisSize.min,

                      children: [
                        Text(
                          score
                              .toStringAsFixed(
                            0,
                          ),

                          style:
                              GoogleFonts.poppins(
                            color:
                                darkColor,

                            fontSize:
                                27,

                            height:
                                1,

                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),

                        Text(
                          '/100',

                          style:
                              GoogleFonts.poppins(
                            color:
                                secondaryText,

                            fontSize:
                                9,

                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              // =================================================
              // STAT
              // =================================================

              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child:
                          _buildResultStat(
                        icon:
                            Icons
                                .quiz_rounded,

                        value:
                            '${questions.length}',

                        label:
                            'Soal',

                        color:
                            blueColor,

                        background:
                            const Color(
                          0xFFE9F5FC,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 5,
                    ),

                    Expanded(
                      child:
                          _buildResultStat(
                        icon:
                            Icons
                                .check_circle_rounded,

                        value:
                            '${correctCount.value}',

                        label:
                            'Benar',

                        color:
                            successColor,

                        background:
                            const Color(
                          0xFFEAF8EE,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 5,
                    ),

                    Expanded(
                      child:
                          _buildResultStat(
                        icon:
                            Icons
                                .cancel_rounded,

                        value:
                            '${wrongCount.value}',

                        label:
                            'Salah',

                        color:
                            errorColor,

                        background:
                            const Color(
                          0xFFFFECEE,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 15,
          ),

          // ====================================================
          // ACCURACY
          // ====================================================

          Row(
            children: [
              const Icon(
                Icons
                    .track_changes_rounded,

                color:
                    primaryColor,

                size:
                    18,
              ),

              const SizedBox(
                width: 6,
              ),

              Text(
                'Akurasi Jawaban',

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
                      FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 7,
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
      padding:
          const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 3,
      ),

      decoration:
          BoxDecoration(
        color:
            background,

        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),

      child: Column(
        children: [
          Icon(
            icon,
            color:
                color,
            size:
                18,
          ),

          const SizedBox(
            height: 2,
          ),

          Text(
            value,

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

          Text(
            label,

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
  // STATUS LULUS
  // ============================================================

  Widget _buildPassedCard() {
    final Color color =
        isPassed
            ? successColor
            : warningColor;

    final Color background =
        isPassed
            ? const Color(
                0xFFEAF9EF,
              )
            : const Color(
                0xFFFFF5DF,
              );

    return Container(
      width:
          double.infinity,

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

      child: Row(
        children: [
          Container(
            width:
                50,

            height:
                50,

            decoration:
                BoxDecoration(
              color:
                  Colors.white
                      .withOpacity(
                0.80,
              ),

              shape:
                  BoxShape.circle,
            ),

            child: Icon(
              isPassed
                  ? Icons
                      .emoji_events_rounded
                  : Icons
                      .lightbulb_rounded,

              color:
                  color,

              size:
                  28,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  isPassed
                      ? 'Selamat! Kamu Lulus!'
                      : 'Belum Lulus, Coba Lagi!',

                  style:
                      GoogleFonts.poppins(
                    color:
                        isPassed
                            ? const Color(
                                0xFF24834B,
                              )
                            : const Color(
                                0xFFB47718,
                              ),

                    fontSize:
                        13,

                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  isPassed
                      ? category.totalPantun == 1
                          ? 'Pantun ini telah diselesaikan. '
                              'Kategori berikutnya akan terbuka '
                              'jika seluruh syarat terpenuhi.'
                          : 'Pantun ini telah diselesaikan. '
                              'Lanjutkan pantun berikutnya '
                              'untuk menyelesaikan kategori.'
                      : 'Nilai minimal kelulusan adalah '
                          '${ProgressService.passingScore.toStringAsFixed(0)}. '
                          'Pelajari kembali pantunnya lalu coba lagi.',

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
      ),
    );
  }

  // ============================================================
  // SAVED INFORMATION
  // ============================================================

  Widget _buildSavedInformation() {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.symmetric(
        horizontal:
            13,

        vertical:
            12,
      ),

      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFF1F9F8,
        ),

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border:
            Border.all(
          color:
              const Color(
            0xFFDCEFEB,
          ),
        ),
      ),

      child: Column(
        children: [
          if (resultSaved.value)
            _buildSavedRow(
              icon:
                  Icons.history_rounded,

              text:
                  'Riwayat latihan berhasil disimpan.',
            ),

          if (resultSaved.value &&
              progressSaved.value)
            const SizedBox(
              height: 8,
            ),

          if (progressSaved.value)
            _buildSavedRow(
              icon:
                  Icons
                      .trending_up_rounded,

              text:
                  'Progres belajar berhasil diperbarui.',
            ),
        ],
      ),
    );
  }

  // ============================================================
  // SAVED ROW
  // ============================================================

  Widget _buildSavedRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          width:
              27,

          height:
              27,

          decoration:
              const BoxDecoration(
            color:
                Color(
              0xFFDDF5EE,
            ),

            shape:
                BoxShape.circle,
          ),

          child: Icon(
            icon,

            color:
                successColor,

            size:
                15,
          ),
        ),

        const SizedBox(
          width: 8,
        ),

        Expanded(
          child: Text(
            text,

            style:
                GoogleFonts.poppins(
              color:
                  const Color(
                0xFF4D6D67,
              ),

              fontSize:
                  9,

              fontWeight:
                  FontWeight.w500,
            ),
          ),
        ),

        const Icon(
          Icons.check_circle_rounded,

          color:
              successColor,

          size:
              17,
        ),
      ],
    );
  }

  // ============================================================
  // RESULT QUOTE
  // ============================================================

  Widget _buildResultQuote() {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        13,
      ),

      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(
              0xFFE9F7FC,
            ),

            Color(
              0xFFF0FAF8,
            ),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Icon(
            Icons
                .format_quote_rounded,

            color:
                Color(
              0xFF7695B1,
            ),

            size:
                27,
          ),

          const SizedBox(
            width: 8,
          ),

          Expanded(
            child: Text(
              isPassed
                  ? 'Hebat! Terus belajar pantun Serawai '
                      'dan ikut melestarikan bahasa untuk '
                      'generasi berikutnya.'
                  : 'Jangan menyerah. Setiap kesalahan '
                      'adalah bagian dari proses belajar.',

              style:
                  GoogleFonts.poppins(
                color:
                    const Color(
                  0xFF57718A,
                ),

                fontSize:
                    9,

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
  // RESULT BUTTONS
  // ============================================================

  Widget _buildResultButtons() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,

      children: [
        // ======================================================
        // KE KATEGORI
        // ======================================================

        SizedBox(
          height:
              52,

          child:
              ElevatedButton(
            onPressed:
                backToCategory,

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
                  16,
                ),
              ),
            ),

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                const Icon(
                  Icons.category_rounded,

                  size:
                      20,
                ),

                const SizedBox(
                  width: 8,
                ),

                Text(
                  'Ke Kategori',

                  style:
                      GoogleFonts.poppins(
                    fontSize:
                        12,

                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  width: 7,
                ),

                const Icon(
                  Icons
                      .arrow_forward_rounded,

                  size:
                      18,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(
          height: 9,
        ),

        Row(
          children: [
            // ==================================================
            // ULANGI
            // ==================================================

            Expanded(
              child: SizedBox(
                height:
                    48,

                child:
                    OutlinedButton(
                  onPressed: () {
                    Get.back();

                    restartQuiz();
                  },

                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        primaryColor,

                    side:
                        const BorderSide(
                      color:
                          primaryColor,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      const Icon(
                        Icons.refresh_rounded,

                        size:
                            18,
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      Text(
                        'Ulangi',

                        style:
                            GoogleFonts.poppins(
                          fontSize:
                              10,

                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            // ==================================================
            // TERJEMAHAN
            // ==================================================

            Expanded(
              child: SizedBox(
                height:
                    48,

                child:
                    OutlinedButton(
                  onPressed: () {
                    Get.back();

                    Get.offNamed(
                      Routes.materi,

                      arguments:
                          pantun,
                    );
                  },

                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(
                      0xFF4E83AE,
                    ),

                    backgroundColor:
                        const Color(
                      0xFFF0F7FC,
                    ),

                    side:
                        const BorderSide(
                      color:
                          Color(
                        0xFFBFD8EA,
                      ),
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      const Icon(
                        Icons.menu_book_rounded,

                        size:
                            18,
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      Flexible(
                        child: Text(
                          'Terjemahan',

                          maxLines:
                              1,

                          overflow:
                              TextOverflow.ellipsis,

                          style:
                              GoogleFonts.poppins(
                            fontSize:
                                10,

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
          ],
        ),
      ],
    );
  }

  // ============================================================
  // SCORE COLOR
  // ============================================================

  Color _getScoreColor(
    double value,
  ) {
    if (value >= 80) {
      return successColor;
    }

    if (value >= 60) {
      return warningColor;
    }

    return errorColor;
  }

  // ============================================================
  // SCORE LABEL
  // ============================================================

  String _getScoreLabel(
    double value,
  ) {
    if (value >= 90) {
      return 'Sangat Baik';
    }

    if (value >= 80) {
      return 'Baik';
    }

    if (value >= 60) {
      return 'Cukup';
    }

    return 'Perlu Belajar';
  }

  // ============================================================
  // KEMBALI KE HALAMAN KATEGORI
  // ============================================================

  Future<void> backToCategory() async {
    // Tutup dialog
    Get.back();

    // Kembali sampai halaman kategori
    Get.until(
      (route) =>
          route.settings.name ==
          Routes.kategori,
    );

    // Refresh data kategori
    if (Get.isRegistered<
        KategoriController>()) {
      final kategoriController =
          Get.find<
              KategoriController>();

      await kategoriController
          .loadData();

      debugPrint(
        'Kembali ke kategori.',
      );

      debugPrint(
        'Kategori terbuka sampai: '
        '${kategoriController.highestUnlockedCategory.value}',
      );
    }
  }

  // ============================================================
  // ULANGI LATIHAN
  // ============================================================

  void restartQuiz() {
    currentIndex.value =
        0;

    correctCount.value =
        0;

    wrongCount.value =
        0;

    answerHistory.clear();

    resultSaved.value =
        false;

    progressSaved.value =
        false;

    selectedAnswer.value =
        '';

    isAnswered.value =
        false;

    isCorrect.value =
        false;

    nlpResult.value =
        null;

    _prepareCurrentQuestion();
  }
}