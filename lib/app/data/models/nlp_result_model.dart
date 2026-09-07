class NlpResultModel {
  final double semanticScore;
  final double contextScore;
  final double rhymeScore;
  final double finalScore;

  final bool isCorrect;

  final String explanation;

  NlpResultModel({
    required this.semanticScore,
    required this.contextScore,
    required this.rhymeScore,
    required this.finalScore,
    required this.isCorrect,
    required this.explanation,
  });

  factory NlpResultModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return NlpResultModel(
      semanticScore:
          (map['semanticScore'] as num?)
                  ?.toDouble() ??
              0,

      contextScore:
          (map['contextScore'] as num?)
                  ?.toDouble() ??
              0,

      rhymeScore:
          (map['rhymeScore'] as num?)
                  ?.toDouble() ??
              0,

      finalScore:
          (map['finalScore'] as num?)
                  ?.toDouble() ??
              0,

      isCorrect:
          map['isCorrect'] == true,

      explanation:
          map['explanation']
                  ?.toString() ??
              '',
    );
  }
}