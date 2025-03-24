import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../blocs/password/password_bloc.dart';
import '../blocs/password/password_event.dart';
import '../blocs/password/password_state.dart';
class CustomPasswordField extends StatelessWidget {
  TextEditingController? controller = TextEditingController();
  String labelText;
  String name;
  dynamic validator;

  CustomPasswordField({super.key,
    required this.labelText,
    required this.name,
    this.controller,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordBloc(),
      child: BlocBuilder<PasswordBloc, PasswordState>(
        builder: (context, state) {
          return FormBuilderTextField(
            name: name,
            controller: controller,
            obscureText: !state.isPasswordVisible,
            decoration: InputDecoration(
              hintText: labelText,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              suffixIcon: IconButton(
                icon: Icon(
                  state.isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  context
                      .read<PasswordBloc>()
                      .add(TogglePasswordVisibility());
                },
              ),
            ),
            validator: validator,
          );
        },
      ),
    );

  }
}
