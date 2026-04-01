import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/features/auth_feature/view_model/models/sign_in_model.dart';
import 'package:marketi_app/features/auth_feature/view_model/repositories/auth_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  bool isChecked = false;
  SignInModel? user;
  void changeCheckBox(bool value) {
    isChecked = value;
    emit(AuthRememberMe());
  }

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
      final response = await authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      response.fold(
        (errorMessage) => emit(AuthFailure(errorMessage: errorMessage)),
        (signInModel) => emit(AuthLoginSuccess()),
      );
    });

    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      final response = await authRepository.signUp(
        name: event.name,
        email: event.email,
        password: event.password,
        phone: event.phone,
        confirmPassword: event.confirmPassword,
      );
      response.fold(
        (errorMessage) => emit(AuthFailure(errorMessage: errorMessage)),
        (message) => emit(AuthSignUpSuccess(message: message)),
      );
    });

    on<AuthRestPassword>((event, emit) async {
      emit(AuthLoading());
      final response = await authRepository.authRestPassword(
        email: event.email,
      );
      response.fold(
        (errorMessage) => emit(AuthFailure(errorMessage: errorMessage)),
        (message) => emit(AuthResetPasswordSuccess(message: message)),
      );
    });

    on<AuthVerifyCode>((event, emit) async {
      emit(AuthLoading());
      final response = await authRepository.authVerifyCode(
        code: event.code,
        email: event.email,
      );
      response.fold(
        (errorMessage) => emit(AuthFailure(errorMessage: errorMessage)),
        (message) => emit(AuthVerifyCodeSuccess()),
      );
    });

    on<AuthConfirmResetPassword>((event, emit) async {
      emit(AuthLoading());
      final response = await authRepository.authConfirmResetPassword(
        passsword: event.passsword,
        confirmPasssword: event.confirmPasssword,
        email: event.email,
      );
      response.fold(
        (errorMessage) => emit(AuthFailure(errorMessage: errorMessage)),
        (message) => emit(AuthCreateNewPasswordSuccess()),
      );
    });
  }
}
