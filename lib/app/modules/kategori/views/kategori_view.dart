import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/category_model.dart';
import '../controllers/kategori_controller.dart';

class KategoriView
    extends GetView<KategoriController> {
  const KategoriView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kategori Pantun',
        ),
        centerTitle: true,
      ),

      body: Obx(
        () {
          if (controller
              .isLoading.value) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (controller
              .errorMessage
              .value
              .isNotEmpty) {
            return Center(
              child: ElevatedButton.icon(
                onPressed:
                    controller.loadData,
                icon:
                    const Icon(
                  Icons.refresh,
                ),
                label:
                    const Text(
                  'Coba Lagi',
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh:
                controller.loadData,

            child: ListView(
              padding:
                  const EdgeInsets.all(
                16,
              ),

              children: [
                _buildLevelCard(),

                const SizedBox(
                  height: 20,
                ),

                const Text(
                  'Urutan Belajar',

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

                ...controller.categories.map(
                  _buildCategoryCard,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLevelCard() {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(
          18,
        ),

        child: Row(
          children: [
            const CircleAvatar(
              radius: 27,
              child:
                  Icon(
                Icons.school_outlined,
              ),
            ),

            const SizedBox(
              width: 15,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Level Anda',
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    controller
                        .userLevel
                        .value
                        .toUpperCase(),

                    style:
                        const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    'Kategori terbuka sampai '
                    '${controller.highestUnlockedCategory.value}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    CategoryModel category,
  ) {
    final unlocked =
        controller.isUnlocked(
      category,
    );

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
          controller.openCategory(
            category,
          );
        },

        child: Padding(
          padding:
              const EdgeInsets.all(
            16,
          ),

          child: Row(
            children: [
              CircleAvatar(
                child: Text(
                  '${category.order}',
                ),
              ),

              const SizedBox(
                width: 15,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      category.nama,

                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      'Level: '
                      '${category.level}',
                    ),

                    Text(
                      '${category.totalPantun} '
                      'pantun',
                    ),

                    if (category
                        .description
                        .isNotEmpty) ...[
                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        category
                            .description,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              Icon(
                unlocked
                    ? Icons
                        .lock_open_outlined
                    : Icons
                        .lock_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}