// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GiftAdapter extends TypeAdapter<Gift> {
  @override
  final int typeId = 0;

  @override
  Gift read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gift(
      name: fields[0] as String,
      quantity: fields[1] as int,
      probability: fields[2] as double,
      result: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Gift obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.probability)
      ..writeByte(3)
      ..write(obj.result);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiftAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
