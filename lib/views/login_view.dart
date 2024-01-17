import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

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
        title: const Text("Login"),
        backgroundColor: Colors.blue[400],
      ),
      body: FutureBuilder(
          // trong FutureBuiler sẽ có 2 thằng là future và builder
          // Trong đó futture: Tính toán bất đồng bộ mà trình tạo này hiện đang kết nối, có thể là rỗng. => nói chung là xử lý bất đồng bộ
          // TOD      builder: Chiến lược xây dựng hiện đang được người xây dựng này sử dụng. => Code giao diện thì đi vô đây
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: 'Please input you email...'),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true, // Cái này là ẩn mật khẩu
                    enableSuggestions:
                        false, // Cái này là hiện đề xuất, mặc định là true
                    autocorrect: false, // tính năng sửa lỗi
                    // Thông thường ta sẽ dùng 3 cái trên cho password
                    decoration: const InputDecoration(
                        hintText: 'Please input you password...'),
                  ),
                  TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          print(userCredential);
                          print('Đăng nhập thành công');
                        } on FirebaseAuthException catch (e) {
                          print(e.code);
                          switch (e.code) {
                            case 'user-not-found':
                              print("Tài khoản không tồn tại");
                              break;
                            case 'invalid-email':
                              print('Email không hợp lệ');
                              break;
                            case 'wrong-password':
                              print('Sai mật khẩu');
                              break;
                            default:
                              print("Xuất hiện một lỗi nào đó");
                          }
                        }
                      },
                      child: const Text("Login")),
                ]);
              default:
                return const Text('Loading...');
            }
          }),
    );
  }
}
