import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/auth_service.dart';
import '../../models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthBloc(this._authService, this._firestoreService) : super(AuthInitial()) {

    on<SignUpWithEmail>((event, emit) async {
      emit(AuthLoading());
      try {
        bool emailExists = await _authService.isEmailExists(event.email);
        if (emailExists) {
          emit(AuthFailure('Email already in use. Please login.'));
          return;
        }

        User? user = await _authService.signUpWithEmail(
          event.email,
          event.password,
        );

        emit(AuthSuccess(user!));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignInWithEmail>((event, emit) async {
      emit(AuthLoading());
      try {
        User? user =
        await _authService.signInWithEmail(event.email, event.password);
        if (user != null) {
          _authService.saveLoginState();
          emit(AuthSuccess(user));
        } else {
          emit(AuthFailure("Invalid Email/Password"));
        }
      }catch (e) {
        emit(AuthFailure(e.toString()));
      }

    });

    on<SignInWithGoogle>((event, emit) async {
      emit(AuthLoading());
      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        _authService.saveLoginState();
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Google Sign-In Failed"));
      }
    });

    on<SendOtp>((event, emit) async {
      emit(AuthLoading());
      await _authService.signInWithPhone(event.phoneNumber,
              (String verificationId) {
            emit(AuthOtpSent(verificationId));
          });
    });

    on<VerifyOtp>((event, emit) async {
      emit(AuthLoading());
      User? user =
      await _authService.verifyOTP(event.verificationId, event.smsCode);
      if (user != null) {
        _authService.saveLoginState();
        emit(AuthSuccess(user));
      }
    });

    on<SignOut>((event, emit) async {
      await _authService.signOut();
      emit(AuthLoggedOut());
    });

    on<Register>((event, emit) async {
      emit(AuthLoading());
      await _firestoreService.signUp(event.userInfo);
    });

    on<ForgotPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        bool isUserExists = await _authService.isEmailExists(event.email);
        if (isUserExists){
          await _authService.sendPasswordResetEmail(email: event.email);
          emit(PasswordResetEmailSent());
        }
        else{
          emit(AuthFailure('User with this email doesn\'t exists.'));
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthFailure(e.message ?? 'An unknown error occurred.'));
      }
    });
  }
}
