import 'package:e_commerce_app/screens/login/auth/login_with_email_screen.dart';
import 'package:e_commerce_app/screens/login/auth/set_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  final _signUpFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: FormBuilder(
              key: _signUpFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome !",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  CustomTextFormField(
                      name: 'name',
                      hintText: "Enter Name",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.alphabetical(),
                      ])),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                      name: 'age',
                      hintText: "Enter Age",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                      ])),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                      name: 'phone_number',
                      hintText: "Enter Phone number",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                      ])),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                      name: 'email',
                      hintText: "Enter Email",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ])),
                  SizedBox(
                    height: 30,
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (_signUpFormKey.currentState!.saveAndValidate()) {
                            var formData = _signUpFormKey.currentState?.value;
                            try {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(Register(formData!));
                              _signUpFormKey.currentState?.reset();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SetPasswordScreen(email: formData['email'],)));
                            } catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Error"),
                                        content: Text(e.toString()),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text("Ok"))
                                        ],
                                      ));
                            }
                          }
                        },
                        child: Text("Sign up"),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LoginWithEmailScreen()));
                          },
                          child: Text("Login"))
                    ],
                  )
                ],
              ))),
    );
  }
}
