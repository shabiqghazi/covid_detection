import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final List<String> participants;
  final String lastMessage, lastParticipant;
  final bool isUserRead, isHospitalRead;
  final DateTime lastUpdate;
  String? documentId;

  ChatRoomModel({
    required this.lastMessage,
    required this.lastParticipant,
    required this.isUserRead,
    required this.isHospitalRead,
    required this.lastUpdate,
    required this.participants,
    this.documentId,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: json['lastMessage'] ?? '',
      lastParticipant: json['lastParticipant'],
      isUserRead: json['isUserRead'],
      isHospitalRead: json['isHospitalRead'],
      lastUpdate: (json['lastUpdate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'lastParticipant': lastParticipant,
      'isUserRead': isUserRead,
      'isHospitalRead': isHospitalRead,
      'lastMessage': lastMessage,
      'lastUpdate': lastUpdate,
    };
  }
}
