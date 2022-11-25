import 'package:chat/models/chat_user.dart';
import 'package:chat/services/chat/chat_firebase_service.dart';

import '../../models/chat_message.dart';

abstract class ChatService {
  Stream<List<ChatMessage>> messagesStream();

  Future<ChatMessage?> save(String text, ChatUser user);

  factory ChatService() {
    return ChatFirebaseService();
  }
}
