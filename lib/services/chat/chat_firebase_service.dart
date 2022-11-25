import 'package:chat/models/chat_user.dart';
import 'package:chat/models/chat_message.dart';
import 'package:chat/services/chat/chat_service.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    return Stream<List<ChatMessage>>.empty();
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    final docRef = await store.collection('chat').add({
      'text': text,
      'createdAt': DateTime.now().toIso8601String(),
      'userId': user.id,
      'userName': user.name,
      'userImageUrl': user.imageUrl,
    });

    final doc = await docRef.get();
    final data = doc.data()!;

    return ChatMessage(
        id: doc.id,
        text: data['text'],
        createdAt: DateTime.parse(data['createdAt']),
        userId: data['userId'],
        userName: data['userName'],
        userImageUrl: data['userImageUrl']);
  }
}
