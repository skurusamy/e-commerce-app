import 'package:e_commerce_app/screens/login/auth/login_with_email_screen.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/services/auth_service.dart';
import '/blocs/auth/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthService(), FirestoreService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldMessengerKey,
        // Assign key to handle snackbars
        home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure ) {
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: LoginWithEmailScreen(),
        ),
      ),
    );
  }
}
