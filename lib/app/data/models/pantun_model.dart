class PantunModel {
  final String id;

  final String categoryId;
  final int orderInCategory;

  final String judul;
  final String kategori;
  final String level;

  final List<String> baris;
  final List<String> terjemahan;

  final String polaRima;

  final bool isActive;

  PantunModel({
    required this.id,
    required this.categoryId,
    required this.orderInCategory,
    required this.judul,
    required this.kategori,
    required this.level,
    required this.baris,
    required this.terjemahan,
    required this.polaRima,
    required this.isActive,
  });

  factory PantunModel.fromMap(
    String documentId,
    Map<String, dynamic> map,
  ) {
    return PantunModel(
      id: documentId,

      categoryId:
          map['categoryId']?.toString() ?? '',

      orderInCategory:
          map['orderInCategory'] is num
              ? (map['orderInCategory'] as num).toInt()
              : 0,

      judul:
          map['judul']?.toString() ?? '',

      kategori:
          map['kategori']?.toString() ?? '',

      level:
          map['level']?.toString() ?? '',

      baris: List<String>.from(
        map['baris'] ?? [],
      ),

      terjemahan: List<String>.from(
        map['terjemahan'] ?? [],
      ),

      polaRima:
          map['polaRima']?.toString() ?? '',

      isActive:
          map['isActive'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'orderInCategory': orderInCategory,
      'judul': judul,
      'kategori': kategori,
      'level': level,
      'baris': baris,
      'terjemahan': terjemahan,
      'polaRima': polaRima,
      'isActive': isActive,
    };
  }
}