import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/pantun_model.dart';
import '../../../data/models/vocabulary_model.dart';
import '../../../data/services/pantun_service.dart';

class MateriController extends GetxController {
  final PantunService _pantunService =
      Get.find<PantunService>();

  // =====================================
  // DATA PANTUN
  // =====================================

  late final PantunModel pantun;

  // =====================================
  // STATE
  // =====================================

  final vocabularyList =
      <VocabularyModel>[].obs;

  final isLoading = false.obs;

  final errorMessage = ''.obs;

  // =====================================
  // INIT
  // =====================================

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments is PantunModel) {
      pantun = arguments;

      loadVocabulary();
    } else {
      errorMessage.value =
          'Data pantun tidak ditemukan.';
    }
  }

  // =====================================
  // LOAD VOCABULARY
  // =====================================

  Future<void> loadVocabulary() async {
    try {
      isLoading.value = true;

      errorMessage.value = '';

      final result =
          await _pantunService.getVocabulary(
        pantun.id,
      );

      vocabularyList.assignAll(
        result,
      );
    } catch (e) {
      errorMessage.value =
          'Gagal mengambil kosakata.';

      debugPrint(
        'ERROR LOAD VOCABULARY: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =====================================
  // REFRESH
  // =====================================

  Future<void> refreshVocabulary() async {
    await loadVocabulary();
  }
}