import 'package:aperture/Pages/folders/folders_page.dart';
import 'package:aperture/Pages/tasks/tasks_widget.dart';
import 'package:aperture/Services/database/database_service.dart';
import 'package:aperture/Services/server_sync/server_sync_impl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../../Services/database/directory_data.dart';
import 'connect.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  Future<String?> selectFolder(BuildContext context) async {
    String? result = await FilePicker.platform.getDirectoryPath();

    if (result != null) {
      return result;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No folder selected')),
      );
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final syncService = context.read<ServerSyncService>();
    final dbService = context.read<DatabaseService>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(widget.title),
        centerTitle: true,
        actions: [],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  title: Text('Directories'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ValueListenableBuilder<Box<DirectoryData>>(
                            valueListenable: Hive.box<DirectoryData>("dirs").listenable(),
                            builder: (context, box, _) {
                              return DirectoriesPage(directories: box.values.toList(growable: false));
                            }
                          );
                        },
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Home'),
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => HomePage()),
                    // );
                  },
                ),
                ListTile(
                  title: Text('QR'),
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => HomePage()),
                    // );
                  },
                ),
                Expanded(child: Container()),
                ListTile(
                  title: Text('Settings'),
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => SettingsPage()),
                    // );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: ValueListenableBuilder<Box<dynamic>>(
              valueListenable: Hive.box("settings").listenable(keys: ["state"]),
              builder: (context, box, _) {
                return ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ServerState(connectedState: syncService.state),
                    if (!syncService.state.connected) ...{
                      const ConnectServer()
                    },
                    const TasksWidget(),
                  ],
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await selectFolder(context);
          if (res!=null) {
            final name = res.split("/").last;
            dbService.addDirectory(name, res);
            print("${name} or ${res}");
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
