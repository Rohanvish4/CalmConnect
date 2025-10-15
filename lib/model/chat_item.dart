import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String docId;
  final String chatByUID;
  final String itemId;
  final String message;
  final DateTime createdAt;

  Message({
    required this.docId,
    required this.chatByUID,
    required this.itemId,
    required this.message,
    required this.createdAt,
  });

  // Factory constructor to create a Message object from a Firestore document
  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      docId: data['docId'] ?? '',
      chatByUID: data['chatByUID'] ?? '',
      itemId: data['itemId'] ?? '',
      message: data['message'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Method to convert a Message object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'docId': docId,
      'chatByUID': chatByUID,
      'itemId': itemId,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
