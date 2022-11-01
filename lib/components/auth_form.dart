import 'package:chat/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _authFormData = AuthFormData();

  void _submit() {
    _formKey.currentState?.validate();
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
                  TextFormField(
                    key: ValueKey('name'),
                    initialValue: _authFormData.name,
                    onChanged: (name) => _authFormData.name = name,
                    decoration: InputDecoration(labelText: 'Nome'),
                  ),
                TextFormField(
                  key: ValueKey('email'),
                  decoration: InputDecoration(labelText: 'E-Mail'),
                ),
                TextFormField(
                  key: ValueKey('password'),
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Senha'),
                ),
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
