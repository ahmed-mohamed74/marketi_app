import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:marketi_app/core/services/api/api_consumer.dart';
import 'package:marketi_app/core/services/api/end_points.dart';
import 'package:marketi_app/core/services/api/errors/server_exceptions.dart';
import 'package:marketi_app/core/services/cache/cache_helper.dart';
import 'package:marketi_app/features/auth_feature/view_model/sign_in_model.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiConsumer api;
  bool isChecked = false;
  SignInModel? user;
  void changeCheckBox(bool value) {
    isChecked = value;
    emit(AuthRememberMe());
  }

  AuthBloc({required this.api}) : super(AuthInitial()) {
    on<AuthLogin>((event, emit) async {
      try {
        emit(AuthLoading());
        final response = await api.post(
          EndPoints.signIn,
          data: {ApiKey.email: event.email, ApiKey.password: event.password},
        );
        user = SignInModel.fromJson(response);
        final decodedToken = JwtDecoder.decode(user!.token ?? '');
        CacheHelper().saveData(key: ApiKey.token, value: user!.token);
        CacheHelper().saveData(key: ApiKey.id, value: decodedToken[ApiKey.id]);
        emit(AuthLoginSuccess());
      } on ServerException catch (e) {
        emit(AuthFailure(errorMessage: e.errModel.message??'Auth Failure happened (AuthLogin)'));
      } catch (e) {
        emit(AuthFailure(errorMessage: e.toString()));
      }
    });

    on<AuthSignUp>((event, emit) async {
      try {
        emit(AuthLoading());
        final response = await api.post(
          EndPoints.signUp,
          data: {
            ApiKey.name: event.name,
            ApiKey.phone: event.phone,
            ApiKey.email: event.email,
            ApiKey.password: event.password,
            ApiKey.confirmPassword: event.confirmPassword,
          },
        );
        final message = response['message'];
        emit(AuthSignUpSuccess(message: message));
      } on ServerException catch (e) {
        emit(AuthFailure(errorMessage: e.errModel.message??'Auth Failure happened (AuthSignUp)'));
      }
    });
    on<AuthRestPassword>((event, emit) async {
      try {
        emit(AuthLoading());
        final response = await api.post(
          EndPoints.resetPassword,
          data: {ApiKey.email: event.email},
        );
        final message = response['error'];
        emit(AuthResetPasswordSuccess(message: message));
      } on ServerException catch (e) {
        emit(AuthFailure(errorMessage: e.errModel.message??'Auth Failure happened (AuthRestPassword)'));
      } catch (e) {
        emit(
          AuthFailure(
            errorMessage: 'Auth Reset Password failure: ${e.toString()}',
          ),
        );
      }
    });
    on<AuthVerifyCode>((event, emit) async {
      try {
        emit(AuthLoading());
        final response = await api.post(
          EndPoints.verificationResetPass,
          data: {ApiKey.email: event.email, ApiKey.code: event.code},
        );
        print('active code response: $response');
        // final message = response['message'];
        emit(AuthVerifyCodeSuccess());
      } on ServerException catch (e) {
        emit(AuthFailure(errorMessage: e.errModel.message??'Auth Failure happened (AuthVerifyCode)'));
      }
    });
    on<AuthConfirmResetPassword>((event, emit) async {
      try {
        emit(AuthLoading());
        final response = await api.post(
          EndPoints.confirmResetPassword,
          data: {
            ApiKey.email: event.email,
            ApiKey.password: event.passsword,
            ApiKey.confirmPassword: event.confirmPasssword,
          },
        );
        print('active code response: $response');
        // final message = response['message'];
        emit(AuthCreateNewPasswordSuccess());
      } on ServerException catch (e) {
        emit(AuthFailure(errorMessage: e.errModel.message??'Auth Failure happened (AuthConfirmResetPassword)'));
      }
    });
  }
}
