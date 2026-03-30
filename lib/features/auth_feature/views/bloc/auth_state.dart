part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthRememberMe extends AuthState {}

final class AuthLoading extends AuthState {}
final class AuthVerifyCodeSuccess extends AuthState {}
final class AuthCreateNewPasswordSuccess extends AuthState {}

final class AuthLoginSuccess extends AuthState {}

final class AuthSignUpSuccess extends AuthState {
  final String message;

  AuthSignUpSuccess({required this.message});
}

final class AuthResetPasswordSuccess extends AuthState {
  final String message;

  AuthResetPasswordSuccess({required this.message});
}

final class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure({required this.errorMessage});
}
