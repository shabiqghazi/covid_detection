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

  Future<void> addTextMessage(text, userId, chatRoomId) async {
    final data = MessageModel(
      isRead: false,
      sender: userId,
      type: 'text',
      text: text,
      timestamp: DateTime.now(),
    );

    db
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(data.toTextJson());
  }

  Future<void> addHistoryMessage(
      dimension, size, dispersi, userId, chatRoomId) async {
    final data = MessageModel(
      isRead: false,
      sender: userId,
      dimension: dimension,
      size: size,
      dispersi: dispersi,
      type: 'history',
      text: '',
      timestamp: DateTime.now(),
    );

    db
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(data.toHistoryJson());
  }
}
