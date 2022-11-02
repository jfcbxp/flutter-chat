import 'package:chat/components/messages.dart';
import 'package:chat/components/new_message.dart';
import 'package:chat/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                    value: 'Logout',
                    child: Container(
                      child: Row(children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Sair')
                      ]),
                    ))
              ],
              onChanged: (value) {
                if ((value) == 'logout') {
                  AuthService().logout();
                }
              })
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [Expanded(child: Messages()), NewMessage()],
        ),
      ),
    );
  }
}
