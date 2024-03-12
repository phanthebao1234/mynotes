// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

// bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

// dialog
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, "Weak password");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Invalid email");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Failed to register");
          } else if (state.exception is UserAlreadyInUseAuthException) {
            await showErrorDialog(context, "Email is already in use");
          }
        }
      },
      child: Scaffold(
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
              decoration: const InputDecoration(
                  hintText: 'Please input you password...'),
            ),
            TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(AuthEventRegister(
                        email,
                        password,
                      ));
                },
                child: const Text("Register")),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text("Login account")),
          ])),
    );
  }
}
