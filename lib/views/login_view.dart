// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _HomePageState();
}

class _HomePageState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  // Khởi tạo
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

// Hủy bỏ
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
// => Phải đi 1 cặp

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          backgroundColor: Colors.blue[400],
        ),
        body: Column(children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Please input you email...'),
          ),
          TextField(
            controller: _password,
            obscureText: true, // Cái này là ẩn mật khẩu
            enableSuggestions:
                false, // Cái này là hiện đề xuất, mặc định là true
            autocorrect: false, // tính năng sửa lỗi
            // Thông thường ta sẽ dùng 3 cái trên cho password
            decoration:
                const InputDecoration(hintText: 'Please input you password...'),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (route) => false,
                    );
                  }
                } on UserNotFoundException {
                  await showErrorDialog(
                        context,
                        "User not found",
                      );
                } on WrongPasswordException {
                  await showErrorDialog(
                        context,
                        'Wrong password',
                      );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                        context,
                        'Invalid email',
                      );
                } on UserDisabledException {
                  await showErrorDialog(
                        context,
                        'User disabled',
                      );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Authentication error',
                  );
                }
              },
              child: const Text("Login")),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text(
                'Not registered yet ? Register here!',
                selectionColor: Color.fromARGB(255, 11, 137, 240),
                style: TextStyle(fontStyle: FontStyle.italic),
              ))
        ]));
  }
}
