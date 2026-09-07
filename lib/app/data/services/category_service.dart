import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<List<CategoryModel>>
      getActiveCategories() async {
    try {
      final snapshot = await _firestore
          .collection('categories')
          .where(
            'isActive',
            isEqualTo: true,
          )
          .get();

      final categories = snapshot.docs
          .map(
            (doc) => CategoryModel.fromMap(
              doc.id,
              doc.data(),
            ),
          )
          .toList();

      categories.sort(
        (a, b) => a.order.compareTo(
          b.order,
        ),
      );

      debugPrint(
        'Jumlah kategori: '
        '${categories.length}',
      );

      return categories;
    } catch (e) {
      debugPrint(
        'ERROR GET CATEGORIES: $e',
      );

      rethrow;
    }
  }
}