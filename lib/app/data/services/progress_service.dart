import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/category_progress_model.dart';

class ProgressService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // Nilai minimal pantun dianggap lulus
  static const double passingScore = 70;

  // =====================================
  // CURRENT USER
  // =====================================

  User get _currentUser {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'Pengguna belum login.',
      );
    }

    return user;
  }

  // =====================================
  // PASTIKAN PROFILE LEARNING ADA
  // Untuk user lama
  // =====================================

  Future<void> ensureLearningProfile() async {
    try {
      final user = _currentUser;

      final userRef = _firestore
          .collection('users')
          .doc(user.uid);

      final document =
          await userRef.get();

      if (!document.exists) {
        return;
      }

      final data =
          document.data() ?? {};

      final updates =
          <String, dynamic>{};

      if (!data.containsKey(
        'highestUnlockedCategory',
      )) {
        updates[
            'highestUnlockedCategory'] = 1;
      }

      if (!data.containsKey(
        'userLevel',
      )) {
        updates['userLevel'] =
            'pemula';
      }

      if (!data.containsKey(
        'totalPantunCompleted',
      )) {
        updates[
            'totalPantunCompleted'] = 0;
      }

      if (!data.containsKey(
        'totalCategoriesCompleted',
      )) {
        updates[
            'totalCategoriesCompleted'] = 0;
      }

      if (updates.isNotEmpty) {
        await userRef.update(
          updates,
        );
      }
    } catch (e) {
      debugPrint(
        'ERROR ENSURE LEARNING PROFILE: $e',
      );

      rethrow;
    }
  }

  // =====================================
  // HIGHEST UNLOCKED CATEGORY
  // =====================================

  Future<int>
      getHighestUnlockedCategory() async {
    final user = _currentUser;

    await ensureLearningProfile();

    final document = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    final data =
        document.data();

    if (data == null) {
      return 1;
    }

    final value =
        data['highestUnlockedCategory'];

    if (value is num) {
      return value.toInt();
    }

    return 1;
  }

  // =====================================
  // USER LEVEL
  // =====================================

  String calculateUserLevel(
    int highestUnlockedCategory,
  ) {
    if (highestUnlockedCategory <= 8) {
      return 'pemula';
    }

    if (highestUnlockedCategory <= 16) {
      return 'menengah';
    }

    return 'mahir';
  }

  // =====================================
  // GET CATEGORY PROGRESS
  // =====================================

  Future<CategoryProgressModel?>
      getCategoryProgress(
    String categoryId,
  ) async {
    final user = _currentUser;

    final document = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('progress')
        .doc(categoryId)
        .get();

    if (!document.exists) {
      return null;
    }

    final data =
        document.data();

    if (data == null) {
      return null;
    }

    return CategoryProgressModel.fromMap(
      data,
    );
  }

  // =====================================
  // SIMPAN HASIL PANTUN
  // =====================================

  Future<void> updatePantunProgress({
    required String categoryId,
    required int categoryOrder,
    required int totalPantun,
    required String pantunId,
    required double score,
  }) async {
    try {
      final user = _currentUser;

      final userRef = _firestore
          .collection('users')
          .doc(user.uid);

      final progressRef = userRef
          .collection('progress')
          .doc(categoryId);

      final progressDocument =
          await progressRef.get();

      final oldData =
          progressDocument.data() ?? {};

      final completedPantunIds =
          List<String>.from(
        oldData[
                'completedPantunIds'] ??
            [],
      );

      final rawBestScores =
          oldData['bestScores']
                  as Map<String, dynamic>? ??
              {};

      final bestScores =
          <String, double>{};

      for (final entry
          in rawBestScores.entries) {
        bestScores[entry.key] =
            entry.value is num
                ? (entry.value as num)
                    .toDouble()
                : 0;
      }

      // =================================
      // BEST SCORE
      // =================================

      final previousBest =
          bestScores[pantunId] ?? 0;

      if (score > previousBest) {
        bestScores[pantunId] =
            score;
      }

      // =================================
      // PANTUN LULUS
      // =================================

      if (score >= passingScore &&
          !completedPantunIds.contains(
            pantunId,
          )) {
        completedPantunIds.add(
          pantunId,
        );
      }

      // =================================
      // CATEGORY COMPLETED?
      // =================================

      final categoryCompleted =
          totalPantun > 0 &&
          completedPantunIds.length >=
              totalPantun;

      final previouslyCompleted =
          oldData['completed'] == true;

      await progressRef.set(
        {
          'categoryId':
              categoryId,

          'categoryOrder':
              categoryOrder,

          'completedPantunIds':
              completedPantunIds,

          'bestScores':
              bestScores,

          'completed':
              categoryCompleted,

          'updatedAt':
              FieldValue.serverTimestamp(),

          if (categoryCompleted &&
              !previouslyCompleted)
            'completedAt':
                FieldValue.serverTimestamp(),
        },
        SetOptions(
          merge: true,
        ),
      );

      // =================================
      // UPDATE USER PROFILE
      // =================================

      if (categoryCompleted) {
        final userDocument =
            await userRef.get();

        final userData =
            userDocument.data() ?? {};

        final currentUnlocked =
            userData[
                    'highestUnlockedCategory']
                is num
                ? (userData[
                            'highestUnlockedCategory']
                        as num)
                    .toInt()
                : 1;

        final nextCategory =
            categoryOrder + 1;

        if (nextCategory >
            currentUnlocked) {
          final userLevel =
              calculateUserLevel(
            nextCategory,
          );

          await userRef.set(
            {
              'highestUnlockedCategory':
                  nextCategory,

              'userLevel':
                  userLevel,
            },
            SetOptions(
              merge: true,
            ),
          );
        }
      }

      // =================================
      // RECALCULATE GLOBAL COUNTS
      // =================================

      await _recalculateUserProgress();

      debugPrint(
        'Progress berhasil diperbarui.',
      );
    } catch (e) {
      debugPrint(
        'ERROR UPDATE PROGRESS: $e',
      );

      rethrow;
    }
  }

  // =====================================
  // HITUNG TOTAL PROGRESS
  // =====================================

  Future<void>
      _recalculateUserProgress() async {
    final user = _currentUser;

    final userRef = _firestore
        .collection('users')
        .doc(user.uid);

    final snapshot = await userRef
        .collection('progress')
        .get();

    final completedPantunIds =
        <String>{};

    int completedCategories = 0;

    for (final document
        in snapshot.docs) {
      final data =
          document.data();

      final ids =
          List<String>.from(
        data['completedPantunIds'] ??
            [],
      );

      completedPantunIds.addAll(
        ids,
      );

      if (data['completed'] ==
          true) {
        completedCategories++;
      }
    }

    await userRef.set(
      {
        'totalPantunCompleted':
            completedPantunIds.length,

        'totalCategoriesCompleted':
            completedCategories,
      },
      SetOptions(
        merge: true,
      ),
    );
  }
}