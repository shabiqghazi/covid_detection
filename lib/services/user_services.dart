import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/models/user_model.dart';

class UserServices {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future createUser(uid, email, name) async {
    final data = UserModel(
      name: name,
      email: email,
      phone: '',
      address: '',
      birthDate: '',
      geoPoint: '',
      gender: '',
      role: 'user',
      createdAt: DateTime.now().toString(),
    );

    db
        .collection("users")
        .doc(uid)
        .set(data.toJson())
        .onError((e, _) => print("Error writing document: $e"));
  }

  Future<UserModel?> getUserByUid(String uid) async {
    final docRef = db.collection("users").doc(uid);
    DocumentSnapshot doc = await docRef.get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } else {
      print('User not found');
      return null;
    }
  }
}
