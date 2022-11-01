import 'package:chat/models/chat_user.dart';
import 'dart:io';

import 'package:chat/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  @override
  // TODO: implement currentUser
  ChatUser? get currentUser => throw UnimplementedError();

  @override
  Future<void> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> signup(String nome, String email, String password, File image) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  // TODO: implement userChanges
  Stream<ChatUser?> get userChanges => throw UnimplementedError();
}
