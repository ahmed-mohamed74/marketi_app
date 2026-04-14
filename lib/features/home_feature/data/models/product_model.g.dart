// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as int?,
      quantity: fields[1] as int,
      title: fields[2] as String?,
      description: fields[3] as String?,
      category: fields[4] as String?,
      price: fields[5] as double?,
      discountPercentage: fields[6] as double?,
      rating: fields[7] as double?,
      stock: fields[8] as int?,
      tags: (fields[9] as List?)?.cast<String>(),
      brand: fields[10] as String?,
      sku: fields[11] as String?,
      weight: fields[12] as int?,
      dimensions: fields[13] as Dimensions?,
      warrantyInformation: fields[14] as String?,
      shippingInformation: fields[15] as String?,
      availabilityStatus: fields[16] as String?,
      reviews: (fields[17] as List?)?.cast<Reviews>(),
      returnPolicy: fields[18] as String?,
      minimumOrderQuantity: fields[19] as int?,
      meta: fields[20] as Meta?,
      images: (fields[21] as List?)?.cast<String>(),
      thumbnail: fields[22] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.discountPercentage)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.stock)
      ..writeByte(9)
      ..write(obj.tags)
      ..writeByte(10)
      ..write(obj.brand)
      ..writeByte(11)
      ..write(obj.sku)
      ..writeByte(12)
      ..write(obj.weight)
      ..writeByte(13)
      ..write(obj.dimensions)
      ..writeByte(14)
      ..write(obj.warrantyInformation)
      ..writeByte(15)
      ..write(obj.shippingInformation)
      ..writeByte(16)
      ..write(obj.availabilityStatus)
      ..writeByte(17)
      ..write(obj.reviews)
      ..writeByte(18)
      ..write(obj.returnPolicy)
      ..writeByte(19)
      ..write(obj.minimumOrderQuantity)
      ..writeByte(20)
      ..write(obj.meta)
      ..writeByte(21)
      ..write(obj.images)
      ..writeByte(22)
      ..write(obj.thumbnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DimensionsAdapter extends TypeAdapter<Dimensions> {
  @override
  final int typeId = 1;

  @override
  Dimensions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dimensions(
      width: fields[0] as double?,
      height: fields[1] as double?,
      depth: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Dimensions obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.width)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.depth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DimensionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewsAdapter extends TypeAdapter<Reviews> {
  @override
  final int typeId = 2;

  @override
  Reviews read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reviews(
      rating: fields[0] as int?,
      comment: fields[1] as String?,
      date: fields[2] as String?,
      reviewerName: fields[3] as String?,
      reviewerEmail: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Reviews obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.rating)
      ..writeByte(1)
      ..write(obj.comment)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.reviewerName)
      ..writeByte(4)
      ..write(obj.reviewerEmail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MetaAdapter extends TypeAdapter<Meta> {
  @override
  final int typeId = 3;

  @override
  Meta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meta(
      createdAt: fields[0] as String?,
      updatedAt: fields[1] as String?,
      barcode: fields[2] as String?,
      qrCode: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Meta obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.createdAt)
      ..writeByte(1)
      ..write(obj.updatedAt)
      ..writeByte(2)
      ..write(obj.barcode)
      ..writeByte(3)
      ..write(obj.qrCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
