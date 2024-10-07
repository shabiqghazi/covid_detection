import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/models/report_model.dart';

class ReportServices {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> createReport(userId, hospitalId, place) async {
    final data = ReportModel(
      diseaseType: 'Covid 19',
      hospitalId: hospitalId,
      userId: userId,
      status: 'Belum Diterima',
      place: place,
      createdAt: DateTime.now(),
    );

    try {
      await db.collection('reports').add(data.toJson());
    } catch (e) {
      print('Error createReport: $e');
    }
  }

  Future<ReportModel?> getReport(String userId, String hospitalId) async {
    final docRef = db
        .collection('reports')
        .where('userId', isEqualTo: userId)
        .where('hospitalId', isEqualTo: hospitalId);

    QuerySnapshot query = await docRef.get();
    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      final String documentId = doc.id;
      final data = ReportModel.fromJson(doc.data() as Map<String, dynamic>)
        ..documentId = documentId;

      return data;
    } else {
      return null;
    }
  }
}
