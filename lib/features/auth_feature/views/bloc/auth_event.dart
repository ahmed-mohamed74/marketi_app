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

final class AuthRestPassword extends AuthEvent {
  final String email;

  AuthRestPassword({required this.email});
}

final class AuthVerifyCode extends AuthEvent {
  final String email;
  final String code;

  AuthVerifyCode({required this.email, required this.code});
}

final class AuthConfirmResetPassword extends AuthEvent {
  final String email;
  final String passsword;
  final String confirmPasssword;

  AuthConfirmResetPassword({
    required this.email,
    required this.passsword,
    required this.confirmPasssword,
  });
}

final class AuthIsUserLoggedIn extends AuthEvent {}
