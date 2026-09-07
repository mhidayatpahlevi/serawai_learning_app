import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/pantun_controller.dart';

class PantunView
    extends GetView<PantunController> {
  const PantunView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pantun Bahasa Serawai',
        ),
        centerTitle: true,
      ),

      body: Obx(
        () {
          // ==================================
          // LOADING
          // ==================================

          if (controller.isLoading.value) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          // ==================================
          // ERROR
          // ==================================

          if (controller
              .errorMessage
              .value
              .isNotEmpty) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
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
                          .errorMessage.value,
                      textAlign:
                          TextAlign.center,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    ElevatedButton.icon(
                      onPressed:
                          controller
                              .loadPantun,
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

          // ==================================
          // DATA KOSONG
          // ==================================

          if (controller
              .pantunList
              .isEmpty) {
            return RefreshIndicator(
              onRefresh:
                  controller
                      .refreshPantun,
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 180,
                  ),

                  Icon(
                    Icons.auto_stories_outlined,
                    size: 80,
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  Center(
                    child: Text(
                      'Belum ada data pantun.',
                    ),
                  ),
                ],
              ),
            );
          }

          // ==================================
          // DAFTAR PANTUN
          // ==================================

          return RefreshIndicator(
            onRefresh:
                controller.refreshPantun,
            child: ListView.builder(
              padding:
                  const EdgeInsets.all(16),

              itemCount:
                  controller
                      .pantunList.length,

              itemBuilder:
                  (context, index) {
                final pantun =
                    controller
                        .pantunList[index];

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),

                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.all(
                      16,
                    ),

                    leading: CircleAvatar(
                      child: Text(
                        '${index + 1}',
                      ),
                    ),

                    title: Text(
                      pantun.judul,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    subtitle: Padding(
                      padding:
                          const EdgeInsets
                              .only(
                        top: 8,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            'Kategori: '
                            '${pantun.kategori}',
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            'Level: '
                            '${pantun.level}',
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            'Rima: '
                            '${pantun.polaRima}',
                          ),
                        ],
                      ),
                    ),

                    trailing:
                        const Icon(
                      Icons
                          .arrow_forward_ios,
                      size: 18,
                    ),

                    onTap: () {
                      controller
                          .openPantun(
                        pantun,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}