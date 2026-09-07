class CategoryModel {
  final String id;
  final int order;
  final String nama;
  final String description;
  final String level;
  final int totalPantun;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.order,
    required this.nama,
    required this.description,
    required this.level,
    required this.totalPantun,
    required this.isActive,
  });

  factory CategoryModel.fromMap(
    String documentId,
    Map<String, dynamic> map,
  ) {
    return CategoryModel(
      id: documentId,

      order: map['order'] is num
          ? (map['order'] as num).toInt()
          : 0,

      nama: map['nama']?.toString() ?? '',

      description:
          map['description']?.toString() ?? '',

      level: map['level']?.toString() ?? 'pemula',

      totalPantun: map['totalPantun'] is num
          ? (map['totalPantun'] as num).toInt()
          : 0,

      isActive: map['isActive'] == true,
    );
  }
}