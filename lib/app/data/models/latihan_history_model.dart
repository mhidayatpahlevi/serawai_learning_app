import 'package:cloud_firestore/cloud_firestore.dart';

import 'answer_history_model.dart';

class LatihanHistoryModel {
  final String id;
  final String userId;

  final String pantunId;
  final String pantunTitle;
  final String kategori;

  final int totalQuestions;
  final int correctCount;
  final int wrongCount;

  final double score;

  final List<AnswerHistoryModel> answers;

  final DateTime? createdAt;

  LatihanHistoryModel({
    this.id = '',
    this.userId = '',
    required this.pantunId,
    required this.pantunTitle,
    required this.kategori,
    required this.totalQuestions,
    required this.correctCount,
    required this.wrongCount,
    required this.score,
    required this.answers,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'pantunId':
          pantunId,

      'pantunTitle':
          pantunTitle,

      'kategori':
          kategori,

      'totalQuestions':
          totalQuestions,

      'correctCount':
          correctCount,

      'wrongCount':
          wrongCount,

      'score':
          score,

      'answers':
          answers
              .map(
                (answer) =>
                    answer.toMap(),
              )
              .toList(),
    };
  }

  factory LatihanHistoryModel.fromMap(
    String documentId,
    Map<String, dynamic> map,
  ) {
    final rawAnswers =
        map['answers'];

    final answers =
        <AnswerHistoryModel>[];

    if (rawAnswers is List) {
      for (final item in rawAnswers) {
        if (item is Map) {
          answers.add(
            AnswerHistoryModel.fromMap(
              Map<String, dynamic>.from(
                item,
              ),
            ),
          );
        }
      }
    }

    return LatihanHistoryModel(
      id:
          documentId,

      userId:
          map['userId']
                  ?.toString() ??
              '',

      pantunId:
          map['pantunId']
                  ?.toString() ??
              '',

      pantunTitle:
          map['pantunTitle']
                  ?.toString() ??
              '',

      kategori:
          map['kategori']
                  ?.toString() ??
              '',

      totalQuestions:
          map['totalQuestions']
                  is num
              ? (map['totalQuestions']
                      as num)
                  .toInt()
              : 0,

      correctCount:
          map['correctCount']
                  is num
              ? (map['correctCount']
                      as num)
                  .toInt()
              : 0,

      wrongCount:
          map['wrongCount']
                  is num
              ? (map['wrongCount']
                      as num)
                  .toInt()
              : 0,

      score:
          map['score'] is num
              ? (map['score'] as num)
                  .toDouble()
              : 0,

      answers:
          answers,

      createdAt:
          map['createdAt']
                  is Timestamp
              ? (map['createdAt']
                      as Timestamp)
                  .toDate()
              : null,
    );
  }
}