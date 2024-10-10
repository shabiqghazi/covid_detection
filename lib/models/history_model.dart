import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String status, dimension, size, dispersi;
  final DateTime createdAt;
  String? userId, documentId;

  HistoryModel({
    this.documentId,
    required this.status,
    this.userId,
    required this.createdAt,
    required this.dimension,
    required this.size,
    required this.dispersi,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'userId': userId,
      'createdAt': createdAt,
      'dimension': dimension,
      'size': size,
      'dispersi': dispersi,
    };
  }

  factory HistoryModel.fromFirebaseJson(Map<String, dynamic> json) {
    return HistoryModel(
      status: json['status'],
      userId: json['userId'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      dimension: json['dimension'],
      size: json['size'],
      dispersi: json['dispersi'],
    );
  }

  factory HistoryModel.fromPythonJson(Map<String, dynamic> json, userId) {
    return HistoryModel(
      status: json['status'],
      userId: userId,
      createdAt: DateTime.now(),
      dimension: json['dimension'],
      size: json['size'],
      dispersi: json['dispersi'],
    );
  }
}
