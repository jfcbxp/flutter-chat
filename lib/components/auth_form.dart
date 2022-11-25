import 'dart:io';

import 'package:chat/components/user_image_picker.dart';
import 'package:chat/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  const AuthForm({required this.onSubmit, super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _authFormData = AuthFormData();

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_authFormData.image == null && _authFormData.isSignup) {
      return _showError('Imagem não selecionada');
    }

    widget.onSubmit(_authFormData);
  }

  void _handleImagePick(File image) {
    _authFormData.image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_authFormData.isSignup)
                  UserimagePicker(
                    onImagePick: _handleImagePick,
                  ),
                if (_authFormData.isSignup)
                  TextFormField(
                    key: ValueKey('name'),
                    initialValue: _authFormData.name,
                    onChanged: (name) => _authFormData.name = name,
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: (_data) {
                      final data = _data ?? '';
                      if (data.trim().length < 5) {
                        return 'Nome deve ter no minimo 5 caracteres';
                      }
                    },
                  ),
                TextFormField(
                    key: ValueKey('email'),
                    initialValue: _authFormData.email,
                    onChanged: (email) => _authFormData.email = email,
                    decoration: InputDecoration(labelText: 'E-Mail'),
                    validator: (_data) {
                      final data = _data ?? '';
                      if (!data.contains('@')) {
                        return 'E-mail informado não é valido';
                      }
                    }),
                TextFormField(
                    key: ValueKey('password'),
                    initialValue: _authFormData.password,
                    onChanged: (password) => _authFormData.password = password,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Senha'),
                    validator: (_data) {
                      final data = _data ?? '';
                      if (data.trim().length < 6) {
                        return 'Senha deve ter no minimo 6 caracteres';
                      }
                    }),
                SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                    onPressed: _submit,
                    child:
                        Text(_authFormData.isLogin ? 'Entrar' : 'Cadastrar')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _authFormData.toggleAuthMode();
                      });
                    },
                    child: Text(_authFormData.isLogin
                        ? 'Criar uma nova conta?'
                        : 'Já possui conta?'))
              ],
            )),
      ),
    );
  }
}
