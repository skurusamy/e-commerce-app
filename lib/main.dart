import 'package:e_commerce_app/screens/home/home_screen.dart';
import 'package:e_commerce_app/screens/login/auth/login_with_email_screen.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/services/auth_service.dart';
import '/blocs/auth/auth_bloc.dart';
import 'blocs/cart/cart_bloc.dart';
import 'blocs/wishlist/wishlist_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Map<String, dynamic> loggedInUserDetails = await AuthService().isUserLoggedIn();
  runApp(MyApp(loggedInUserDetails: loggedInUserDetails));
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final Map<String, dynamic> loggedInUserDetails;
  MyApp({required this.loggedInUserDetails});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(providers:[
      BlocProvider(create: (context) => AuthBloc(AuthService(), FirestoreService())),
      BlocProvider(create: (context) => WishlistBloc()), // Provide WishlistBloc here
      BlocProvider(create: (context) => CartBloc(userName: loggedInUserDetails['email']))
    ],
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
          child:  loggedInUserDetails.containsKey('isLoggedIn') &&
              loggedInUserDetails['isLoggedIn'] ? HomeScreen() : LoginWithEmailScreen(),
        ),
      ),
    );
  }
}
