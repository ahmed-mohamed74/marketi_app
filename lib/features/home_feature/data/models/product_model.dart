import 'package:equatable/equatable.dart';

class ProductModel extends Equatable{
  int? id;
  int quantity = 1;
  String? title;
  String? description;
  String? category;
  double? price;
  double? discountPercentage;
  double? rating;
  int? stock;
  List<String>? tags;
  String? brand;
  String? sku;
  int? weight;
  Dimensions? dimensions;
  String? warrantyInformation;
  String? shippingInformation;
  String? availabilityStatus;
  List<Reviews>? reviews;
  String? returnPolicy;
  int? minimumOrderQuantity;
  Meta? meta;
  List<String>? images;
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
      price: price,
      images: images,
      rating: rating,
      // Add other fields as needed
    );
  }
  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] ?? '';
    description = json['description'] ?? '';
    category = json['category'] ?? '';

    /// 🔥 أهم تعديل (حل مشكلة int/double)
    price = (json['price'] as num?)?.toDouble() ?? 0.0;
    discountPercentage =
        (json['discountPercentage'] as num?)?.toDouble() ?? 0.0;
    rating = (json['rating'] as num?)?.toDouble() ?? 0.0;

    stock = json['stock'] as int? ?? 0;

    /// ✅ حماية من null
    tags = (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [];

    brand = json['brand'] ?? '';
    sku = json['sku'] ?? '';
    weight = json['weight'] as int? ?? 0;

    dimensions = json['dimensions'] != null
        ? Dimensions.fromJson(json['dimensions'])
        : null;

    warrantyInformation = json['warrantyInformation'] ?? '';
    shippingInformation = json['shippingInformation'] ?? '';
    availabilityStatus = json['availabilityStatus'] ?? '';

    /// ✅ reviews safe
    reviews =
        (json['reviews'] as List?)?.map((e) => Reviews.fromJson(e)).toList() ??
        [];

    returnPolicy = json['returnPolicy'] ?? '';
    minimumOrderQuantity = json['minimumOrderQuantity'] as int? ?? 0;

    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;

    /// ✅ images safe
    images = (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [];

    thumbnail = json['thumbnail'] ?? '';
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
  List<Object?> get props => [id, quantity, title, price];
}

class Dimensions {
  double? width;
  double? height;
  double? depth;

  Dimensions({this.width, this.height, this.depth});

  Dimensions.fromJson(Map<String, dynamic> json) {
    width = (json['width'] as num?)?.toDouble() ?? 0.0;
    height = (json['height'] as num?)?.toDouble() ?? 0.0;
    depth = (json['depth'] as num?)?.toDouble() ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    return {'width': width, 'height': height, 'depth': depth};
  }
}

class Reviews {
  int? rating;
  String? comment;
  String? date;
  String? reviewerName;
  String? reviewerEmail;

  Reviews({
    this.rating,
    this.comment,
    this.date,
    this.reviewerName,
    this.reviewerEmail,
  });

  Reviews.fromJson(Map<String, dynamic> json) {
    rating = json['rating'] as int? ?? 0;
    comment = json['comment'] ?? '';
    date = json['date'] ?? '';
    reviewerName = json['reviewerName'] ?? '';
    reviewerEmail = json['reviewerEmail'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date,
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
    };
  }
}

class Meta {
  String? createdAt;
  String? updatedAt;
  String? barcode;
  String? qrCode;

  Meta({this.createdAt, this.updatedAt, this.barcode, this.qrCode});

  Meta.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    barcode = json['barcode'] ?? '';
    qrCode = json['qrCode'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'barcode': barcode,
      'qrCode': qrCode,
    };
  }
}
