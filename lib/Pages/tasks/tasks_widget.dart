import 'package:aperture/Services/server_sync/task_data.dart';
import 'package:aperture/Utils/file_type.dart';
import 'package:flutter/material.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "Tasks",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_circle_right_outlined),
              ),
            ],
          ),
          TaskTile(
            taskData: TaskData(
              fileName: "Photo.png",
              filePath: "/DCIM/Photo.png",
              fileType: FileType.image,
              taskComplete: false,
              uploadStart: DateTime.now(),
            ),
          ),
          TaskTile(
            taskData: TaskData(
              fileName: "Snapchat",
              filePath: "/DCIM/Snapchat",
              fileType: FileType.folder,
              taskComplete: false,
              uploadStart: DateTime.now(),
            ),
          )
        ],
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.taskData});

  final TaskData taskData;
  final bool isDownload = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(taskData.fileName),
      tileColor: theme.primaryColorDark,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Initializing',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const LinearProgressIndicator()
        ],
      ),
      trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      dense: true,
      // isThreeLine: true,
      minVerticalPadding: 10,
      leading: Icon(
        taskData.fileType.getIconData(isDownload: isDownload),
      ),
    );
  }
}
