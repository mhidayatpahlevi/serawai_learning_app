class VocabularyModel {
  final String id;
  final String pantunId;
  final String serawai;
  final String indonesia;
  final String keterangan;

  VocabularyModel({
    required this.id,
    required this.pantunId,
    required this.serawai,
    required this.indonesia,
    required this.keterangan,
  });

  factory VocabularyModel.fromMap(
    String documentId,
    Map<String, dynamic> map,
  ) {
    return VocabularyModel(
      id: documentId,
      pantunId:
          map['pantunId']?.toString() ?? '',
      serawai:
          map['serawai']?.toString() ?? '',
      indonesia:
          map['indonesia']?.toString() ?? '',
      keterangan:
          map['keterangan']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pantunId': pantunId,
      'serawai': serawai,
      'indonesia': indonesia,
      'keterangan': keterangan,
    };
  }
}