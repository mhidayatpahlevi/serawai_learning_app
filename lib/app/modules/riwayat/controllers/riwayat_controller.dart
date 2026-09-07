import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/latihan_history_model.dart';
import '../../../data/services/history_service.dart';
import '../../../routes/app_routes.dart';

class RiwayatController
    extends GetxController {
  final HistoryService _historyService =
      Get.find<HistoryService>();

  // =====================================
  // STATE
  // =====================================

  final histories =
      <LatihanHistoryModel>[].obs;

  final isLoading = false.obs;

  final errorMessage = ''.obs;

  // =====================================
  // INIT
  // =====================================

  @override
  void onInit() {
    super.onInit();

    loadHistories();
  }

  // =====================================
  // LOAD
  // =====================================

  Future<void> loadHistories() async {
    try {
      isLoading.value = true;

      errorMessage.value = '';

      final result =
          await _historyService
              .getHistories();

      histories.assignAll(
        result,
      );
    } catch (e) {
      errorMessage.value =
          'Gagal mengambil riwayat latihan.';

      debugPrint(
        'ERROR LOAD HISTORIES: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =====================================
  // REFRESH
  // =====================================

  Future<void> refreshHistories() async {
    await loadHistories();
  }

  // =====================================
  // TOTAL LATIHAN
  // =====================================

  int get totalLatihan {
    return histories.length;
  }

  // =====================================
  // TOTAL BENAR
  // =====================================

  int get totalBenar {
    return histories.fold(
      0,
      (
        total,
        history,
      ) =>
          total +
          history.correctCount,
    );
  }

  // =====================================
  // TOTAL SALAH
  // =====================================

  int get totalSalah {
    return histories.fold(
      0,
      (
        total,
        history,
      ) =>
          total +
          history.wrongCount,
    );
  }

  // =====================================
  // TOTAL SOAL
  // =====================================

  int get totalSoal {
    return histories.fold(
      0,
      (
        total,
        history,
      ) =>
          total +
          history.totalQuestions,
    );
  }

  // =====================================
  // RATA-RATA NILAI
  // =====================================

  double get averageScore {
    if (histories.isEmpty) {
      return 0;
    }

    final total =
        histories.fold<double>(
      0,
      (
        sum,
        history,
      ) =>
          sum + history.score,
    );

    return total /
        histories.length;
  }

  // =====================================
  // AKURASI
  // =====================================

  double get accuracy {
    if (totalSoal == 0) {
      return 0;
    }

    return totalBenar /
        totalSoal *
        100;
  }

  // =====================================
  // PANTUN UNIK
  // =====================================

  int get totalPantunDipelajari {
    final pantunIds =
        histories
            .map(
              (history) =>
                  history.pantunId,
            )
            .where(
              (id) =>
                  id.isNotEmpty,
            )
            .toSet();

    return pantunIds.length;
  }

  // =====================================
  // NILAI TERTINGGI
  // =====================================

  double get highestScore {
    if (histories.isEmpty) {
      return 0;
    }

    double highest = 0;

    for (final history
        in histories) {
      if (history.score >
          highest) {
        highest =
            history.score;
      }
    }

    return highest;
  }

  // =====================================
  // BUKA DETAIL
  // =====================================

  void openHistory(
    LatihanHistoryModel history,
  ) {
    Get.toNamed(
      Routes.riwayatDetail,
      arguments: history,
    );
  }
}