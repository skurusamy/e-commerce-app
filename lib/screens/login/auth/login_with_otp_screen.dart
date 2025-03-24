import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/auth/auth_bloc.dart';
import '../../../widgets/custom_text_field.dart';
import 'login_with_email_screen.dart';

class LoginWithOtpScreen extends StatelessWidget {
  LoginWithOtpScreen({super.key});
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome Back!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),

                  CustomTextFormField(
                      name: 'phone_num',
                      controller: phoneController, hintText: "Enter Phone Number"),
                  SizedBox(height: 10),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context).add(SendOtp(phoneController.text));
                        },
                        child: Text("Login with OTP"),
                      );
                    },
                  ),

                  SizedBox(height: 30,),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.login),
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context).add(SignInWithGoogle());
                        },
                        label: Text("Login with Google"),
                      ),
                      SizedBox(width: 10,),

                      ElevatedButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginWithEmailScreen()));
                      }, child: Text("Login with Email")),

                    ],
                  )
                ]
            )
        )
    );
  }
}
