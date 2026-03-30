import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:marketi_app/core/services/api/api_consumer.dart';
import 'package:marketi_app/core/services/api/end_points.dart';
import 'package:marketi_app/core/services/api/errors/server_exceptions.dart';
import 'package:marketi_app/core/services/cache/cache_helper.dart';
import 'package:marketi_app/features/auth_feature/view_model/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiConsumer api;
  bool isChecked = false;
  UserModel? user;
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
        user = UserModel.fromJson(response);
        final decodedToken = JwtDecoder.decode(user!.token);
        CacheHelper().saveData(key: ApiKey.token, value: user!.token);
        CacheHelper().saveData(key: ApiKey.id, value: decodedToken[ApiKey.id]);
        emit(AuthLoginSuccess());
      } on ServerException catch (e) {
        emit(AuthFailure(errorMessage: e.errModel.message));
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
        emit(AuthFailure(errorMessage: e.errModel.message));
      }
    });
  }
}
