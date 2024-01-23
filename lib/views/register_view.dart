import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:mynotes/firebase_options.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
// trong FutureBuiler sẽ có 2 thằng là future và builder
// Trong đó futture: Tính toán bất đồng bộ mà trình tạo này hiện đang kết nối, có thể là rỗng. => nói chung là xử lý bất đồng bộ
// TOD      builder: Chiến lược xây dựng hiện đang được người xây dựng này sử dụng. => Code giao diện thì đi vô đây

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
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
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  if (!context.mounted) return;
                  final user = FirebaseAuth.instance.currentUser;
                  user?.sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on FirebaseAuthException catch (e) {
                  if (!context.mounted) return;
                  switch (e.code) {
                    case 'weak-password':
                      await showErrorDialog(
                        context,
                        'Weak password',
                      );
                      break;
                    case 'email-already-in-use':
                      await showErrorDialog(context, 'Email already in use,');
                      break;
                    case 'invalid-email':
                      await showErrorDialog(
                        context,
                        'Invalid email',
                      );
                    default:
                  }
                  if (!context.mounted) return;
                  await showErrorDialog(
                    context,
                    'Error: ${e.code}',
                  );
                  devtools.log(e.toString());
                } catch (e) {
                  await showErrorDialog(
                    context,
                    e.toString(),
                  );
                }
              },
              child: const Text("Register")),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Login account")),
          
        ]));
  }
}
