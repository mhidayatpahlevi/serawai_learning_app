import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/latihan_history_model.dart';
import '../controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat & Progres',
        ),
        centerTitle: true,
      ),

      body: Obx(
        () {
          // =====================================
          // LOADING
          // =====================================

          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // =====================================
          // ERROR
          // =====================================

          if (controller.errorMessage.value.isNotEmpty) {
            return _buildError();
          }

          // =====================================
          // CONTENT
          // =====================================

          return RefreshIndicator(
            onRefresh: controller.refreshHistories,
            child: ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                // =================================
                // PROGRES
                // =================================

                _buildProgressSummary(),

                const SizedBox(
                  height: 28,
                ),

                // =================================
                // RIWAYAT
                // =================================

                const Text(
                  'Riwayat Latihan',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                if (controller.histories.isEmpty)
                  _buildEmpty()
                else
                  ...controller.histories.map(
                    _buildHistoryCard,
                  ),

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
  // PROGRESS SUMMARY
  // =====================================

  Widget _buildProgressSummary() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Progres Belajar',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 14,
        ),

        // =================================
        // GRID RESPONSIF
        // =================================

        LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final width =
                constraints.maxWidth;

            int crossAxisCount = 2;

            if (width >= 900) {
              crossAxisCount = 4;
            } else if (width >= 650) {
              crossAxisCount = 3;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,

                // Tinggi tetap agar tidak
                // terjadi RenderFlex overflow.
                mainAxisExtent: 125,
              ),
              itemBuilder: (
                context,
                index,
              ) {
                switch (index) {
                  case 0:
                    return _buildSummaryCard(
                      icon:
                          Icons.quiz_outlined,
                      title:
                          'Total Latihan',
                      value:
                          '${controller.totalLatihan}',
                    );

                  case 1:
                    return _buildSummaryCard(
                      icon:
                          Icons.auto_stories,
                      title:
                          'Pantun Dipelajari',
                      value:
                          '${controller.totalPantunDipelajari}',
                    );

                  case 2:
                    return _buildSummaryCard(
                      icon:
                          Icons.analytics_outlined,
                      title:
                          'Rata-rata Nilai',
                      value:
                          controller.averageScore
                              .toStringAsFixed(
                            0,
                          ),
                    );

                  case 3:
                    return _buildSummaryCard(
                      icon:
                          Icons.emoji_events_outlined,
                      title:
                          'Nilai Tertinggi',
                      value:
                          controller.highestScore
                              .toStringAsFixed(
                            0,
                          ),
                    );

                  case 4:
                    return _buildSummaryCard(
                      icon:
                          Icons.check_circle_outline,
                      title:
                          'Jawaban Benar',
                      value:
                          '${controller.totalBenar}',
                    );

                  case 5:
                    return _buildSummaryCard(
                      icon:
                          Icons.cancel_outlined,
                      title:
                          'Jawaban Salah',
                      value:
                          '${controller.totalSalah}',
                    );

                  default:
                    return const SizedBox.shrink();
                }
              },
            );
          },
        ),

        const SizedBox(
          height: 18,
        ),

        // =================================
        // AKURASI
        // =================================

        Card(
          child: Padding(
            padding:
                const EdgeInsets.all(
              18,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Akurasi Jawaban',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    Text(
                      '${controller.accuracy.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 12,
                ),

                LinearProgressIndicator(
                  value:
                      (controller.accuracy / 100)
                          .clamp(
                            0.0,
                            1.0,
                          )
                          .toDouble(),
                  minHeight: 7,
                ),

                const SizedBox(
                  height: 10,
                ),

                Text(
                  '${controller.totalBenar} '
                  'jawaban benar dari '
                  '${controller.totalSoal} soal.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =====================================
  // SUMMARY CARD
  // =====================================

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 27,
            ),

            const SizedBox(
              height: 6,
            ),

            Text(
              value,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            Flexible(
              child: Text(
                title,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                textAlign:
                    TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================
  // HISTORY CARD
  // =====================================

  Widget _buildHistoryCard(
    LatihanHistoryModel history,
  ) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          12,
        ),
        onTap: () {
          controller.openHistory(
            history,
          );
        },
        child: Padding(
          padding:
              const EdgeInsets.all(
            16,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ===========================
              // HEADER
              // ===========================

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    child: Icon(
                      Icons.history,
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
                          history.pantunTitle,
                          style:
                              const TextStyle(
                            fontSize: 16,
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
                          style:
                              const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: 6,
                  ),

                  const Icon(
                    Icons.chevron_right,
                  ),
                ],
              ),

              const Divider(
                height: 26,
              ),

              // ===========================
              // NILAI
              // ===========================

              Row(
                children: [
                  Expanded(
                    child:
                        _buildSmallInfo(
                      'Nilai',
                      history.score
                          .toStringAsFixed(
                        0,
                      ),
                    ),
                  ),

                  Expanded(
                    child:
                        _buildSmallInfo(
                      'Benar',
                      '${history.correctCount}',
                    ),
                  ),

                  Expanded(
                    child:
                        _buildSmallInfo(
                      'Salah',
                      '${history.wrongCount}',
                    ),
                  ),

                  Expanded(
                    child:
                        _buildSmallInfo(
                      'Soal',
                      '${history.totalQuestions}',
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 14,
              ),

              // ===========================
              // TANGGAL
              // ===========================

              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 15,
                  ),

                  const SizedBox(
                    width: 6,
                  ),

                  Text(
                    _formatDate(
                      history.createdAt,
                    ),
                    style:
                        const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================
  // SMALL INFO
  // =====================================

  Widget _buildSmallInfo(
    String label,
    String value,
  ) {
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          style:
              const TextStyle(
            fontSize: 15,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 3,
        ),

        Text(
          label,
          maxLines: 1,
          overflow:
              TextOverflow.ellipsis,
          textAlign:
              TextAlign.center,
          style:
              const TextStyle(
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // =====================================
  // FORMAT TANGGAL
  // =====================================

  String _formatDate(
    DateTime? date,
  ) {
    if (date == null) {
      return 'Waktu tidak tersedia';
    }

    final day =
        date.day.toString().padLeft(
              2,
              '0',
            );

    final month =
        date.month.toString().padLeft(
              2,
              '0',
            );

    final year =
        date.year;

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

    return '$day/$month/$year '
        '$hour:$minute';
  }

  // =====================================
  // EMPTY
  // =====================================

  Widget _buildEmpty() {
    return const Card(
      child: Padding(
        padding:
            EdgeInsets.all(
          30,
        ),
        child: Column(
          children: [
            Icon(
              Icons.history_toggle_off,
              size: 60,
            ),

            SizedBox(
              height: 12,
            ),

            Text(
              'Belum ada riwayat latihan.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            SizedBox(
              height: 6,
            ),

            Text(
              'Selesaikan latihan pantun '
              'untuk melihat progres belajar.',
              textAlign:
                  TextAlign.center,
            ),
          ],
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
              controller.errorMessage.value,
              textAlign:
                  TextAlign.center,
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton.icon(
              onPressed:
                  controller.loadHistories,
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
}