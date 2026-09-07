class QuestionModel {
  final String id;
  final String pantunId;
  final int lineIndex;
  final String template;
  final String referenceAnswer;
  final List<String> options;
  final String targetRhyme;
  final String explanation;

  QuestionModel({
    required this.id,
    required this.pantunId,
    required this.lineIndex,
    required this.template,
    required this.referenceAnswer,
    required this.options,
    required this.targetRhyme,
    required this.explanation,
  });

  factory QuestionModel.fromMap(
    String documentId,
    Map<String, dynamic> map,
  ) {
    return QuestionModel(
      id: documentId,

      pantunId:
          map['pantunId']?.toString() ?? '',

      lineIndex:
          map['lineIndex'] is int
              ? map['lineIndex']
              : 0,

      template:
          map['template']?.toString() ?? '',

      referenceAnswer:
          map['referenceAnswer']?.toString() ?? '',

      options: List<String>.from(
        map['options'] ?? [],
      ),

      targetRhyme:
          map['targetRhyme']?.toString() ?? '',

      explanation:
          map['explanation']?.toString() ?? '',
    );
  }
}