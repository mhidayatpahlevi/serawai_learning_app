class UserModel {
  final String uid;
  final String nama;
  final String email;
  final String role;

  UserModel({
    required this.uid,
    required this.nama,
    required this.email,
    this.role = 'user',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nama': nama,
      'email': email,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
    );
  }
}