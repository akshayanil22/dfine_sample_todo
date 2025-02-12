part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {} // New event to check if user is already logged in
class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  SignInRequested({required this.email, required this.password});
}
class SignUpRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  SignUpRequested({required this.fullName,required this.email, required this.password});
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  ForgotPasswordRequested({required this.email});
}

class SignOutRequested extends AuthEvent {}
