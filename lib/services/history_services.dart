import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/models/history_model.dart';

class HistoryServices {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<HistoryModel>> getHistories(String userId) async {
    final docRef =
        db.collection("histories").where("userId", isEqualTo: userId);
    QuerySnapshot query = await docRef.get();
    final data = query.docs.map((doc) {
      final String documentId = doc.id;
      return HistoryModel.fromFirebaseJson(doc.data() as Map<String, dynamic>)
        ..documentId = documentId;
    }).toList();
    return data;
  }

  Future createHistory(responseBody, userId) async {
    final jsonResponse = json.decode(responseBody);
    final data = HistoryModel.fromPythonJson(jsonResponse, userId);
    db.collection("histories").doc().set(data.toJson()).then((_) {
      return 'success';
    }).catchError((e) {
      return 'failed';
    });
  }

  Future deleteHistory(documentId) async {
    db.collection("histories").doc(documentId).delete().then((_) {
      return 'success';
    }).catchError((e) {
      return 'failed';
    });
  }
}
