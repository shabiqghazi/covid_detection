import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String diseaseType, hospitalId, userId, status;
  final GeoPoint place;
  final DateTime createdAt;
  String? documentId;

  ReportModel({
    required this.diseaseType,
    required this.hospitalId,
    required this.userId,
    required this.status,
    required this.place,
    required this.createdAt,
    this.documentId,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      diseaseType: json['diseaseType'],
      hospitalId: json['hospitalId'],
      userId: json['userId'],
      status: json['status'],
      place: json['place'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diseaseType': diseaseType,
      'hospitalId': hospitalId,
      'userId': userId,
      'status': status,
      'place': place,
      'createdAt': createdAt,
    };
  }
}
