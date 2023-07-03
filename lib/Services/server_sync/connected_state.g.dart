// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connected_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConnectedStateAdapter extends TypeAdapter<ConnectedState> {
  @override
  final int typeId = 0;

  @override
  ConnectedState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConnectedState(
      connected: fields[0] as bool,
      ip: fields[1] as String,
      lastConnected: fields[2] as DateTime?,
      pin: fields[3] as String?,
      deviceName: fields[4] as String?,
      deviceID: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ConnectedState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.connected)
      ..writeByte(1)
      ..write(obj.ip)
      ..writeByte(2)
      ..write(obj.lastConnected)
      ..writeByte(3)
      ..write(obj.pin)
      ..writeByte(4)
      ..write(obj.deviceName)
      ..writeByte(5)
      ..write(obj.deviceID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectedStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
