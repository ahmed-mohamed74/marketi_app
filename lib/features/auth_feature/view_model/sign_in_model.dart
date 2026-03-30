import 'package:marketi_app/core/services/api/end_points.dart';
import 'package:marketi_app/features/auth_feature/view_model/user_model.dart';

class SignInModel {
  final String message;
  final String token;
  UserModel user;

  SignInModel({required this.message, required this.token, required this.user});
  factory SignInModel.fromJson(Map<String, dynamic> jsonData) {
    return SignInModel(
      message: jsonData[ApiKey.message],
      token: jsonData[ApiKey.token],
      user: UserModel.fromJson(jsonData[ApiKey.user]),
    );
  }
}
