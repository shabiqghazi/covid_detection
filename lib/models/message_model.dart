import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final bool isRead;
  final String sender, text, type;
  final DateTime timestamp;
  String? dimension, size, dispersi;

  MessageModel({
    required this.isRead,
    required this.sender,
    required this.text,
    required this.type,
    required this.timestamp,
    this.dimension,
    this.size,
    this.dispersi,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      isRead: json['isRead'] ?? false,
      sender: json['sender'] ?? '',
      dimension: json['dimension'] ?? '',
      size: json['size'] ?? '',
      dispersi: json['dispersi'] ?? '',
      text: json['text'] ?? '',
      type: json['type'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toTextJson() {
    return {
      'isRead': isRead,
      'sender': sender,
      'type': type,
      'text': text,
      'timestamp': timestamp,
    };
  }

  Map<String, dynamic> toHistoryJson() {
    return {
      'isRead': isRead,
      'sender': sender,
      'dimension': dimension,
      'size': size,
      'dispersi': dispersi,
      'type': type,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
