import 'dart:convert';

class BrandModel {
  final String brandImage;
  BrandModel({
    required this.brandImage,
  });

  BrandModel copyWith({
    String? brandImage,
  }) {
    return BrandModel(
      brandImage: brandImage ?? this.brandImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'brandImage': brandImage,
    };
  }

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      brandImage: map['brandImage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BrandModel.fromJson(String source) => BrandModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BrandModel(brandImage: $brandImage)';

  @override
  bool operator ==(covariant BrandModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.brandImage == brandImage;
  }

  @override
  int get hashCode => brandImage.hashCode;
}
