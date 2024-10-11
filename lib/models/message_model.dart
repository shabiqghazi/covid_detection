import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String sender, text, type;
  final DateTime timestamp;
  String? dimension, size, dispersi, status;

  MessageModel({
    required this.sender,
    required this.text,
    required this.type,
    required this.timestamp,
    this.dimension,
    this.size,
    this.dispersi,
    this.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sender: json['sender'] ?? '',
      dimension: json['dimension'] ?? '',
      size: json['size'] ?? '',
      dispersi: json['dispersi'] ?? '',
      status: json['status'] ?? '',
      text: json['text'] ?? '',
      type: json['type'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toTextJson() {
    return {
      'sender': sender,
      'type': type,
      'text': text,
      'timestamp': timestamp,
    };
  }

  Map<String, dynamic> toHistoryJson() {
    return {
      'sender': sender,
      'dimension': dimension,
      'size': size,
      'dispersi': dispersi,
      'status': status,
      'type': type,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
