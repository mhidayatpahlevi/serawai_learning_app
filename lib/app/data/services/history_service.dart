import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/latihan_history_model.dart';

class HistoryService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

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
  // SIMPAN RIWAYAT
  // =====================================

  Future<String> saveHistory(
    LatihanHistoryModel history,
  ) async {
    try {
      final user = _currentUser;

      final document = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('histories')
          .add({
        ...history.toMap(),

        'userId': user.uid,

        'createdAt':
            FieldValue.serverTimestamp(),
      });

      debugPrint(
        'Riwayat berhasil disimpan: '
        '${document.id}',
      );

      return document.id;
    } catch (e) {
      debugPrint(
        'ERROR SAVE HISTORY: $e',
      );

      rethrow;
    }
  }

  // =====================================
  // AMBIL SEMUA RIWAYAT
  // =====================================

  Future<List<LatihanHistoryModel>>
      getHistories() async {
    try {
      final user = _currentUser;

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('histories')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .get();

      final histories = snapshot.docs
          .map(
            (doc) =>
                LatihanHistoryModel.fromMap(
              doc.id,
              doc.data(),
            ),
          )
          .toList();

      debugPrint(
        'Jumlah riwayat: '
        '${histories.length}',
      );

      return histories;
    } catch (e) {
      debugPrint(
        'ERROR GET HISTORIES: $e',
      );

      rethrow;
    }
  }

  // =====================================
  // HAPUS SATU RIWAYAT
  // =====================================

  Future<void> deleteHistory(
    String historyId,
  ) async {
    try {
      final user = _currentUser;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('histories')
          .doc(historyId)
          .delete();

      debugPrint(
        'Riwayat dihapus: $historyId',
      );
    } catch (e) {
      debugPrint(
        'ERROR DELETE HISTORY: $e',
      );

      rethrow;
    }
  }
}