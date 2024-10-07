import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final bool isRead;
  final String sender, text;
  final DateTime timestamp;

  MessageModel({
    required this.isRead,
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      isRead: json['isRead'] ?? false,
      sender: json['sender'] ?? '',
      text: json['text'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isRead': isRead,
      'sender': sender,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
