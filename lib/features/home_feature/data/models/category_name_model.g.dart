// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_name_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryNameModelAdapter extends TypeAdapter<CategoryNameModel> {
  @override
  final int typeId = 6;

  @override
  CategoryNameModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryNameModel(
      name: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryNameModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryNameModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
