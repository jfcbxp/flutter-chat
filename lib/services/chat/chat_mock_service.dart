import 'dart:math';

import 'package:chat/models/chat_user.dart';
import 'package:chat/models/chat_message.dart';
import 'package:chat/services/chat/chat_service.dart';
import 'dart:async';

class ChatMockService implements ChatService {
  static final List<ChatMessage> _msgs = [
    ChatMessage(
        id: '1',
        text: 'teste',
        createdAt: DateTime.now(),
        userId: '1',
        userName: 'teste',
        userImageUrl: 'assets/images/avatar.png'),
    ChatMessage(
        id: '2',
        text: 'teste2',
        createdAt: DateTime.now(),
        userId: '2',
        userName: 'teste2',
        userImageUrl: 'assets/images/avatar.png'),
  ];
  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgsStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    _controller?.add(_msgs);
  });

  @override
  Stream<List<ChatMessage>> messagesStream() {
    return _msgsStream;
  }

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final newMessage = ChatMessage(
        id: Random().nextDouble().toString(),
        text: text,
        createdAt: DateTime.now(),
        userId: user.id,
        userName: user.name,
        userImageUrl: user.imageUrl);

    _msgs.add(newMessage);

    _controller?.add(_msgs);

    return newMessage;
  }
}
