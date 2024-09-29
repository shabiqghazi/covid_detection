import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalModel {
  final String name, address;
  final String? documentId;
  final GeoPoint geoPoint;

  HospitalModel({
    this.documentId,
    required this.name,
    required this.address,
    required this.geoPoint,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      name: json['name'] as String,
      address: json['address'] as String,
      geoPoint: json['geoPoint'] as GeoPoint,
    );
  }
}
