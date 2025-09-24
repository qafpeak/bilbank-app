import 'dart:convert';
import 'user_information.dart';

class User {
  final String id;
  final String email;
  final String username;
  final bool isActive;
  final String firstName;
  final String lastName;
  final DateTime? birthDate;
  final String avatar;
  final double balance;
  final int triva;
  final int totalScore;
  final String? status;
  final String? deviceToken;
  final String? adminSettings;
  final String? resetPasswordToken;
  final DateTime? resetPasswordExpires;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserInformation? information;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.isActive,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.balance,
    required this.triva,
    required this.totalScore,
    this.status,
    this.deviceToken,
    this.adminSettings,
    this.resetPasswordToken,
    this.resetPasswordExpires,
    this.birthDate,
    this.createdAt,
    this.updatedAt,
    this.information,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'])?.toString() ?? '';
    final email = (json['email'] ?? '').toString();
    final username = (json['username'] ?? '').toString();
    final isActive = json['is_active'] is bool
        ? (json['is_active'] as bool)
        : json['is_active']?.toString().toLowerCase() == 'true';

    final firstName = (json['first_name'] ?? '').toString();
    final lastName = (json['last_name'] ?? '').toString();
    final avatar = (json['avatar'] ?? '').toString();
    final balance = (json['balance'] ?? 0).toDouble();
    final triva = (json['triva'] ?? 0).toInt();
    final totalScore = (json['total_score'] ?? 0).toInt();

    final status = json['status']?.toString();
    final deviceToken = json['device_token']?.toString();
    final adminSettings = json['admin_settings']?.toString();
    final resetPasswordToken = json['reset_password_token']?.toString();
    final resetPasswordExpires = json['reset_password_expires'] != null
        ? DateTime.tryParse(json['reset_password_expires'].toString())
        : null;

    final birthDate = json['birth_date'] != null
        ? DateTime.tryParse(json['birth_date'].toString())
        : null;

    final createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'].toString())
        : null;

    final updatedAt = json['updated_at'] != null
        ? DateTime.tryParse(json['updated_at'].toString())
        : null;

    final infoJson = json['information'];
    final info = (infoJson is Map<String, dynamic>)
        ? UserInformation.fromJson(infoJson)
        : null;

    return User(
      id: id,
      email: email,
      username: username,
      isActive: isActive,
      firstName: firstName,
      lastName: lastName,
      avatar: avatar,
      balance: balance,
      triva: triva,
      totalScore: totalScore,
      status: status,
      deviceToken: deviceToken,
      adminSettings: adminSettings,
      resetPasswordToken: resetPasswordToken,
      resetPasswordExpires: resetPasswordExpires,
      birthDate: birthDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      information: info,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'is_active': isActive,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
      'balance': balance,
      'triva': triva,
      'total_score': totalScore,
      'status': status,
      'device_token': deviceToken,
      'admin_settings': adminSettings,
      'reset_password_token': resetPasswordToken,
      'reset_password_expires': resetPasswordExpires?.toIso8601String(),
      'birth_date': birthDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      if (information != null) 'information': information!.toJson(),
    };
  }

  static User fromJsonString(String source) =>
      User.fromJson(json.decode(source) as Map<String, dynamic>);

  String toJsonString() => json.encode(toJson());
}
