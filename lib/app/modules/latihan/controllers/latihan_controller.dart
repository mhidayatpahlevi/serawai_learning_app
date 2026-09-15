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

// ============================================================
// TIPE LATIHAN
// ============================================================

enum LatihanInputType {
  pilihan,
  ketik,
}

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

  // Digunakan oleh pilihan dan ketikan
  final selectedAnswer =
      ''.obs;

  // Pilihan jawaban
  final displayedOptions =
      <String>[].obs;

  // ============================================================
  // INPUT KETIK
  // ============================================================

  final typedAnswer =
      ''.obs;

  final answerTextController =
      TextEditingController();

  // ============================================================
  // STATE
  // ============================================================

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
  // GETTER SOAL
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

  // ============================================================
  // SCORE
  // ============================================================

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
  // LEVEL NUMBER
  // ============================================================

  int get levelNumber {
    final String value =
        pantun.level
            .toString()
            .toLowerCase()
            .trim();

    // =========================================
    // Ambil angka dari:
    // "1"
    // "Level 1"
    // "level_15"
    // "Tingkat 25"
    // =========================================

    final match =
        RegExp(
      r'\d+',
    ).firstMatch(
      value,
    );

    if (match != null) {
      final int? number =
          int.tryParse(
        match.group(0) ?? '',
      );

      if (number != null) {
        return number
            .clamp(
              1,
              30,
            )
            .toInt();
      }
    }

    // =========================================
    // FALLBACK JIKA MASIH MENGGUNAKAN TEKS
    // =========================================

    if (value.contains('menengah') ||
        value.contains('sedang')) {
      return 11;
    }

    if (value.contains('mahir') ||
        value.contains('sulit') ||
        value.contains('lanjut')) {
      return 21;
    }

    return 1;
  }

  // ============================================================
  // TIPE LATIHAN
  // ============================================================

  LatihanInputType get inputType {
    final int level =
        levelNumber;

    // =========================================
    // LEVEL 1 - 10
    // PILIHAN
    // =========================================

    if (level <= 10) {
      return LatihanInputType.pilihan;
    }

    // =========================================
    // LEVEL 11 - 20
    // KETIK
    // =========================================

    if (level <= 20) {
      return LatihanInputType.ketik;
    }

    // =========================================
    // LEVEL 21 - 30
    // CAMPURAN
    //
    // Soal 1 = Ketik
    // Soal 2 = Pilihan
    // Soal 3 = Ketik
    // Soal 4 = Pilihan
    // =========================================

    if (currentNumber.isOdd) {
      return LatihanInputType.ketik;
    }

    return LatihanInputType.pilihan;
  }

  bool get isPilihanMode {
    return inputType ==
        LatihanInputType.pilihan;
  }

  bool get isKetikMode {
    return inputType ==
        LatihanInputType.ketik;
  }

  bool get isMixedLevel {
    return levelNumber >= 21 &&
        levelNumber <= 30;
  }

  String get inputModeLabel {
    if (levelNumber <= 10) {
      return 'Pilihan';
    }

    if (levelNumber <= 20) {
      return 'Ketik Jawaban';
    }

    if (isKetikMode) {
      return 'Campuran • Ketik';
    }

    return 'Campuran • Pilihan';
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

      selectedAnswer.value =
          '';

      typedAnswer.value =
          '';

      answerTextController.clear();

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

    typedAnswer.value =
        '';

    answerTextController.clear();

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

    debugPrint(
      '==============================',
    );

    debugPrint(
      'LEVEL: $levelNumber',
    );

    debugPrint(
      'SOAL: $currentNumber',
    );

    debugPrint(
      'MODE: $inputModeLabel',
    );

    debugPrint(
      '==============================',
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
  // INPUT KETIK
  // ============================================================

  void updateTypedAnswer(
    String value,
  ) {
    if (isAnswered.value ||
        isChecking.value) {
      return;
    }

    typedAnswer.value =
        value;

    selectedAnswer.value =
        value.trim();
  }

  void clearTypedAnswer() {
    if (isAnswered.value ||
        isChecking.value) {
      return;
    }

    typedAnswer.value =
        '';

    selectedAnswer.value =
        '';

    answerTextController.clear();
  }

  // ============================================================
  // ANALISIS NLP
  // ============================================================

  Future<void> checkAnswer() async {
    if (selectedAnswer
        .value
        .trim()
        .isEmpty) {
      Get.snackbar(
        isKetikMode
            ? 'Tulis jawaban'
            : 'Pilih jawaban',

        isKetikMode
            ? 'Silakan tulis jawaban terlebih dahulu.'
            : 'Silakan pilih salah satu jawaban terlebih dahulu.',

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

      // =========================================
      // NLP
      // =========================================

      final result =
          await _nlpService
              .analyzeAnswer(
        template:
            question.template,

        userAnswer:
            selectedAnswer
                .value
                .trim(),

        referenceAnswer:
            question.referenceAnswer,

        targetRhyme:
            question.targetRhyme,
      );

      nlpResult.value =
          result;

      isCorrect.value =
          result.isCorrect;

      isAnswered.value =
          true;

      // =========================================
      // BENAR / SALAH
      // =========================================

      if (result.isCorrect) {
        correctCount.value++;
      } else {
        wrongCount.value++;
      }

      // =========================================
      // HISTORY
      // =========================================

      answerHistory.add(
        AnswerHistoryModel(
          questionId:
              question.id,

          lineIndex:
              question.lineIndex,

          selectedAnswer:
              selectedAnswer
                  .value
                  .trim(),

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

      // =========================================
      // DEBUG
      // =========================================

      debugPrint(
        '==============================',
      );

      debugPrint(
        'HASIL ANALISIS NLP',
      );

      debugPrint(
        'Level       : $levelNumber',
      );

      debugPrint(
        'Mode        : $inputModeLabel',
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

      // =========================================
      // SIMPAN HISTORY
      // =========================================

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

      // =========================================
      // UPDATE PROGRESS
      // =========================================

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

        await _refreshKategori();
      }

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
          'KategoriController berhasil di-refresh.',
        );
      }
    } catch (e) {
      debugPrint(
        'ERROR REFRESH KATEGORI: $e',
      );
    }
  }

  // ============================================================
  // RESULT
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

          decoration:
              BoxDecoration(
            color:
                const Color(
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

                blurRadius:
                    35,

                offset:
                    const Offset(
                  0,
                  15,
                ),
              ),
            ],
          ),

          child:
              SingleChildScrollView(
            padding:
                const EdgeInsets.all(
              18,
            ),

            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                // =============================================
                // HEADER
                // =============================================

                Container(
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
                          0xFFE8FAFC,
                        ),
                        Color(
                          0xFFF0FBF7,
                        ),
                      ],
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      22,
                    ),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width:
                            70,

                        height:
                            70,

                        decoration:
                            const BoxDecoration(
                          color:
                              Color(
                            0xFFFFF3D2,
                          ),

                          shape:
                              BoxShape.circle,
                        ),

                        child:
                            Icon(
                          isPassed
                              ? Icons
                                  .emoji_events_rounded
                              : Icons
                                  .lightbulb_rounded,

                          color:
                              isPassed
                                  ? warningColor
                                  : errorColor,

                          size:
                              40,
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
                              isPassed
                                  ? 'Hebat! 🎉'
                                  : 'Tetap Semangat! 💪',

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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                // =============================================
                // SCORE
                // =============================================

                Container(
                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets.all(
                    16,
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
                          const Color(
                        0xFFE8EFF1,
                      ),
                    ),
                  ),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child:
                                Text(
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

                          Text(
                            _getScoreLabel(
                              score,
                            ),

                            style:
                                GoogleFonts.poppins(
                              color:
                                  scoreColor,

                              fontWeight:
                                  FontWeight.w700,

                              fontSize:
                                  10,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Text(
                        score
                            .toStringAsFixed(
                          0,
                        ),

                        style:
                            GoogleFonts.poppins(
                          color:
                              scoreColor,

                          fontSize:
                              42,

                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),

                      Text(
                        'dari 100',

                        style:
                            GoogleFonts.poppins(
                          color:
                              secondaryText,

                          fontSize:
                              10,
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child:
                                _buildResultStat(
                              title:
                                  'Soal',

                              value:
                                  '${questions.length}',

                              color:
                                  blueColor,
                            ),
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          Expanded(
                            child:
                                _buildResultStat(
                              title:
                                  'Benar',

                              value:
                                  '${correctCount.value}',

                              color:
                                  successColor,
                            ),
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          Expanded(
                            child:
                                _buildResultStat(
                              title:
                                  'Salah',

                              value:
                                  '${wrongCount.value}',

                              color:
                                  errorColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      LinearProgressIndicator(
                        value:
                            (accuracy /
                                    100)
                                .clamp(
                                  0.0,
                                  1.0,
                                )
                                .toDouble(),

                        minHeight:
                            8,

                        color:
                            primaryColor,

                        backgroundColor:
                            const Color(
                          0xFFDCEBEA,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        'Akurasi ${accuracy.toStringAsFixed(0)}%',

                        style:
                            GoogleFonts.poppins(
                          fontSize:
                              9,

                          color:
                              secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                // =============================================
                // STATUS
                // =============================================

                Container(
                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets.all(
                    14,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        isPassed
                            ? const Color(
                                0xFFEAF9EF,
                              )
                            : const Color(
                                0xFFFFF5DF,
                              ),

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),

                  child: Row(
                    children: [
                      Icon(
                        isPassed
                            ? Icons
                                .check_circle_rounded
                            : Icons
                                .info_rounded,

                        color:
                            isPassed
                                ? successColor
                                : warningColor,

                        size:
                            35,
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
                              isPassed
                                  ? 'Selamat! Kamu Lulus!'
                                  : 'Belum Lulus',

                              style:
                                  GoogleFonts.poppins(
                                fontSize:
                                    13,

                                fontWeight:
                                    FontWeight.w700,

                                color:
                                    darkColor,
                              ),
                            ),

                            Text(
                              isPassed
                                  ? 'Pantun telah berhasil diselesaikan.'
                                  : 'Nilai minimal kelulusan '
                                      '${ProgressService.passingScore.toStringAsFixed(0)}.',

                              style:
                                  GoogleFonts.poppins(
                                fontSize:
                                    9,

                                color:
                                    secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                // =============================================
                // BUTTON
                // =============================================

                SizedBox(
                  width:
                      double.infinity,

                  height:
                      50,

                  child:
                      ElevatedButton.icon(
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
                          15,
                        ),
                      ),
                    ),

                    icon:
                        const Icon(
                      Icons
                          .category_rounded,
                    ),

                    label:
                        Text(
                      'Ke Kategori',

                      style:
                          GoogleFonts.poppins(
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Row(
                  children: [
                    Expanded(
                      child:
                          OutlinedButton.icon(
                        onPressed:
                            () {
                          Get.back();

                          restartQuiz();
                        },

                        icon:
                            const Icon(
                          Icons
                              .refresh_rounded,
                        ),

                        label:
                            const Text(
                          'Ulangi',
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Expanded(
                      child:
                          OutlinedButton.icon(
                        onPressed:
                            () {
                          Get.back();

                          Get.offNamed(
                            Routes.materi,

                            arguments:
                                pantun,
                          );
                        },

                        icon:
                            const Icon(
                          Icons
                              .menu_book_rounded,
                        ),

                        label:
                            const Text(
                          'Materi',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      barrierDismissible:
          false,
    );
  }

  // ============================================================
  // RESULT STAT
  // ============================================================

  Widget _buildResultStat({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical:
            10,
      ),

      decoration:
          BoxDecoration(
        color:
            color.withOpacity(
          0.10,
        ),

        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),

      child: Column(
        children: [
          Text(
            value,

            style:
                GoogleFonts.poppins(
              color:
                  color,

              fontSize:
                  22,

              fontWeight:
                  FontWeight.w800,
            ),
          ),

          Text(
            title,

            style:
                GoogleFonts.poppins(
              color:
                  color,

              fontSize:
                  10,

              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
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
  // BACK TO CATEGORY
  // ============================================================

  Future<void> backToCategory() async {
    Get.back();

    Get.until(
      (route) =>
          route.settings.name ==
          Routes.kategori,
    );

    if (Get.isRegistered<
        KategoriController>()) {
      final kategoriController =
          Get.find<
              KategoriController>();

      await kategoriController
          .loadData();
    }
  }

  // ============================================================
  // RESTART
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

    typedAnswer.value =
        '';

    answerTextController.clear();

    isAnswered.value =
        false;

    isCorrect.value =
        false;

    nlpResult.value =
        null;

    _prepareCurrentQuestion();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    answerTextController.dispose();

    super.onClose();
  }
}