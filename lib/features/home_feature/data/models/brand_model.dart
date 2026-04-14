import 'dart:convert';

import 'package:hive/hive.dart';

part 'brand_model.g.dart';
@HiveType(typeId: 5)

class BrandModel {
  @HiveField(0)
  final String? emoji;
  @HiveField(1)
  final String? name;
  BrandModel({
    required this.emoji,
    required this.name,
  });

  BrandModel copyWith({
    String? emoji,
    String? name,
  }) {
    return BrandModel(
      emoji: emoji ?? this.emoji,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'emoji': emoji, 'name': name};
  }

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      emoji: map['emoji'] ??'',
      name: map['name'] ?? '❓',
    );
  }

  String toJson() => json.encode(toMap());

  factory BrandModel.fromJson(String source) =>
      BrandModel.fromMap(json.decode(source) as Map<String, dynamic>);

}
