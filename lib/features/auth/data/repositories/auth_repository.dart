import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:marketi_app/core/api/api_consumer.dart';
import 'package:marketi_app/core/api/end_points.dart';
import 'package:marketi_app/core/api/errors/server_exceptions.dart';
import 'package:marketi_app/core/network/connection_checker.dart';
import 'package:marketi_app/core/services/cache/cache_helper.dart';
import 'package:marketi_app/features/auth/data/models/sign_in_model.dart';
import 'package:marketi_app/features/auth/data/models/user_model.dart';

class AuthRepository {
  final ConnectionChecker connectionChecker;
  final ApiConsumer api;
  AuthRepository(this.connectionChecker, this.api);
  Future<Either<String, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return Left('No internet connection!');
      }
      final response = await api.post(
        EndPoints.signIn,
        data: {ApiKey.email: email, ApiKey.password: password},
      );

      final signInResponse = SignInModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(signInResponse.token ?? '');

      final user = UserModel.fromJson(response[ApiKey.user]);

      await CacheHelper().saveData(
        key: ApiKey.token,
        value: signInResponse.token,
      );

      await CacheHelper().saveData(
        key: ApiKey.id,
        value: decodedToken[ApiKey.id],
      );

      await CacheHelper().saveData(
        key: ApiKey.user,
        value: jsonEncode(user.toJson()),
      );

      return Right(user);
    } on ServerException catch (e) {
      return Left(e.errModel.message!);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return Left('No internet connection!');
      }
      final response = await api.post(
        EndPoints.signUp,
        data: {
          ApiKey.name: name,
          ApiKey.phone: phone,
          ApiKey.email: email,
          ApiKey.password: password,
          ApiKey.confirmPassword: confirmPassword,
        },
      );
      final String message = response['message'];
      return Right(message);
    } on ServerException catch (e) {
      return Left(e.errModel.message ?? 'Auth Failure happened (AuthSignUp)');
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> authRestPassword({
    required String email,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return Left('No internet connection!');
      }
      final response = await api.post(
        EndPoints.resetPassword,
        data: {ApiKey.email: email},
      );
      final message = response['error'];
      return Right(message);
    } on ServerException catch (e) {
      return Left(
        e.errModel.message ?? 'Auth Failure happened (AuthRestPassword)',
      );
    } catch (e) {
      return Left('Auth Reset Password failure: ${e.toString()}');
    }
  }

  Future<Either<String, String>> authVerifyCode({
    required String email,
    required String code,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return Left('No internet connection!');
      }
      final response = await api.post(
        EndPoints.verificationResetPass,
        data: {ApiKey.email: email, ApiKey.code: code},
      );
      final message = response['message'];
      return Right(message);
    } on ServerException catch (e) {
      return Left(
        e.errModel.message ?? 'Auth Failure happened (AuthVerifyCode)',
      );
    } catch (e) {
      return Left('Auth Verify Code failure: ${e.toString()}');
    }
  }

  Future<Either<String, String>> authConfirmResetPassword({
    required String email,
    required String passsword,
    required String confirmPasssword,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return Left('No internet connection!');
      }
      final response = await api.post(
        EndPoints.confirmResetPassword,
        data: {
          ApiKey.email: email,
          ApiKey.password: passsword,
          ApiKey.confirmPassword: confirmPasssword,
        },
      );
      final message = response['message'];
      return Right(message);
    } on ServerException catch (e) {
      return Left(
        e.errModel.message ??
            'Auth Failure happened (AuthConfirmResetPassword)',
      );
    } catch (e) {
      return Left('Auth Confirm Reset Password failure: ${e.toString()}');
    }
  }
}
