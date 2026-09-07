import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/category_model.dart';
import '../../../data/models/pantun_model.dart';
import '../../../data/services/pantun_service.dart';
import '../../../routes/app_routes.dart';

class PantunController extends GetxController {
  // =====================================
  // SERVICE
  // =====================================

  final PantunService _pantunService =
      Get.find<PantunService>();

  // =====================================
  // DATA KATEGORI
  // =====================================

  late final CategoryModel category;

  // =====================================
  // STATE
  // =====================================

  final pantunList =
      <PantunModel>[].obs;

  final isLoading =
      false.obs;

  final errorMessage =
      ''.obs;

  // =====================================
  // INIT
  // =====================================

  @override
  void onInit() {
    super.onInit();

    final arguments =
        Get.arguments;

    if (arguments is CategoryModel) {
      category =
          arguments;

      loadPantun();
    } else {
      errorMessage.value =
          'Data kategori tidak ditemukan.';

      debugPrint(
        'ERROR ARGUMENT PANTUN: $arguments',
      );
    }
  }

  // =====================================
  // LOAD PANTUN BERDASARKAN KATEGORI
  // =====================================

  Future<void> loadPantun() async {
    try {
      isLoading.value =
          true;

      errorMessage.value =
          '';

      final result =
          await _pantunService
              .getPantunByCategory(
        category.id,
      );

      pantunList.assignAll(
        result,
      );

      debugPrint(
        'Kategori: ${category.id}',
      );

      debugPrint(
        'Jumlah pantun: '
        '${pantunList.length}',
      );
    } catch (e) {
      errorMessage.value =
          'Gagal mengambil pantun.';

      debugPrint(
        'ERROR LOAD PANTUN: $e',
      );
    } finally {
      isLoading.value =
          false;
    }
  }

  // =====================================
  // REFRESH
  // =====================================

  Future<void> refreshPantun() async {
    await loadPantun();
  }

  // =====================================
  // BUKA DETAIL PANTUN
  // =====================================

  void openPantun(
    PantunModel pantun,
  ) {
    Get.toNamed(
      Routes.pantunDetail,
      arguments: {
        'pantun': pantun,
        'category': category,
      },
    );
  }
}