import 'dart:html';

enum AuthMode { SIGNUP, LOGIN }

class AuthFormData {
  String name = '';
  String email = '';
  String password = '';
  File? image;
  AuthMode _mode = AuthMode.LOGIN;

  bool get isLogin {
    return _mode == AuthMode.LOGIN;
  }

  bool get isSignup {
    return _mode == AuthMode.SIGNUP;
  }

  void toggleAuthMode() {
    _mode = isLogin ? AuthMode.SIGNUP : AuthMode.LOGIN;
  }
}
