import 'package:marketi_app/core/services/api/end_points.dart';

class UserModel {
  final String message;
  final String token;

  UserModel({required this.message, required this.token});
  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      message: jsonData[ApiKey.message],
      token: jsonData[ApiKey.token],
    );
  }
}
