import 'package:marketi_app/core/services/api/end_points.dart';

class ErrorModel {
  final String message;

  ErrorModel({required this.message});
  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    print('message: ${jsonData[ApiKey.errorMessage]},json data: ${jsonData}');
    return ErrorModel(message: jsonData[ApiKey.errorMessage]);
  }
}
