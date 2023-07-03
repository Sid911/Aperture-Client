// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DirectoryDataAdapter extends TypeAdapter<DirectoryData> {
  @override
  final int typeId = 3;

  @override
  DirectoryData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DirectoryData(
      name: fields[0] as String,
      path: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DirectoryData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DirectoryDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
