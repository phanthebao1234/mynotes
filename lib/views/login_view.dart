// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
// import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/loading_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _HomePageState();
}

class _HomePageState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;
          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialogHandle = showLoadingDialog(
              context: context,
              text: "Loading...",
            );
          }
          if (state.exception is UserNotFoundException) {
            await showErrorDialog(
              context,
              "user not found",
            );
          } else if (state.exception is WrongPasswordException) {
            await showErrorDialog(
              context,
              "Wrong credentials",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              "Authentication error",
            );
          }
        }
      },
      child: Scaffold(
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
              decoration: const InputDecoration(
                  hintText: 'Please input you password...'),
            ),
            TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );
                },
                child: const Text("Login")),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShoutRegister());
                },
                child: const Text(
                  'Not registered yet ? Register here!',
                  selectionColor: Color.fromARGB(255, 11, 137, 240),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ))
          ])),
    );
  }
}
