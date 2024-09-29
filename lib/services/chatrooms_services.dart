import 'package:cloud_firestore/cloud_firestore.dart';

class ChatroomsServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  dynamic getChatRoomList(userId) {
    try {
      print("Attempting to connect to Firestore...");
      Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot = _firestore
          .collection('chatRooms')
          .where('participants', arrayContains: userId)
          .snapshots();
      print("Connection successful.");
      // List to hold combined data (test_history + user)
      return querySnapshot;
    } catch (e) {
      print("Error connecting to Firestore: $e");
    }
    // Get data from docs and convert them to List
    return [];
  }
}
