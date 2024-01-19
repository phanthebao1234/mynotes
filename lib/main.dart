import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      // '/logout': (context) => const LogoutView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // trong FutureBuiler sẽ có 2 thằng là future và builder
        // Trong đó futture: Tính toán bất đồng bộ mà trình tạo này hiện đang kết nối, có thể là rỗng. => nói chung là xử lý bất đồng bộ
        // TOD      builder: Chiến lược xây dựng hiện đang được người xây dựng này sử dụng. => Code giao diện thì đi vô đây
        future: Firebase.initializeApp(
          //khởi tạo firebase
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  print("Email is verified");
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
              return const Text('Done');
            // return const LoginView();
            // if (user?.emailVerified ?? false) {
            //   return const Text('Done');
            // } else {
            //   print(user);
            //   return const VerifyEmailView();
            // }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
