import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/materi_controller.dart';

class MateriView
    extends GetView<MateriController> {
  const MateriView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pelajari Pantun',
        ),
        centerTitle: true,
      ),

      body: Obx(
        () {
          if (controller
              .errorMessage
              .value
              .isNotEmpty) {
            return _buildError();
          }

          return RefreshIndicator(
            onRefresh:
                controller.refreshVocabulary,

            child: ListView(
              padding:
                  const EdgeInsets.all(
                20,
              ),

              children: [
                // =========================
                // JUDUL
                // =========================

                Text(
                  controller.pantun.judul,

                  style:
                      const TextStyle(
                    fontSize: 25,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  'Kategori: '
                  '${controller.pantun.kategori}',
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  'Tingkat: '
                  '${controller.pantun.level}',
                ),

                const SizedBox(
                  height: 24,
                ),

                // =========================
                // POLA RIMA
                // =========================

                _buildRhymeCard(),

                const SizedBox(
                  height: 24,
                ),

                // =========================
                // PANTUN LENGKAP
                // =========================

                const Text(
                  'Pantun Bahasa Serawai',

                  style:
                      TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                _buildPantunCard(),

                const SizedBox(
                  height: 28,
                ),

                // =========================
                // TERJEMAHAN
                // =========================

                const Text(
                  'Terjemahan Bahasa Indonesia',

                  style:
                      TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                _buildTranslationCard(),

                const SizedBox(
                  height: 28,
                ),

                // =========================
                // PANTUN + ARTI PER BARIS
                // =========================

                const Text(
                  'Makna Setiap Baris',

                  style:
                      TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                _buildLineTranslation(),

                const SizedBox(
                  height: 28,
                ),

                // =========================
                // KOSAKATA
                // =========================

                const Text(
                  'Kosakata Bahasa Serawai',

                  style:
                      TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                if (controller
                    .isLoading.value)
                  const Center(
                    child: Padding(
                      padding:
                          EdgeInsets.all(
                        25,
                      ),
                      child:
                          CircularProgressIndicator(),
                    ),
                  )
                else if (controller
                    .vocabularyList
                    .isEmpty)
                  const Card(
                    child: Padding(
                      padding:
                          EdgeInsets.all(
                        20,
                      ),
                      child: Text(
                        'Belum ada kosakata '
                        'untuk pantun ini.',
                        textAlign:
                            TextAlign.center,
                      ),
                    ),
                  )
                else
                  ...controller
                      .vocabularyList
                      .map(
                    (vocabulary) =>
                        _buildVocabularyCard(
                      serawai:
                          vocabulary.serawai,
                      indonesia:
                          vocabulary.indonesia,
                      keterangan:
                          vocabulary.keterangan,
                    ),
                  ),

                const SizedBox(
                  height: 30,
                ),

                // =========================
                // SELESAI
                // =========================

                SizedBox(
                  height: 52,

                  child:
                      ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },

                    icon:
                        const Icon(
                      Icons.check_circle_outline,
                    ),

                    label:
                        const Text(
                      'Selesai Belajar',
                    ),
                  ),
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
  // RIMA
  // =====================================

  Widget _buildRhymeCard() {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(
          18,
        ),

        child: Row(
          children: [
            const CircleAvatar(
              child:
                  Icon(
                Icons.music_note,
              ),
            ),

            const SizedBox(
              width: 15,
            ),

            const Expanded(
              child: Text(
                'Pola Rima',

                style:
                    TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            Text(
              controller
                  .pantun
                  .polaRima,

              style:
                  const TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================
  // PANTUN
  // =====================================

  Widget _buildPantunCard() {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children:
              List.generate(
            controller
                .pantun
                .baris
                .length,

            (index) {
              return Padding(
                padding:
                    const EdgeInsets
                        .symmetric(
                  vertical: 6,
                ),

                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    SizedBox(
                      width: 28,

                      child: Text(
                        '${index + 1}.',
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Text(
                        controller
                            .pantun
                            .baris[index],

                        style:
                            const TextStyle(
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // =====================================
  // TERJEMAHAN
  // =====================================

  Widget _buildTranslationCard() {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children:
              List.generate(
            controller
                .pantun
                .terjemahan
                .length,

            (index) {
              return Padding(
                padding:
                    const EdgeInsets
                        .symmetric(
                  vertical: 6,
                ),

                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    SizedBox(
                      width: 28,

                      child: Text(
                        '${index + 1}.',
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Text(
                        controller
                            .pantun
                            .terjemahan[
                          index
                        ],

                        style:
                            const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // =====================================
  // PANTUN + TERJEMAHAN PER BARIS
  // =====================================

  Widget _buildLineTranslation() {
    final pantunLines =
        controller.pantun.baris;

    final translations =
        controller.pantun.terjemahan;

    final count =
        pantunLines.length <
                translations.length
            ? pantunLines.length
            : translations.length;

    return Column(
      children: List.generate(
        count,
        (index) {
          return Card(
            margin:
                const EdgeInsets.only(
              bottom: 10,
            ),

            child: Padding(
              padding:
                  const EdgeInsets.all(
                16,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    'Baris ${index + 1}',

                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    pantunLines[index],

                    style:
                        const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const Divider(
                    height: 24,
                  ),

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      const Icon(
                        Icons.translate,
                        size: 18,
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Expanded(
                        child: Text(
                          translations[
                            index
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // =====================================
  // KOSAKATA CARD
  // =====================================

  Widget _buildVocabularyCard({
    required String serawai,
    required String indonesia,
    required String keterangan,
  }) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(
          16,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                const Icon(
                  Icons.translate,
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child: Text(
                    serawai,

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
              height: 10,
            ),

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const SizedBox(
                  width: 36,
                ),

                const Text(
                  'Arti: ',
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                Expanded(
                  child: Text(
                    indonesia,
                  ),
                ),
              ],
            ),

            if (keterangan
                .trim()
                .isNotEmpty) ...[
              const SizedBox(
                height: 8,
              ),

              Padding(
                padding:
                    const EdgeInsets.only(
                  left: 36,
                ),

                child: Text(
                  keterangan,

                  style:
                      const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ],
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
                      .loadVocabulary,

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