import 'dart:convert';

class UserInformation {
  final String id;          // Mongo _id (UserInformation dokümanının id'si)
  final String userId;      // User._id referansı
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserInformation({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.createdAt,
    this.updatedAt,
  });

  UserInformation copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserInformation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    // Bazı API'ler id için "_id" veya "id" kullanabilir
    final infoId = (json['_id'] ?? json['id'])?.toString() ?? '';
    final userId = (json['user'] ?? json['user_id'] ?? '').toString();

    return UserInformation(
      id: infoId,
      userId: userId,
      firstName: (json['first_name'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
      birthDate: DateTime.parse(json['birth_date'].toString()),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // istemci tarafında id döndürmek yeterli
      'user': userId,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate.toIso8601String(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  static UserInformation fromJsonString(String source) =>
      UserInformation.fromJson(json.decode(source) as Map<String, dynamic>);

  String toJsonString() => json.encode(toJson());
}
