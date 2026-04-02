import 'dart:convert';

class CategoryModel {
  final String categoryImage;
  final String categoryName;
  CategoryModel({
    required this.categoryImage,
    required this.categoryName,
  });

  CategoryModel copyWith({
    String? categoryImage,
    String? categoryName,
  }) {
    return CategoryModel(
      categoryImage: categoryImage ?? this.categoryImage,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryImage': categoryImage,
      'categoryName': categoryName,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryImage: map['categoryImage'] as String,
      categoryName: map['categoryName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CategoryModel(categoryImage: $categoryImage, categoryName: $categoryName)';

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.categoryImage == categoryImage &&
      other.categoryName == categoryName;
  }

  @override
  int get hashCode => categoryImage.hashCode ^ categoryName.hashCode;
}
