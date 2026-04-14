import 'dart:convert';

import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 4)
class CategoryModel {
  @HiveField(0)
  final String image;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String slug;
  @HiveField(3)
  final String url;
  CategoryModel({
    required this.image,
    required this.name,
    required this.slug,
    required this.url,
  });

  CategoryModel copyWith({
    String? image,
    String? name,
    String? slug,
    String? url,
  }) {
    return CategoryModel(
      image: image ?? this.image,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'image': image, 'name': name, 'slug': slug, 'url': url};
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      image: map['image'] as String,
      name: map['name'] as String,
      slug: map['slug'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

}
