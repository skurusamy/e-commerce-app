import 'package:e_commerce_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../widgets/custom_password_field.dart';
import 'login_with_email_screen.dart';

class SetPasswordScreen extends StatelessWidget {
  final String email;

  const SetPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final setPasswordKey = GlobalKey<FormBuilderState>();

    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final emailController = TextEditingController();

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            //CommonService.showErrorDialog(context, state.message);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FormBuilder(
              key: setPasswordKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FormBuilderTextField(
                      controller: emailController,
                      name: 'email',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                        hintText: email,
                      ),
                      readOnly: true),
                  SizedBox(height: 10),
                  CustomPasswordField(
                    labelText: "Password",
                    name: "password",
                    controller: passwordController,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Password cannot be empty'),
                      FormBuilderValidators.minLength(6),
                    ]),
                  ),
                  SizedBox(height: 10),
                  CustomPasswordField(
                    labelText: "Confirm Password",
                    name: "confirmPassword",
                    controller: confirmPasswordController,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      if (val != passwordController.text) {
                        return 'Password doesn\'t match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      emailController.text = email;
                      if (setPasswordKey.currentState!.saveAndValidate()) {
                        var formData = setPasswordKey.currentState?.value;
                        context.read<AuthBloc>().add(
                              SignUpWithEmail(
                                  formData?['email'], formData?['password']),
                            );
                        setPasswordKey.currentState?.reset();
                      }
                    },
                    child: Text("Set Password"),
                  ),
                  SizedBox(
                    height: 50,
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
              ),
            )),
      ),
    );
  }
}
