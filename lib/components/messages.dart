import 'package:chat/components/message_bubble.dart';
import 'package:chat/models/chat_message.dart';
import 'package:chat/services/auth/auth_service.dart';
import 'package:chat/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    return StreamBuilder<List<ChatMessage>>(
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('Sem dados'),
          );
        } else {
          final msgs = snapshot.data!;

          return ListView.builder(
              reverse: true,
              itemCount: msgs.length,
              itemBuilder: (ctx, i) => MessageBubble(
                    key: ValueKey(msgs[i].id),
                    message: msgs[i],
                    belongsToCurrentUser: currentUser?.id == msgs[i].userId,
                  ));
        }
      }),
      stream: ChatService().messagesStream(),
    );
  }
}
