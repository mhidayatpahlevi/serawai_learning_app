import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/category_model.dart';
import '../../../data/services/category_service.dart';
import '../../../data/services/progress_service.dart';
import '../../../routes/app_routes.dart';

class KategoriController extends GetxController {
  // =====================================
  // SERVICES
  // =====================================

  final CategoryService _categoryService =
      Get.find<CategoryService>();

  final ProgressService _progressService =
      Get.find<ProgressService>();

  // =====================================
  // STATE
  // =====================================

  final categories =
      <CategoryModel>[].obs;

  final isLoading =
      false.obs;

  final errorMessage =
      ''.obs;

  final highestUnlockedCategory =
      1.obs;

  final userLevel =
      'pemula'.obs;

  // =====================================
  // INIT
  // =====================================

  @override
  void onInit() {
    super.onInit();

    loadData();
  }

  // =====================================
  // LOAD DATA
  // =====================================

  Future<void> loadData() async {
    try {
      isLoading.value = true;

      errorMessage.value = '';

      await _progressService
          .ensureLearningProfile();

      final unlocked =
          await _progressService
              .getHighestUnlockedCategory();

      final result =
          await _categoryService
              .getActiveCategories();

      highestUnlockedCategory.value =
          unlocked;

      userLevel.value =
          _progressService
              .calculateUserLevel(
        unlocked,
      );

      categories.assignAll(
        result,
      );

      debugPrint(
        '==============================',
      );

      debugPrint(
        'REFRESH KATEGORI',
      );

      debugPrint(
        'Kategori terbuka sampai: '
        '$unlocked',
      );

      debugPrint(
        'Level user: '
        '${userLevel.value}',
      );

      debugPrint(
        'Jumlah kategori: '
        '${categories.length}',
      );

      debugPrint(
        '==============================',
      );
    } catch (e) {
      errorMessage.value =
          'Gagal mengambil kategori.';

      debugPrint(
        'ERROR LOAD CATEGORY: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =====================================
  // REFRESH PROGRESS SAJA
  // =====================================

  Future<void> refreshProgress() async {
    try {
      final unlocked =
          await _progressService
              .getHighestUnlockedCategory();

      highestUnlockedCategory.value =
          unlocked;

      userLevel.value =
          _progressService
              .calculateUserLevel(
        unlocked,
      );

      debugPrint(
        'Kategori sekarang terbuka sampai: '
        '$unlocked',
      );
    } catch (e) {
      debugPrint(
        'ERROR REFRESH CATEGORY PROGRESS: $e',
      );
    }
  }

  // =====================================
  // CEK LOCK
  // =====================================

  bool isUnlocked(
    CategoryModel category,
  ) {
    return category.order <=
        highestUnlockedCategory.value;
  }

  // =====================================
  // BUKA KATEGORI
  // =====================================

  Future<void> openCategory(
    CategoryModel category,
  ) async {
    if (!isUnlocked(
      category,
    )) {
      Get.snackbar(
        'Kategori terkunci',
        'Selesaikan kategori '
            '${category.order - 1} '
            'terlebih dahulu.',
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return;
    }

    await Get.toNamed(
      Routes.pantun,
      arguments: category,
    );

    // Ketika kembali dari halaman pantun,
    // baca progress terbaru lagi.
    await refreshProgress();
  }
}