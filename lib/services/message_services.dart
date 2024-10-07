import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/models/message_model.dart';

class MessageServices {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    try {
      final docRef = db
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true);

      Stream<QuerySnapshot<Map<String, dynamic>>> query = docRef.snapshots();

      final data = query.map((snapshot) => snapshot.docs.map((doc) {
            return MessageModel.fromJson(doc.data());
          }).toList());

      return data;
    } catch (e) {
      print("Error fetching messages: $e");
      return const Stream.empty();
    }
  }

  Future<void> addMessage(text, userId, chatRoomId) async {
    final data = MessageModel(
      isRead: false,
      sender: userId,
      text: text,
      timestamp: DateTime.now(),
    );

    db
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(data.toJson());
  }
}
