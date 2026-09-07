import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/latihan_controller.dart';

class LatihanView
    extends GetView<LatihanController> {
  const LatihanView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          'Latihan Pantun',
        ),
        centerTitle: true,
      ),

      body: Obx(
        () {
          // =================================
          // LOADING
          // =================================

          if (controller
              .isLoading.value) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          // =================================
          // ERROR
          // =================================

          if (controller
              .errorMessage
              .value
              .isNotEmpty) {
            return _buildError();
          }

          // =================================
          // SOAL KOSONG
          // =================================

          if (controller
              .questions
              .isEmpty) {
            return _buildEmpty();
          }

          final question =
              controller.currentQuestion;

          if (question == null) {
            return _buildEmpty();
          }

          return SingleChildScrollView(
            padding:
                const EdgeInsets.all(
              20,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch,

              children: [
                // =========================
                // PROGRESS
                // =========================

                _buildProgress(),

                const SizedBox(
                  height: 24,
                ),

                // =========================
                // JUDUL PANTUN
                // =========================

                Text(
                  controller
                      .pantun
                      .judul,

                  style:
                      const TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  'Kategori: '
                  '${controller.pantun.kategori}',
                ),

                const SizedBox(
                  height: 24,
                ),

                // =========================
                // PETUNJUK
                // =========================

                const Text(
                  'Lengkapi pantun berikut '
                  'dengan kata yang paling tepat.',

                  style:
                      TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                // =========================
                // PANTUN RUMPANG
                // =========================

                _buildPantunCard(),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'Pilih Jawaban',

                  style:
                      TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                // =========================
                // PILIHAN
                // =========================

                ...controller
                    .displayedOptions
                    .map(
                  (option) =>
                      _buildOption(
                    option,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // =========================
                // FEEDBACK NLP
                // =========================

                if (controller
                    .isAnswered.value)
                  _buildFeedback(),

                if (controller
                    .isAnswered.value)
                  const SizedBox(
                    height: 20,
                  ),

                // =========================
                // BUTTON
                // =========================

                _buildButton(),

                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // =====================================
  // PROGRESS
  // =====================================

  Widget _buildProgress() {
    final progress =
        controller.totalQuestions == 0
            ? 0.0
            : controller.currentNumber /
                controller.totalQuestions;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,

      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
          children: [
            Text(
              'Soal '
              '${controller.currentNumber} '
              'dari '
              '${controller.totalQuestions}',

              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            Text(
              '${(progress * 100).round()}%',
            ),
          ],
        ),

        const SizedBox(
          height: 8,
        ),

        LinearProgressIndicator(
          value: progress,
        ),
      ],
    );
  }

  // =====================================
  // PANTUN RUMPANG
  // =====================================

  Widget _buildPantunCard() {
    final question =
        controller.currentQuestion;

    if (question == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .stretch,

          children: [
            const Icon(
              Icons.auto_stories,
              size: 45,
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              question.template,

              textAlign:
                  TextAlign.center,

              style:
                  const TextStyle(
                fontSize: 18,
                height: 1.7,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================
  // PILIHAN JAWABAN
  // =====================================

  Widget _buildOption(
    String option,
  ) {
    final selected =
        controller
            .selectedAnswer
            .value ==
        option;

    final answered =
        controller
            .isAnswered
            .value;

    final question =
        controller.currentQuestion;

    final referenceOption =
        question != null &&
        option
                .trim()
                .toLowerCase() ==
            question
                .referenceAnswer
                .trim()
                .toLowerCase();

    IconData icon =
        Icons.radio_button_unchecked;

    if (!answered && selected) {
      icon =
          Icons.radio_button_checked;
    }

    // Jawaban pilihan user diterima NLP
    if (answered &&
        selected &&
        controller
            .isCorrect.value) {
      icon = Icons.check_circle;
    }

    // Jawaban pilihan user ditolak NLP
    if (answered &&
        selected &&
        !controller
            .isCorrect.value) {
      icon = Icons.cancel;
    }

    // Jika salah, tampilkan juga
    // jawaban referensi
    if (answered &&
        !controller
            .isCorrect.value &&
        referenceOption &&
        !selected) {
      icon =
          Icons.check_circle_outline;
    }

    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),

      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          12,
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

        child: Padding(
          padding:
              const EdgeInsets.all(
            16,
          ),

          child: Row(
            children: [
              Icon(
                icon,
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Text(
                  option,

                  style:
                      const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================
  // FEEDBACK NLP
  // =====================================

  Widget _buildFeedback() {
    final question =
        controller.currentQuestion;

    final result =
        controller.nlpResult.value;

    if (question == null ||
        result == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(
          18,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // ===========================
            // BENAR / SALAH
            // ===========================

            Row(
              children: [
                Icon(
                  result.isCorrect
                      ? Icons.check_circle
                      : Icons.cancel,
                ),

                const SizedBox(
                  width: 10,
                ),

                Expanded(
                  child: Text(
                    result.isCorrect
                        ? 'Jawaban Benar'
                        : 'Jawaban Belum Tepat',

                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // ===========================
            // MAKNA
            // ===========================

            _buildScoreItem(
              title:
                  'Kesesuaian Makna',
              score:
                  result.semanticScore,
            ),

            const SizedBox(
              height: 16,
            ),

            // ===========================
            // KONTEKS
            // ===========================

            _buildScoreItem(
              title:
                  'Kesesuaian Konteks',
              score:
                  result.contextScore,
            ),

            const SizedBox(
              height: 16,
            ),

            // ===========================
            // RIMA
            // ===========================

            _buildScoreItem(
              title:
                  'Kesesuaian Rima',
              score:
                  result.rhymeScore,
            ),

            const Divider(
              height: 32,
            ),

            // ===========================
            // NILAI NLP
            // ===========================

            Text(
              'Nilai NLP: '
              '${(result.finalScore * 100).toStringAsFixed(0)}%',

              style:
                  const TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            // ===========================
            // PENJELASAN
            // ===========================

            const Text(
              'Penjelasan',

              style:
                  TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            Text(
              result.explanation,

              style:
                  const TextStyle(
                height: 1.5,
              ),
            ),

            // ===========================
            // REFERENSI JIKA SALAH
            // ===========================

            if (!result.isCorrect) ...[
              const SizedBox(
                height: 18,
              ),

              const Text(
                'Jawaban referensi:',

                style:
                    TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 5,
              ),

              Text(
                question
                    .referenceAnswer,

                style:
                    const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =====================================
  // SCORE ITEM
  // =====================================

  Widget _buildScoreItem({
    required String title,
    required double score,
  }) {
    final safeScore =
        score.clamp(
          0.0,
          1.0,
        ).toDouble();

    final percentage =
        safeScore * 100;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,

      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
              ),
            ),

            Text(
              '${percentage.toStringAsFixed(0)}%',

              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 7,
        ),

        LinearProgressIndicator(
          value: safeScore,
        ),
      ],
    );
  }

  // =====================================
  // BUTTON
  // =====================================

  Widget _buildButton() {
    // -----------------------------------
    // BELUM DIJAWAB
    // -----------------------------------

    if (!controller
        .isAnswered.value) {
      return SizedBox(
        height: 52,

        child:
            ElevatedButton.icon(
          onPressed:
              controller
                      .isChecking
                      .value
                  ? null
                  : controller
                      .checkAnswer,

          icon:
              controller
                      .isChecking
                      .value
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.check,
                    ),

          label:
              Text(
            controller
                    .isChecking
                    .value
                ? 'Menganalisis...'
                : 'Periksa Jawaban',
          ),
        ),
      );
    }

    // -----------------------------------
    // SUDAH DIJAWAB
    // -----------------------------------

    return SizedBox(
      height: 52,

      child:
          ElevatedButton.icon(
        onPressed:
            controller
                    .isSavingResult
                    .value
                ? null
                : controller
                    .nextQuestion,

        icon:
            controller
                    .isSavingResult
                    .value
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    controller
                            .isLastQuestion
                        ? Icons.flag
                        : Icons
                            .arrow_forward,
                  ),

        label:
            Text(
          controller
                  .isSavingResult
                  .value
              ? 'Menyimpan...'
              : controller
                      .isLastQuestion
                  ? 'Lihat Hasil'
                  : 'Soal Berikutnya',
        ),
      ),
    );
  }

  // =====================================
  // ERROR
  // =====================================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          24,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.error_outline,
              size: 70,
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              controller
                  .errorMessage
                  .value,

              textAlign:
                  TextAlign.center,
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton.icon(
              onPressed:
                  controller
                      .loadQuestions,

              icon:
                  const Icon(
                Icons.refresh,
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

  // =====================================
  // EMPTY
  // =====================================

  Widget _buildEmpty() {
    return const Center(
      child: Padding(
        padding:
            EdgeInsets.all(
          24,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              Icons.quiz_outlined,
              size: 70,
            ),

            SizedBox(
              height: 16,
            ),

            Text(
              'Belum ada soal untuk '
              'pantun ini.',

              textAlign:
                  TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}