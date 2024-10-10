import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/models/chatroom_model.dart';

class ChatRoomServices {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<List<ChatRoomModel>> getChatRooms(String userId) {
    try {
      final docRef = db
          .collection('chatRooms')
          .where('participants', arrayContains: userId)
          .where('lastMessage', isNotEqualTo: '')
          .orderBy('lastUpdate', descending: true);

      // Mendapatkan stream dari query snapshot
      Stream<QuerySnapshot<Map<String, dynamic>>> query = docRef.snapshots();

      // Melakukan map dari QuerySnapshot ke List<ChatroomModel>
      final data = query.map((snapshot) => snapshot.docs.map((doc) {
            final String documentId = doc.id;
            return ChatRoomModel.fromJson(doc.data())
              ..documentId = documentId; // Konversi ke ChatroomModel
          }).toList());

      print("Connection successful.");

      // Mengembalikan stream berupa List<ChatroomModel>
      return data;
    } catch (e) {
      print("Error connecting to Firestore: $e");
      return const Stream.empty();
    }
  }

  Future<ChatRoomModel?> getChatRoom(String userId, String hospitalId) async {
    try {
      final docRef = db
          .collection('chatRooms')
          .where('participants', arrayContains: userId);

      QuerySnapshot query = await docRef.get();

      final chatRoomsDocs = query.docs.where((doc) {
        final participants = List<String>.from(doc['participants']);
        return participants.contains(hospitalId);
      });

      if (chatRoomsDocs.isNotEmpty) {
        final documentId = chatRoomsDocs.first.id;
        final data = chatRoomsDocs.first.data() as Map<String, dynamic>;
        return ChatRoomModel.fromJson(data)..documentId = documentId;
      } else {
        return null;
      }
    } catch (e) {
      print("Error connecting to Firestore: $e");
      return null;
    }
  }

  Future<ChatRoomModel?> createChatRoom(
      String userId, String hospitalId) async {
    try {
      final participantsList = [hospitalId, userId];
      final data = ChatRoomModel(
          lastMessage: '',
          lastParticipant: userId,
          isUserRead: false,
          isHospitalRead: false,
          lastUpdate: DateTime.now(),
          participants: participantsList);

      DocumentReference docRef =
          await db.collection('chatRooms').add(data.toJson());

      DocumentSnapshot snapshot = await docRef.get();
      String documentId = snapshot.id;

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return ChatRoomModel.fromJson(data)..documentId = documentId;
      } else {
        print('No data found for the created chat room');
        return null;
      }
    } catch (e) {
      print('Error creating chat room: $e');
      return null;
    }
  }

  Future<void> updateChatRoom(
      String message, String documentId, String userId) async {
    await db.collection('chatRooms').doc(documentId).update({
      'lastMessage': message,
      'lastParticipant': userId,
      'lastUpdate': DateTime.now(),
    });
  }

  Future<void> updateIsUserRead(String documentId) async {
    await db.collection('chatRooms').doc(documentId).update({
      'isUserRead': true,
    });
  }
}
