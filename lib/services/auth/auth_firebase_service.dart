import 'package:chat/models/chat_user.dart';
import 'dart:io';
import 'dart:async';
import 'package:chat/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
      String name, String email, String password, File? image) async {
    final signup = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );

    final auth = FirebaseAuth.instanceFor(app: signup);

    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      final imageName = '${credential.user!.uid}.jpg';
      final imageUrl = await _uploadUserImage(image, imageName);
      await credential.user?.updateDisplayName(name);
      await credential.user?.updatePhotoURL(imageUrl);
      await login(email, password);
      _currentUser = _toChatUser(credential.user!, name, imageUrl);
      await _saveChatUser(_currentUser!);
    }

    await signup.delete();
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);
    await imageRef.putFile(image).whenComplete(() async {
      return await imageRef.getDownloadURL();
    });
  }

  Future<void> _saveChatUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);
    return docRef.set(
        {'name': user.name, 'email': user.email, 'imageURL': user.imageUrl});
  }

  static ChatUser _toChatUser(User user, [String? name, String? imageUrl]) {
    return ChatUser(
        id: user.uid,
        name: name ?? user.displayName ?? user.email!.split('@')[0],
        email: user.email!,
        imageUrl: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png');
  }

  @override
  // TODO: implement userChanges
  Stream<ChatUser?> get userChanges => _userStream;
}
