import 'package:hive/hive.dart';
part 'directory_data.g.dart';

@HiveType(typeId: 3, adapterName: "DirectoryDataAdapter")
class DirectoryData {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String path;

  DirectoryData({required this.name, required this.path});
}
