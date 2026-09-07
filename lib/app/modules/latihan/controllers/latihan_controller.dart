import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  // =====================================
  // SERVICES
  // =====================================

  final PantunService _pantunService =
      Get.find<PantunService>();

  final HistoryService _historyService =
      Get.find<HistoryService>();

  final NlpService _nlpService =
      Get.find<NlpService>();

  final ProgressService _progressService =
      Get.find<ProgressService>();

  // =====================================
  // DATA UTAMA
  // =====================================

  late final PantunModel pantun;

  late final CategoryModel category;

  // =====================================
  // STATE SOAL
  // =====================================

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

  // =====================================
  // STATE HASIL
  // =====================================

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

  // =====================================
  // NLP
  // =====================================

  final nlpResult =
      Rxn<NlpResultModel>();

  // =====================================
  // HISTORY JAWABAN
  // =====================================

  final answerHistory =
      <AnswerHistoryModel>[].obs;

  // =====================================
  // GETTERS
  // =====================================

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

  // =====================================
  // INIT
  // =====================================

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

  // =====================================
  // LOAD QUESTIONS
  // =====================================

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

  // =====================================
  // SIAPKAN SOAL
  // =====================================

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

  // =====================================
  // PILIH JAWABAN
  // =====================================

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

  // =====================================
  // ANALISIS NLP
  // =====================================

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

      // =================================
      // KIRIM KE NLP BACKEND
      // =================================

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

      // =================================
      // SIMPAN HASIL NLP
      // =================================

      nlpResult.value =
          result;

      isCorrect.value =
          result.isCorrect;

      isAnswered.value =
          true;

      // =================================
      // HITUNG BENAR / SALAH
      // =================================

      if (result.isCorrect) {
        correctCount.value++;
      } else {
        wrongCount.value++;
      }

      // =================================
      // SIMPAN DETAIL JAWABAN
      // =================================

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

      // =================================
      // DEBUG
      // =================================

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

  // =====================================
  // SOAL BERIKUTNYA
  // =====================================

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

  // =====================================
  // SELESAIKAN LATIHAN
  // =====================================

  Future<void> finishQuiz() async {
    if (isSavingResult.value) {
      return;
    }

    try {
      isSavingResult.value =
          true;

      // =================================
      // 1. SIMPAN HISTORY
      // =================================

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
              List<AnswerHistoryModel>.from(
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

      // =================================
      // 2. UPDATE PROGRESS
      // =================================

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

        // =================================
        // 3. REFRESH KATEGORI
        // =================================

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

      // =================================
      // 4. TAMPILKAN HASIL
      // =================================

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

  // =====================================
  // REFRESH KATEGORI
  // =====================================

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

  // =====================================
  // TAMPILKAN HASIL
  // =====================================

  void showResult() {
    Get.dialog(
      AlertDialog(
        title:
            const Text(
          'Latihan Selesai',
        ),

        content: SingleChildScrollView(
          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Text(
                pantun.judul,

                textAlign:
                    TextAlign.center,

                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              Text(
                'Total Soal: '
                '${questions.length}',
              ),

              Text(
                'Benar: '
                '${correctCount.value}',
              ),

              Text(
                'Salah: '
                '${wrongCount.value}',
              ),

              const SizedBox(
                height: 16,
              ),

              Text(
                'Nilai: '
                '${score.toStringAsFixed(0)}',

                style:
                    const TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // ===========================
              // STATUS LULUS
              // ===========================

              if (isPassed)
                const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.check_circle,
                    ),

                    SizedBox(
                      width: 7,
                    ),

                    Text(
                      'LULUS',

                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                )
              else
                const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.info_outline,
                    ),

                    SizedBox(
                      width: 7,
                    ),

                    Text(
                      'BELUM LULUS',

                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),

              const SizedBox(
                height: 10,
              ),

              Text(
                isPassed
                    ? 'Pantun ini telah '
                        'diselesaikan.'
                    : 'Nilai minimal kelulusan '
                        '${ProgressService.passingScore.toStringAsFixed(0)}. '
                        'Silakan coba lagi.',

                textAlign:
                    TextAlign.center,
              ),

              if (isPassed) ...[
                const SizedBox(
                  height: 8,
                ),

                Text(
                  category.totalPantun == 1
                      ? 'Jika seluruh pantun '
                          'dalam kategori telah selesai, '
                          'kategori berikutnya akan terbuka.'
                      : 'Lanjutkan pantun berikutnya '
                          'untuk menyelesaikan kategori.',

                  textAlign:
                      TextAlign.center,
                ),
              ],

              if (resultSaved.value) ...[
                const SizedBox(
                  height: 12,
                ),

                const Text(
                  'Riwayat latihan '
                  'telah tersimpan.',

                  textAlign:
                      TextAlign.center,
                ),
              ],

              if (progressSaved.value) ...[
                const SizedBox(
                  height: 5,
                ),

                const Text(
                  'Progres belajar '
                  'telah diperbarui.',

                  textAlign:
                      TextAlign.center,
                ),
              ],
            ],
          ),
        ),

        actions: [
          // ===============================
          // ULANGI
          // ===============================

          TextButton(
            onPressed: () {
              Get.back();

              restartQuiz();
            },

            child:
                const Text(
              'Ulangi',
            ),
          ),

          // ===============================
          // LIHAT TERJEMAHAN / MATERI
          // ===============================

          TextButton(
            onPressed: () {
              Get.back();

              Get.offNamed(
                Routes.materi,
                arguments: pantun,
              );
            },

            child:
                const Text(
              'Lihat Terjemahan',
            ),
          ),

          // ===============================
          // KEMBALI KE KATEGORI
          // ===============================

          ElevatedButton(
            onPressed:
                backToCategory,

            child:
                const Text(
              'Kategori',
            ),
          ),
        ],
      ),

      barrierDismissible:
          false,
    );
  }

  // =====================================
  // KEMBALI KE HALAMAN KATEGORI
  // =====================================

  Future<void> backToCategory() async {
    // Tutup dialog hasil
    Get.back();

    // Kembali sampai halaman kategori
    Get.until(
      (route) =>
          route.settings.name ==
          Routes.kategori,
    );

    // Baca ulang data Firestore
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

  // =====================================
  // ULANGI LATIHAN
  // =====================================

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