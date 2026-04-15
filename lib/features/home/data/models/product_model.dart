import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends Equatable {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int quantity;
  @HiveField(2)
  String? title;
  @HiveField(3)
  String? description;
  @HiveField(4)
  String? category;
  @HiveField(5)
  double? price;
  @HiveField(6)
  double? discountPercentage;
  @HiveField(7)
  double? rating;
  @HiveField(8)
  int? stock;
  @HiveField(9)
  List<String>? tags;
  @HiveField(10)
  String? brand;
  @HiveField(11)
  String? sku;
  @HiveField(12)
  int? weight;
  @HiveField(13)
  Dimensions? dimensions;
  @HiveField(14)
  String? warrantyInformation;
  @HiveField(15)
  String? shippingInformation;
  @HiveField(16)
  String? availabilityStatus;
  @HiveField(17)
  List<Reviews>? reviews;
  @HiveField(18)
  String? returnPolicy;
  @HiveField(19)
  int? minimumOrderQuantity;
  @HiveField(20)
  Meta? meta;
  @HiveField(21)
  List<String>? images;
  @HiveField(22)
  String? thumbnail;

  ProductModel({
    this.id,
    this.quantity = 1,
    this.title,
    this.description,
    this.category,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.tags,
    this.brand,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.meta,
    this.images,
    this.thumbnail,
  });

  ProductModel copyWith({int? quantity}) {
    return ProductModel(
      id: id,
      quantity: quantity ?? this.quantity,
      title: title,
      description: description,
      category: category,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      tags: tags,
      brand: brand,
      sku: sku,
      weight: weight,
      dimensions: dimensions,
      warrantyInformation: warrantyInformation,
      shippingInformation: shippingInformation,
      availabilityStatus: availabilityStatus,
      reviews: reviews,
      returnPolicy: returnPolicy,
      minimumOrderQuantity: minimumOrderQuantity,
      meta: meta,
      images: images,
      thumbnail: thumbnail,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] as int? ?? 0,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      brand: json['brand'] ?? '',
      sku: json['sku'] ?? '',
      weight: json['weight'] as int? ?? 0,
      dimensions: json['dimensions'] != null ? Dimensions.fromJson(json['dimensions']) : null,
      warrantyInformation: json['warrantyInformation'] ?? '',
      shippingInformation: json['shippingInformation'] ?? '',
      availabilityStatus: json['availabilityStatus'] ?? '',
      reviews: (json['reviews'] as List?)?.map((e) => Reviews.fromJson(e)).toList() ?? [],
      returnPolicy: json['returnPolicy'] ?? '',
      minimumOrderQuantity: json['minimumOrderQuantity'] as int? ?? 0,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'tags': tags,
      'brand': brand,
      'sku': sku,
      'weight': weight,
      'dimensions': dimensions?.toJson(),
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'reviews': reviews?.map((e) => e.toJson()).toList(),
      'returnPolicy': returnPolicy,
      'minimumOrderQuantity': minimumOrderQuantity,
      'meta': meta?.toJson(),
      'images': images,
      'thumbnail': thumbnail,
    };
  }

  @override
  List<Object?> get props => [id, quantity, title, price, brand];
}

@HiveType(typeId: 1)
class Dimensions {
  @HiveField(0)
  double? width;
  @HiveField(1)
  double? height;
  @HiveField(2)
  double? depth;

  Dimensions({this.width, this.height, this.depth});

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      depth: (json['depth'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {'width': width, 'height': height, 'depth': depth};
}

@HiveType(typeId: 2)
class Reviews {
  @HiveField(0)
  int? rating;
  @HiveField(1)
  String? comment;
  @HiveField(2)
  String? date;
  @HiveField(3)
  String? reviewerName;
  @HiveField(4)
  String? reviewerEmail;

  Reviews({this.rating, this.comment, this.date, this.reviewerName, this.reviewerEmail});

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] ?? '',
      date: json['date'] ?? '',
      reviewerName: json['reviewerName'] ?? '',
      reviewerEmail: json['reviewerEmail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'comment': comment,
        'date': date,
        'reviewerName': reviewerName,
        'reviewerEmail': reviewerEmail,
      };
}

@HiveType(typeId: 3)
class Meta {
  @HiveField(0)
  String? createdAt;
  @HiveField(1)
  String? updatedAt;
  @HiveField(2)
  String? barcode;
  @HiveField(3)
  String? qrCode;

  Meta({this.createdAt, this.updatedAt, this.barcode, this.qrCode});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      barcode: json['barcode'] ?? '',
      qrCode: json['qrCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'barcode': barcode,
        'qrCode': qrCode,
      };
}