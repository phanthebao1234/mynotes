// import 'package:bloc/bloc.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/helpers/loading/loading_screen.dart';
// import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/forgot_password_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email.dart';
import "dart:developer" as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FireBaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      // loginRoute: (context) => const LoginView(),
      // registerRoute: (context) => const RegisterView(),
      // '/logout': (context) => const LogoutView(),
      // notesRoute: (context) => const NotesView(),
      // verifyEmailRoute: (context) => const VerifyEmailView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

enum MenuAction { logout, settings }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        devtools.log(state.toString());
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } 
        else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CouterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Hello world"),
//         ),
//         body: BlocConsumer<CouterBloc, CouterState>(
//           builder: (context, state) {
//             final invalidValue =
//                 (state is CouterStateInvalidNumber ? state.invalidValue : '');
//             return Column(
//               children: [
//                 Text("Current value => ${state.value}"),
//                 Visibility(
//                   visible: state is CouterStateInvalidNumber,
//                   child: Text("Invalid input => ${state.value}"),
//                 ),
//                 TextField(
//                   controller: _controller,
//                   decoration: const InputDecoration(
//                     hintText: 'Enter input here ...',
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 Row(
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         context
//                             .read<CouterBloc>()
//                             .add(IncrementEvent(_controller.text));
//                       },
//                       child: const Text('+'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         context
//                             .read<CouterBloc>()
//                             .add(DecrementEvent(_controller.text));
//                       },
//                       child: const Text('-'),
//                     )
//                   ],
//                 )
//               ],
//             );
//           },
//           listener: ((context, state) {
//             _controller.clear();
//           }),
//         ),
//       ),
//     );
//   }
// }

// @immutable
// abstract class CouterState {
//   final int value;
//   const CouterState(this.value);
// }

// class CouterStateValid extends CouterState {
//   const CouterStateValid(super.value);
// }

// class CouterStateInvalidNumber extends CouterState {
//   final String invalidValue;
//   const CouterStateInvalidNumber({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }

// @immutable
// abstract class CouterEvent {
//   final String value;
//   const CouterEvent(this.value);
// }

// class IncrementEvent extends CouterEvent {
//   const IncrementEvent(super.value);
// }

// class DecrementEvent extends CouterEvent {
//   const DecrementEvent(super.value);
// }

// class CouterBloc extends Bloc<CouterEvent, CouterState> {
//   CouterBloc() : super(const CouterStateValid(0)) {
//     on<IncrementEvent>((event, emit) {
//       final interger = int.tryParse(event.value);
//       if (interger == null) {
//         emit(
//           CouterStateInvalidNumber(
//             invalidValue: event.value,
//             previousValue: state.value,
//           ),
//         );
//       } else {
//         emit(CouterStateValid(state.value + interger));
//       }
//     });
//     on<DecrementEvent>((event, emit) {
//       final interger = int.tryParse(event.value);
//       if (interger == null) {
//         emit(
//           CouterStateInvalidNumber(
//             invalidValue: event.value,
//             previousValue: state.value,
//           ),
//         );
//       } else {
//         emit(CouterStateValid(state.value - interger));
//       }
//     });
//   }
// }
