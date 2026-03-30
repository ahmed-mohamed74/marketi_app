part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;

  AuthSignUp({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.confirmPassword,
  });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({required this.email, required this.password});
}

final class AuthIsUserLoggedIn extends AuthEvent {}
