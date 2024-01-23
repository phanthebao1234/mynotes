import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';
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
                  final userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  devtools.log(userCredential.toString());
                  devtools.log('Đăng nhập thành công');

                  // Nếu đăng nhập thành công sẽ quay về trang chủ
                  if (!context.mounted) return;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } on FirebaseAuthException catch (e) {
                  (e.code);
                  if (!context.mounted) return;
                  switch (e.code) {
                    case 'user-not-found':
                      await showErrorDialog(
                        context,
                        "User not found",
                      );
                      break;
                    case 'invalid-email':
                      await showErrorDialog(
                        context,
                        'Invalid email',
                      );
                      break;
                    case 'wrong-password':
                      await showErrorDialog(
                        context,
                        'Wrong password',
                      );
                      break;
                    case 'user-disabled':
                      await showErrorDialog(
                        context,
                        'User disabled',
                      );
                      break;
                    default:
                      await showErrorDialog(
                        context,
                        'Error: ${e.code}',
                      );
                  }
                } catch (e) {
                  await showErrorDialog(
                    context,
                    e.toString(),
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
