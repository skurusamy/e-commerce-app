import 'package:e_commerce_app/constants/app_texts.dart';
import 'package:e_commerce_app/screens/login/auth/reset_password_screen.dart';
import 'package:e_commerce_app/screens/login/auth/signup_screen.dart';
import 'package:e_commerce_app/widgets/custom_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../../constants/colors.dart';
import '../../../../blocs/auth/auth_bloc.dart';
import '../../../widgets/custom_text_field.dart';
import '../../home/home_screen.dart';

class LoginWithEmailScreen extends StatelessWidget {
  final _loginFormKey = GlobalKey<FormBuilderState>();

  LoginWithEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FormBuilder(
          key: _loginFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome Back!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              /// 🔹 Email & Password Login
              CustomTextFormField(
                  name: 'email',
                  hintText: "Enter Email",
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ])),
              SizedBox(height: 10),
              CustomPasswordField(
                labelText: 'Enter Password',
                name: 'password',
                validator: FormBuilderValidators.required(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 210),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen()),
                    );
                  },
                  child: Text('Reset Password'),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_loginFormKey.currentState!.saveAndValidate()) {
                    var formData = _loginFormKey.currentState?.value;
                    var email = formData?['email'];
                    context.read<AuthBloc>().add(
                          SignInWithEmail(
                              formData?['email'], formData?['password']),
                        );
                    _loginFormKey.currentState?.reset();
                    if (context.read<AuthBloc>().state is AuthSuccess) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }
                  }
                },
                child: Text("Login with Email"),
              ),
              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 🔹 Google Sign-In Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton.icon(
                        icon: Icon(Icons.login),
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(SignInWithGoogle());
                        },
                        label: Text("Login with Google"),
                      );
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),

                  /// 🔹 Phone Number Login
                  /*ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginWithOtpScreen()));
                      },
                      child: Text("Login with OTP")),*/
                ],
              ),

              SizedBox(
                height: 30,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppText.newUser),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: CustomColor.linkColor),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
