import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/pantun_model.dart';
import '../models/question_model.dart';
import '../models/vocabulary_model.dart';

class PantunService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // =====================================
  // MENGAMBIL SEMUA PANTUN AKTIF
  // =====================================

Future<List<PantunModel>>
    getPantunByCategory(
  String categoryId,
) async {
  try {
    final snapshot = await _firestore
        .collection('pantun')
        .where(
          'categoryId',
          isEqualTo: categoryId,
        )
        .where(
          'isActive',
          isEqualTo: true,
        )
        .get();

    final pantunList = snapshot.docs
        .map(
          (doc) => PantunModel.fromMap(
            doc.id,
            doc.data(),
          ),
        )
        .toList();

    pantunList.sort(
      (a, b) =>
          a.orderInCategory.compareTo(
        b.orderInCategory,
      ),
    );

    debugPrint(
      'Pantun kategori $categoryId: '
      '${pantunList.length}',
    );

    return pantunList;
  } catch (e) {
    debugPrint(
      'ERROR GET PANTUN BY CATEGORY: $e',
    );

      throw Exception(
        'Gagal mengambil data pantun: $e',
      );
    }
  }

  // =====================================
  // MENGAMBIL SATU PANTUN
  // =====================================

  Future<PantunModel?> getPantunById(
    String pantunId,
  ) async {
    try {
      final document = await _firestore
          .collection('pantun')
          .doc(pantunId)
          .get();

      if (!document.exists) {
        return null;
      }

      final data = document.data();

      if (data == null) {
        return null;
      }

      return PantunModel.fromMap(
        document.id,
        data,
      );
    } catch (e) {
      debugPrint(
        'ERROR GET PANTUN BY ID: $e',
      );

      throw Exception(
        'Gagal mengambil pantun: $e',
      );
    }
  }

  // =====================================
  // MENGAMBIL QUESTIONS
  // =====================================

  Future<List<QuestionModel>> getQuestions(
    String pantunId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('pantun')
          .doc(pantunId)
          .collection('questions')
          .get();

      debugPrint(
        'Jumlah soal $pantunId: '
        '${snapshot.docs.length}',
      );

      final questions = snapshot.docs
          .map(
            (doc) => QuestionModel.fromMap(
              doc.id,
              doc.data(),
            ),
          )
          .toList();

      questions.sort(
        (a, b) => a.id.compareTo(b.id),
      );

      return questions;
    } catch (e) {
      debugPrint(
        'ERROR GET QUESTIONS: $e',
      );

      throw Exception(
        'Gagal mengambil soal: $e',
      );
    }
  }

  // =====================================
  // MENGAMBIL VOCABULARY
  // =====================================

  Future<List<VocabularyModel>> getVocabulary(
    String pantunId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('pantun')
          .doc(pantunId)
          .collection('vocabulary')
          .get();

      debugPrint(
        'Jumlah kosakata $pantunId: '
        '${snapshot.docs.length}',
      );

      final vocabularyList = snapshot.docs
          .map(
            (doc) => VocabularyModel.fromMap(
              doc.id,
              doc.data(),
            ),
          )
          .toList();

      vocabularyList.sort(
        (a, b) => a.id.compareTo(b.id),
      );

      return vocabularyList;
    } catch (e) {
      debugPrint(
        'ERROR GET VOCABULARY: $e',
      );

      throw Exception(
        'Gagal mengambil kosakata: $e',
      );
    }
  }
}