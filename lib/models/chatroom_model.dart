import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final List<String> participants;
  final String lastMessage;
  final DateTime lastUpdate;
  String? documentId;

  ChatRoomModel({
    required this.lastMessage,
    required this.lastUpdate,
    required this.participants,
    this.documentId,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: json['lastMessage'] ?? '',
      lastUpdate: (json['lastUpdate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastUpdate': lastUpdate,
    };
  }
}
