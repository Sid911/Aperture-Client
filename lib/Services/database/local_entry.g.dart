// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalEntryAdapter extends TypeAdapter<LocalEntry> {
  @override
  final int typeId = 1;

  @override
  LocalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalEntry(
      fileUuid: fields[0] as String,
      fileName: fields[1] as String,
      fileSize: fields[2] as int,
      blurhash: fields[3] as String?,
      fileLocation: fields[4] as String,
      metadata: fields[5] as SerializedMetadata,
    );
  }

  @override
  void write(BinaryWriter writer, LocalEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.fileUuid)
      ..writeByte(1)
      ..write(obj.fileName)
      ..writeByte(2)
      ..write(obj.fileSize)
      ..writeByte(3)
      ..write(obj.blurhash)
      ..writeByte(4)
      ..write(obj.fileLocation)
      ..writeByte(5)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SerializedMetadataAdapter extends TypeAdapter<SerializedMetadata> {
  @override
  final int typeId = 2;

  @override
  SerializedMetadata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SerializedMetadata(
      fileType: fields[0] as String?,
      modified: fields[1] as int?,
      accessed: fields[2] as int?,
      created: fields[3] as int?,
      len: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SerializedMetadata obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fileType)
      ..writeByte(1)
      ..write(obj.modified)
      ..writeByte(2)
      ..write(obj.accessed)
      ..writeByte(3)
      ..write(obj.created)
      ..writeByte(4)
      ..write(obj.len);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SerializedMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalEntry _$LocalEntryFromJson(Map<String, dynamic> json) => LocalEntry(
      fileUuid: json['fileUuid'] as String,
      fileName: json['fileName'] as String,
      fileSize: json['fileSize'] as int,
      blurhash: json['blurhash'] as String?,
      fileLocation: json['fileLocation'] as String,
      metadata:
          SerializedMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocalEntryToJson(LocalEntry instance) =>
    <String, dynamic>{
      'fileUuid': instance.fileUuid,
      'fileName': instance.fileName,
      'fileSize': instance.fileSize,
      'blurhash': instance.blurhash,
      'fileLocation': instance.fileLocation,
      'metadata': instance.metadata,
    };

SerializedMetadata _$SerializedMetadataFromJson(Map<String, dynamic> json) =>
    SerializedMetadata(
      fileType: json['fileType'] as String?,
      modified: json['modified'] as int?,
      accessed: json['accessed'] as int?,
      created: json['created'] as int?,
      len: json['len'] as int?,
    );

Map<String, dynamic> _$SerializedMetadataToJson(SerializedMetadata instance) =>
    <String, dynamic>{
      'fileType': instance.fileType,
      'modified': instance.modified,
      'accessed': instance.accessed,
      'created': instance.created,
      'len': instance.len,
    };
