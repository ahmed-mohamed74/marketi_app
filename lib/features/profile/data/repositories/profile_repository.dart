// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:marketi_app/core/api/api_consumer.dart';
import 'package:marketi_app/core/api/end_points.dart';
import 'package:marketi_app/core/api/errors/server_exceptions.dart';
import 'package:marketi_app/core/services/cache/cache_helper.dart';
import 'package:marketi_app/features/auth/data/models/user_model.dart';

class ProfileRepository {
  final ApiConsumer api;
  ProfileRepository({required this.api});

  Future<Either<String, UserModel>> getUserProfileData() async {
    try {
      final response = await api.get(EndPoints.getUesrData);

      final freshUser = UserModel.fromJson(response['message']);
      await CacheHelper().saveData(
        key: ApiKey.user,
        value: jsonEncode(freshUser.toJson()),
      );

      return Right(freshUser);
    } on ServerException catch (e) {
      return Left(e.errModel.message!);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
