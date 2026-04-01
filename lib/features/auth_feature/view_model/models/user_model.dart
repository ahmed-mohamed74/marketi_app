import 'package:marketi_app/core/services/api/end_points.dart';

class UserModel {
  final String name;
  final String phone;
  final String email;
  final String role;
  final String image;

  UserModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.image,
  });
  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      email: jsonData[ApiKey.email],
      name: jsonData[ApiKey.name],
      phone: jsonData[ApiKey.phone],
      role: jsonData[ApiKey.role],
      image: jsonData[ApiKey.image],
    );
  }
}
