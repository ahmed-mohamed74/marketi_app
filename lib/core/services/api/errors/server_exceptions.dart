import 'package:dio/dio.dart';
import 'package:marketi_app/core/services/api/errors/error_model.dart';

class ServerException implements Exception{
  final ErrorModel errModel;

  ServerException({required this.errModel});
}
 void handleDioExceptions(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        throw ServerException(
          errModel: ErrorModel.fromJson(e.response!.data),
        );
      case DioExceptionType.connectionTimeout:
        throw ServerException(
          errModel: ErrorModel.fromJson(e.response!.data),
        );
      case DioExceptionType.receiveTimeout:
        throw ServerException(
          errModel: ErrorModel.fromJson(e.response!.data),
        );
      case DioExceptionType.badCertificate:
        throw ServerException(
          errModel: ErrorModel.fromJson(e.response!.data),
        );
      case DioExceptionType.cancel:
        throw ServerException(
          errModel: ErrorModel.fromJson(e.response!.data),
        );
      case DioExceptionType.sendTimeout:
        throw ServerException(
          errModel: ErrorModel.fromJson(e.response!.data),
        );
      case DioExceptionType.unknown:
        throw ServerException(
          errModel: ErrorModel.fromJson(e.response!.data),
        );
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400:
            throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data),
            );
          case 401:
            throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data),
            );
          case 403:
            throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data),
            );
          case 404:
            throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data),
            );
          case 409:
            throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data),
            );
          case 422:
            throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data),
            );
          case 504:
            throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data),
            );
        }
    }
  }
