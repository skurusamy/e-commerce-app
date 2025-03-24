part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthLoggedOut extends AuthState {}

class AuthOtpSent extends AuthState {
  final String verificationId;
  AuthOtpSent(this.verificationId);
}

class RegisterSuccess extends AuthState {
  final User user;
  RegisterSuccess(this.user);
}

class PasswordResetEmailSent extends AuthState {}