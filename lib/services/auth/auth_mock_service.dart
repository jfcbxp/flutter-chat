import 'dart:math';

import 'package:chat/models/chat_user.dart';
import 'dart:io';
import 'dart:async';

import 'package:chat/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  static final _defaultUser = ChatUser(
      id: '1',
      name: 'teste',
      email: 'teste@teste.com',
      imageUrl: 'assets/images/avatar.png');
  static Map<String, ChatUser> _users = {_defaultUser.email: _defaultUser};
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(_defaultUser);

    controller.add(_currentUser);
  });

  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(user);
  }

  @override
  // TODO: implement currentUser
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Future<void> login(String email, String password) async {
    _updateUser(_users[email]);
  }

  @override
  Future<void> logout() async {
    _updateUser(null);
  }

  @override
  Future<void> signup(
      String nome, String email, String password, File? image) async {
    final newUser = ChatUser(
        id: Random().nextDouble().toString(),
        name: nome,
        email: email,
        imageUrl: image?.path ?? 'assets/images/avatar.png');

    _users.putIfAbsent(email, () => newUser);

    _updateUser(newUser);
  }

  @override
  // TODO: implement userChanges
  Stream<ChatUser?> get userChanges => _userStream;
}
