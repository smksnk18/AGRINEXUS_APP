// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eatgood_product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EatGoodProductAdapter extends TypeAdapter<EatGoodProduct> {
  @override
  final int typeId = 0;

  @override
  EatGoodProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EatGoodProduct(
      productId: fields[0] as String,
      productName: fields[1] as String,
      ingredients: (fields[2] as List).cast<String>(),
      calories: fields[3] as double,
      sugar: fields[4] as double,
      fat: fields[5] as double,
      protein: fields[6] as double,
      sodium: fields[7] as double,
      qrData: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EatGoodProduct obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.ingredients)
      ..writeByte(3)
      ..write(obj.calories)
      ..writeByte(4)
      ..write(obj.sugar)
      ..writeByte(5)
      ..write(obj.fat)
      ..writeByte(6)
      ..write(obj.protein)
      ..writeByte(7)
      ..write(obj.sodium)
      ..writeByte(8)
      ..write(obj.qrData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EatGoodProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
