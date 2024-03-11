import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: Colors.blue[400],
      ),
      body: Column(
        children: [
          const Text(
              "Chúng tôi đã gửi email xác nhận tài khoản cho bạn. Hãy mở email và kiểm tra nó"),
          const Text(
              "Nếu bạn chưa nhận được email xác minh, hãy nhấn vào đây."),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(
                    const AuthEventSendVerification(),
                  );
            },
            child: const Text("Send Email Verification"),
          ),
          
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(
                    const AuthEventLogOut(),
                  );
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}
