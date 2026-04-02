
import 'dart:convert';

class ProductModel {
  final String? productImage;
  final String? price;
  final String? productName;
  final String? rate;
  ProductModel({
    this.productImage,
    this.price,
    this.productName,
    this.rate,
  });

  ProductModel copyWith({
    String? productImage,
    String? price,
    String? productName,
    String? rate,
  }) {
    return ProductModel(
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      productName: productName ?? this.productName,
      rate: rate ?? this.rate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productImage': productImage,
      'price': price,
      'productName': productName,
      'rate': rate,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productImage: map['productImage'] != null ? map['productImage'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      productName: map['productName'] != null ? map['productName'] as String : null,
      rate: map['rate'] != null ? map['rate'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(productImage: $productImage, price: $price, productName: $productName, rate: $rate)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.productImage == productImage &&
      other.price == price &&
      other.productName == productName &&
      other.rate == rate;
  }

  @override
  int get hashCode {
    return productImage.hashCode ^
      price.hashCode ^
      productName.hashCode ^
      rate.hashCode;
  }
}
