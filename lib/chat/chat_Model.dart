import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreenModel {
  final String email;
  final String userId;

  ChatScreenModel({
    required this.email,
    required this.userId,
  });
}

class MessageModel {
  final String message;
  final String senderId;
  final String receiverId;
  final String senderEmail;
  final Timestamp timestamp;

  MessageModel({
    required this.message,
    required this.senderId,
    required this.timestamp,
    required this.receiverId,
    required this.senderEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderId': senderId,
      'timestamp': timestamp,
      'receiverId': receiverId,
      'senderEmail': senderEmail,
    };
  }
}