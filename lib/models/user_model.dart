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
      name: json['name'] != null ? json['name'] as String : '',
      email: json['email'] != null ? json['email'] as String : '',
      phone: json['phone'] != null ? json['phone'] as String : '',
      address: json['address'] != null ? json['address'] as String : '',
      birthDate: json['birthDate'] != null ? json['birthDate'] as String : '',
      gender: json['gender'] != null ? json['gender'] as String : '',
      role: json['role'] != null ? json['role'] as String : '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
