import 'package:e_commerce_app/constants/app_texts.dart';
import 'package:e_commerce_app/services/common_service.dart';
import 'package:e_commerce_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../blocs/auth/auth_bloc.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lets get you all set'),
              SizedBox(height: 40),
              CustomTextFormField(
                  name: 'email',
                  hintText: AppText.enterEmail,
                  controller: emailController,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ])),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  context.read<AuthBloc>().add(ForgotPasswordRequested(email));
                  emailController.text = '';
                  CommonService.showCustomDialog(
                      context, AppText.passwordReset, AppText.resetEmailSent);
                },
                child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
