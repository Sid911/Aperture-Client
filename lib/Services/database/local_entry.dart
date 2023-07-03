import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'local_entry.g.dart';

@JsonSerializable()
@HiveType(typeId: 1, adapterName: "LocalEntryAdapter")
class LocalEntry {
  @HiveField(0)
  final String fileUuid;
  @HiveField(1)
  final String fileName;
  @HiveField(2)
  final int fileSize;
  @HiveField(3)
  final String? blurhash;
  @HiveField(4)
  final String fileLocation;
  @HiveField(5)
  final SerializedMetadata metadata;

  LocalEntry({
    required this.fileUuid,
    required this.fileName,
    required this.fileSize,
    this.blurhash,
    required this.fileLocation,
    required this.metadata,
  });

  factory LocalEntry.fromJson(Map<String, dynamic> json) => _$LocalEntryFromJson(json);
  Map<String, dynamic> toJson() => _$LocalEntryToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 2, adapterName: "SerializedMetadataAdapter")
class SerializedMetadata {
  @HiveField(0)
  final String? fileType;
  @HiveField(1)
  final int? modified;
  @HiveField(2)
  final int? accessed;
  @HiveField(3)
  final int? created;
  @HiveField(4)
  final int? len;

  SerializedMetadata({
    this.fileType,
    this.modified,
    this.accessed,
    this.created,
    this.len,
  });

  factory SerializedMetadata.fromJson(Map<String, dynamic> json) => _$SerializedMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$SerializedMetadataToJson(this);
}