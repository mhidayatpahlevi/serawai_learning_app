import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryProgressModel {
  final String categoryId;
  final int categoryOrder;

  final List<String> completedPantunIds;

  final Map<String, double> bestScores;

  final bool completed;

  final DateTime? completedAt;
  final DateTime? updatedAt;

  CategoryProgressModel({
    required this.categoryId,
    required this.categoryOrder,
    required this.completedPantunIds,
    required this.bestScores,
    required this.completed,
    this.completedAt,
    this.updatedAt,
  });

  factory CategoryProgressModel.fromMap(
    Map<String, dynamic> map,
  ) {
    final rawScores =
        map['bestScores'] as Map<String, dynamic>? ?? {};

    return CategoryProgressModel(
      categoryId:
          map['categoryId']?.toString() ?? '',

      categoryOrder:
          map['categoryOrder'] is num
              ? (map['categoryOrder'] as num).toInt()
              : 0,

      completedPantunIds:
          List<String>.from(
        map['completedPantunIds'] ?? [],
      ),

      bestScores: rawScores.map(
        (key, value) => MapEntry(
          key,
          value is num
              ? value.toDouble()
              : 0,
        ),
      ),

      completed:
          map['completed'] == true,

      completedAt:
          map['completedAt'] is Timestamp
              ? (map['completedAt'] as Timestamp)
                  .toDate()
              : null,

      updatedAt:
          map['updatedAt'] is Timestamp
              ? (map['updatedAt'] as Timestamp)
                  .toDate()
              : null,
    );
  }
}