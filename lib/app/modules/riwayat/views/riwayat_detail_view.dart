import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/answer_history_model.dart';
import '../../../data/models/latihan_history_model.dart';

class RiwayatDetailView
    extends StatelessWidget {
  const RiwayatDetailView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final argument =
        Get.arguments;

    if (argument
        is! LatihanHistoryModel) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Data riwayat tidak ditemukan.',
          ),
        ),
      );
    }

    final history =
        argument;

    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          'Detail Riwayat',
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding:
            const EdgeInsets.all(
          16,
        ),

        children: [
          // =================================
          // INFO HASIL
          // =================================

          Card(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                18,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,

                children: [
                  Text(
                    history.pantunTitle,

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
                    '${history.kategori}',
                  ),

                  const Divider(
                    height: 28,
                  ),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceAround,

                    children: [
                      _resultItem(
                        'Nilai',
                        history.score
                            .toStringAsFixed(
                          0,
                        ),
                      ),

                      _resultItem(
                        'Benar',
                        '${history.correctCount}',
                      ),

                      _resultItem(
                        'Salah',
                        '${history.wrongCount}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          const Text(
            'Detail Jawaban',

            style:
                TextStyle(
              fontSize: 21,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          if (history.answers.isEmpty)
            const Card(
              child: Padding(
                padding:
                    EdgeInsets.all(
                  20,
                ),

                child: Text(
                  'Detail jawaban belum tersedia.',
                  textAlign:
                      TextAlign.center,
                ),
              ),
            )
          else
            ...List.generate(
              history.answers.length,
              (index) {
                return _answerCard(
                  index + 1,
                  history.answers[index],
                );
              },
            ),

          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  // =====================================
  // RESULT ITEM
  // =====================================

  Widget _resultItem(
    String label,
    String value,
  ) {
    return Column(
      children: [
        Text(
          value,

          style:
              const TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 3,
        ),

        Text(
          label,
        ),
      ],
    );
  }

  // =====================================
  // ANSWER
  // =====================================

  Widget _answerCard(
    int number,
    AnswerHistoryModel answer,
  ) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(
          18,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .stretch,

          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(
                    '$number',
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child: Text(
                    answer.isCorrect
                        ? 'Jawaban Benar'
                        : 'Jawaban Belum Tepat',

                    style:
                        const TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                Icon(
                  answer.isCorrect
                      ? Icons.check_circle
                      : Icons.cancel,
                ),
              ],
            ),

            const Divider(
              height: 28,
            ),

            const Text(
              'Jawaban Anda',
              style:
                  TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            Text(
              answer.selectedAnswer,
            ),

            const SizedBox(
              height: 14,
            ),

            const Text(
              'Jawaban Referensi',
              style:
                  TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            Text(
              answer.referenceAnswer,
            ),

            const SizedBox(
              height: 20,
            ),

            _nlpScore(
              'Makna',
              answer.semanticScore,
            ),

            const SizedBox(
              height: 12,
            ),

            _nlpScore(
              'Konteks',
              answer.contextScore,
            ),

            const SizedBox(
              height: 12,
            ),

            _nlpScore(
              'Rima',
              answer.rhymeScore,
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              'Nilai NLP: '
              '${(answer.finalScore * 100).toStringAsFixed(0)}%',

              style:
                  const TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            if (answer
                .explanation
                .isNotEmpty) ...[
              const SizedBox(
                height: 16,
              ),

              const Text(
                'Penjelasan',

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
                answer.explanation,

                style:
                    const TextStyle(
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =====================================
  // NLP SCORE
  // =====================================

  Widget _nlpScore(
    String title,
    double score,
  ) {
    final safeScore =
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
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,

          children: [
            Text(
              'Kesesuaian $title',
            ),

            Text(
              '${(safeScore * 100).toStringAsFixed(0)}%',

              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 6,
        ),

        LinearProgressIndicator(
          value:
              safeScore,
        ),
      ],
    );
  }
}