import 'package:marketi_app/core/api/end_points.dart';

class ErrorModel {
  final String? message;

  ErrorModel({required this.message});
  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    print('message: ${jsonData[ApiKey.errorMessage]??'error occured'},json data: $jsonData');
    return ErrorModel(message: jsonData[ApiKey.errorMessage]??jsonData['error']??'error occured');
  }
}
