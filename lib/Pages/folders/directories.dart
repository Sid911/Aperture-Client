import 'package:aperture/Services/database/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Services/database/directory_data.dart';

class Directories extends StatelessWidget {
  final List<DirectoryData> directories;

  Directories({required this.directories});

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = context.read();
    return ListView.builder(
      itemCount: directories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        DirectoryData directory = directories[index];
        return ListTile(
          title: Text(directory.name),
          subtitle: Text(directory.path),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'delete_locally') {
                // Delete locally
                deleteLocally(directory);
              } else if (value == 'delete_everywhere') {
                // Delete everywhere
                deleteEverywhere(index, db);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete_locally',
                child: Text('Delete Locally'),
              ),
              const PopupMenuItem<String>(
                value: 'delete_everywhere',
                child: Text('Delete Everywhere'),
              ),
            ],
          ),
          onTap: () {
            // Launch file browser
            launchFileBrowser(directory.path, context);
          },
        );
      },
    );
  }

  void deleteLocally(DirectoryData directory) {
    // Handle delete locally
    print('Delete locally: ${directory.name}');
  }

  void deleteEverywhere(int index, DatabaseService db) {
    db.removeDirectory(index);
    // print('Delete everywhere: ${directory.name}');
  }

  void launchFileBrowser(String path, BuildContext context) async {
    try {
      if (await canLaunchUrl(Uri.file(path))) {
        await launchUrl(Uri.file(path));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot launch file browser')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching file browser')),
      );
    }
  }
}