part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUpWithEmail extends AuthEvent {
  final String email;
  final String password;

  SignUpWithEmail(this.email, this.password);
}

class SignInWithEmail extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmail(this.email, this.password);
}

class SignInWithGoogle extends AuthEvent {}

class SendOtp extends AuthEvent {
  final String phoneNumber;
  SendOtp(this.phoneNumber);
}

class VerifyOtp extends AuthEvent {
  final String verificationId;
  final String smsCode;
  VerifyOtp(this.verificationId, this.smsCode);
}

class SignOut extends AuthEvent {}

class Register extends AuthEvent {
  final Map<String, dynamic> userInfo;
  Register(this.userInfo);
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  ForgotPasswordRequested(this.email);
}

