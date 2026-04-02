import 'dart:convert';

class CategoryBrandModel {
  final String image;
  final String name;
  CategoryBrandModel({
    required this.image,
    required this.name,
  });

  CategoryBrandModel copyWith({
    String? image,
    String? name,
  }) {
    return CategoryBrandModel(
      image: image ?? this.image,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'name': name,
    };
  }

  factory CategoryBrandModel.fromMap(Map<String, dynamic> map) {
    return CategoryBrandModel(
      image: map['image'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryBrandModel.fromJson(String source) => CategoryBrandModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CategoryModel(categoryImage: $image, categoryName: $name)';

  @override
  bool operator ==(covariant CategoryBrandModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.image == image &&
      other.name == name;
  }

  @override
  int get hashCode => image.hashCode ^ name.hashCode;
}
