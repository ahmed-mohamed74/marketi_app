import 'package:dio/dio.dart';
import 'package:marketi_app/core/services/api/end_points.dart';
import 'package:marketi_app/core/services/cache/cache_helper.dart';

class ApiInterceptors extends Interceptor {
    @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization']='Bearer ${CacheHelper().getData(key: ApiKey.token)}';
    super.onRequest(options, handler);
  }
}