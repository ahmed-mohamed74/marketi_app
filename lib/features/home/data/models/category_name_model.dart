import 'package:hive/hive.dart';

part 'category_name_model.g.dart';

@HiveType(typeId: 6)
class CategoryNameModel {
  @HiveField(0)
  final String? name;

  CategoryNameModel({this.name});

  factory CategoryNameModel.fromJson(Map<String, dynamic> json) {
    return CategoryNameModel(
      name: json['name'], // Must match the key in your JSON exactly
    );
  }
}
