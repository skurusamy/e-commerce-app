import 'package:e_commerce_app/blocs/password/password_event.dart';
import 'package:e_commerce_app/blocs/password/password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  PasswordBloc() : super(PasswordState()) {
    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });

    on<ToggleConfirmPasswordVisibility>((event, emit) {
      emit(state.copyWith(
          isConfirmPasswordVisible: !state.isConfirmPasswordVisible));
    });
  }
}