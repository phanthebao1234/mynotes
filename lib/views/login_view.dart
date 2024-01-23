import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:mynotes/firebase_options.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';

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
                  switch (e.code) {
                    case 'user-not-found':
                      devtools.log("Tài khoản không tồn tại");
                      break;
                    case 'invalid-email':
                      devtools.log('Email không hợp lệ');
                      break;
                    case 'wrong-password':
                      devtools.log('Sai mật khẩu');
                      break;
                    default:
                      devtools.log("Xuất hiện một lỗi nào đó");
                  }
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
