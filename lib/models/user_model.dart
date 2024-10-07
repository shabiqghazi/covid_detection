import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? name, email, phone, address, birthDate, gender, role;
  String? documentId;
  final DateTime? createdAt;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.birthDate,
    this.gender,
    this.role,
    this.createdAt,
    this.documentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'birthDate': birthDate,
      'gender': gender,
      'role': role,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] != null
          ? json['name'] as String
          : '', // Jika name null, kosongkan
      email: json['email'] != null
          ? json['email'] as String
          : '', // Jika email null, kosongkan
      phone: json['phone'] != null
          ? json['phone'] as String
          : '', // Jika phone null, kosongkan
      address: json['address'] != null
          ? json['address'] as String
          : '', // Jika address null, kosongkan
      birthDate: json['birthDate'] != null
          ? json['birthDate'] as String
          : '', // Jika birthDate null, kosongkan
      gender: json['gender'] != null
          ? json['gender'] as String
          : '', // Jika gender null, kosongkan
      role: json['role'] != null
          ? json['role'] as String
          : '', // Jika role null, kosongkan
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(), // Jika createdAt null, gunakan waktu sekarang
    );
  }
}
