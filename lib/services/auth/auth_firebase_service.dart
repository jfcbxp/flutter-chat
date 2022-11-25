import 'dart:math';

import 'package:chat/models/chat_user.dart';
import 'dart:io';
import 'dart:async';

import 'package:chat/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  @override
  // TODO: implement currentUser
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> signup(
      String nome, String email, String password, File? image) async {
    final auth = FirebaseAuth.instance;
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (credential.user == null) return;

    credential.user?.updateDisplayName(nome);

    //credential.user?.updatePhotoURL(photoURL);
  }

  static ChatUser _toChatUser(User user) {
    return ChatUser(
        id: user.uid,
        name: user.displayName ?? user.email!.split('@')[0],
        email: user.email!,
        imageUrl: user.photoURL ?? 'assets/images/avatar.png');
  }

  @override
  // TODO: implement userChanges
  Stream<ChatUser?> get userChanges => _userStream;
}
