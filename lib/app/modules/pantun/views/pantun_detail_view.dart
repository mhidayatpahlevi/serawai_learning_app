import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/category_model.dart';
import '../../../data/models/pantun_model.dart';
import '../../../routes/app_routes.dart';

class PantunDetailView
    extends StatelessWidget {
  const PantunDetailView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    // =====================================
    // AMBIL ARGUMENT
    // =====================================

    final arguments =
        Get.arguments;

    // =====================================
    // VALIDASI ARGUMENT
    // =====================================

    if (arguments is! Map ||
        arguments['pantun']
            is! PantunModel ||
        arguments['category']
            is! CategoryModel) {
      return Scaffold(
        appBar: AppBar(
          title:
              const Text(
            'Detail Pantun',
          ),
        ),
        body:
            const Center(
          child: Text(
            'Data pantun atau kategori '
            'tidak ditemukan.',
          ),
        ),
      );
    }

    // =====================================
    // DATA
    // =====================================

    final PantunModel pantun =
        arguments['pantun']
            as PantunModel;

    final CategoryModel category =
        arguments['category']
            as CategoryModel;

    // =====================================
    // VIEW
    // =====================================

    return Scaffold(
      appBar: AppBar(
        title:
            Text(
          pantun.judul,
        ),
        centerTitle:
            true,
      ),

      body: SafeArea(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            20,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .stretch,

            children: [
              // =================================
              // INFO KATEGORI
              // =================================

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child:
                            _InfoItem(
                          title:
                              'Kategori',
                          value:
                              category.nama,
                        ),
                      ),

                      Expanded(
                        child:
                            _InfoItem(
                          title:
                              'Level',
                          value:
                              category.level,
                        ),
                      ),

                      Expanded(
                        child:
                            _InfoItem(
                          title:
                              'Pantun',
                          value:
                              '${pantun.orderInCategory}'
                              '/'
                              '${category.totalPantun}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // =================================
              // INFORMASI LATIHAN
              // =================================

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    22,
                  ),

                  child: Column(
                    children: [
                      const Icon(
                        Icons.quiz_outlined,
                        size: 55,
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      Text(
                        pantun.judul,

                        textAlign:
                            TextAlign.center,

                        style:
                            const TextStyle(
                          fontSize: 21,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        category
                            .description,

                        textAlign:
                            TextAlign.center,

                        style:
                            const TextStyle(
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      const Text(
                        'Lengkapi pantun '
                        'Bahasa Serawai dengan '
                        'memilih kata yang '
                        'paling tepat.',

                        textAlign:
                            TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // =================================
              // INFORMASI LEVEL
              // =================================

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),

                  child: Row(
                    children: [
                      const Icon(
                        Icons
                            .school_outlined,
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            const Text(
                              'Tingkat Kesulitan',

                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 3,
                            ),

                            Text(
                              pantun.level
                                      .isEmpty
                                  ? category
                                      .level
                                  : pantun
                                      .level,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // =================================
              // CATATAN
              // =================================

              const Card(
                child: Padding(
                  padding:
                      EdgeInsets.all(
                    16,
                  ),

                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      Icon(
                        Icons
                            .info_outline,
                      ),

                      SizedBox(
                        width: 12,
                      ),

                      Expanded(
                        child: Text(
                          'Pantun lengkap, '
                          'terjemahan Bahasa '
                          'Indonesia, pola rima, '
                          'dan kosakata akan '
                          'dapat dipelajari '
                          'setelah latihan '
                          'selesai.',
                          style:
                              TextStyle(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // =================================
              // MULAI LATIHAN
              // =================================

              SizedBox(
                height: 52,

                child:
                    ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(
                      Routes.latihan,

                      arguments: {
                        'pantun':
                            pantun,
                        'category':
                            category,
                      },
                    );
                  },

                  icon:
                      const Icon(
                    Icons.play_arrow,
                  ),

                  label:
                      const Text(
                    'Mulai Latihan',
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// WIDGET INFO
// ==========================================

class _InfoItem
    extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        Text(
          title,

          style:
              const TextStyle(
            fontSize: 12,
          ),

          textAlign:
              TextAlign.center,
        ),

        const SizedBox(
          height: 5,
        ),

        Text(
          value.isEmpty
              ? '-'
              : value,

          textAlign:
              TextAlign.center,

          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }
}