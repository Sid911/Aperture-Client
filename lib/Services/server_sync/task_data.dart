import 'package:aperture/Utils/file_type.dart';
import 'package:hive/hive.dart';
part 'task_data.g.dart';

@HiveType(typeId: 1, adapterName: "TaskDataAdapter")
class TaskData {
  @HiveField(0)
  final String fileName;
  @HiveField(1)
  final String filePath;
  @HiveField(2)
  final DateTime uploadStart;
  @HiveField(3)
  final DateTime? uploadEnd;
  @HiveField(4)
  final FileType fileType;
  @HiveField(5)
  final bool taskComplete;

  TaskData({
    required this.fileName,
    required this.filePath,
    required this.uploadStart,
    required this.fileType,
    required this.taskComplete,
    this.uploadEnd,
  });
}
