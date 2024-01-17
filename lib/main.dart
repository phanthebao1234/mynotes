import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        backgroundColor: Colors.blue[400],
      ),
      body: FutureBuilder(
          // trong FutureBuiler sẽ có 2 thằng là future và builder
          // Trong đó futture: Tính toán bất đồng bộ mà trình tạo này hiện đang kết nối, có thể là rỗng. => nói chung là xử lý bất đồng bộ
          // TOD      builder: Chiến lược xây dựng hiện đang được người xây dựng này sử dụng. => Code giao diện thì đi vô đây
          future: Firebase.initializeApp( //khởi tạo firebase
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  print('You are a verified email');
                } else {
                  print('You are not a verified email');
                }

                print(user?.email);

                return const Text('Done');
              default:
                return const Text('Loading...');
            }
          }),
    );
  }
}
