class AnswerHistoryModel {
  final String questionId;

  final int lineIndex;

  final String selectedAnswer;
  final String referenceAnswer;

  final double semanticScore;
  final double contextScore;
  final double rhymeScore;
  final double finalScore;

  final bool isCorrect;

  final String explanation;

  AnswerHistoryModel({
    required this.questionId,
    required this.lineIndex,
    required this.selectedAnswer,
    required this.referenceAnswer,
    required this.semanticScore,
    required this.contextScore,
    required this.rhymeScore,
    required this.finalScore,
    required this.isCorrect,
    required this.explanation,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionId':
          questionId,

      'lineIndex':
          lineIndex,

      'selectedAnswer':
          selectedAnswer,

      'referenceAnswer':
          referenceAnswer,

      'semanticScore':
          semanticScore,

      'contextScore':
          contextScore,

      'rhymeScore':
          rhymeScore,

      'finalScore':
          finalScore,

      'isCorrect':
          isCorrect,

      'explanation':
          explanation,
    };
  }

  factory AnswerHistoryModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return AnswerHistoryModel(
      questionId:
          map['questionId']
                  ?.toString() ??
              '',

      lineIndex:
          map['lineIndex'] is int
              ? map['lineIndex'] as int
              : 0,

      selectedAnswer:
          map['selectedAnswer']
                  ?.toString() ??
              '',

      referenceAnswer:
          map['referenceAnswer']
                  ?.toString() ??
              '',

      semanticScore:
          (map['semanticScore']
                      as num?)
                  ?.toDouble() ??
              0,

      contextScore:
          (map['contextScore']
                      as num?)
                  ?.toDouble() ??
              0,

      rhymeScore:
          (map['rhymeScore']
                      as num?)
                  ?.toDouble() ??
              0,

      finalScore:
          (map['finalScore']
                      as num?)
                  ?.toDouble() ??
              0,

      isCorrect:
          map['isCorrect'] ==
              true,

      explanation:
          map['explanation']
                  ?.toString() ??
              '',
    );
  }
}