import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/models/user_model.dart';

class UserServices {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<UserModel> getUserByUid(String uid) async {
    final docRef = db.collection("users").doc(uid);
    DocumentSnapshot doc = await docRef.get();
    final String documentId = doc.id;
    return UserModel.fromJson(doc.data() as Map<String, dynamic>)
      ..documentId = documentId;
  }

  Future createUser(uid, email, name) async {
    final data = UserModel(
      name: name,
      email: email,
      phone: '',
      address: '',
      birthDate: '',
      gender: '',
      role: 'user',
      createdAt: DateTime.now(),
    );

    db.collection("users").doc(uid).set(data.toJson()).then((_) {
      return 'success';
    }).catchError((e) {
      return 'failed';
    });
  }

  Future updateUser(
      uid, email, name, phone, address, birthDate, gender, createdAt) async {
    final data = UserModel(
      name: name,
      email: email,
      phone: phone,
      address: address,
      birthDate: birthDate,
      gender: gender,
      role: 'user',
      createdAt: createdAt,
    );

    db.collection("users").doc(uid).set(data.toJson()).then((_) {
      return 'success';
    }).catchError((e) {
      return 'failed';
    });
  }
}
