import 'package:aperture/Pages/home/homepage.dart';
import 'package:aperture/Services/database/database_service.dart';
import 'package:aperture/Services/database/directory_data.dart';
import 'package:aperture/Services/database/local_entry.dart';
import 'package:aperture/Services/server_sync/connected_state.dart';
import 'package:aperture/Services/server_sync/server_sync_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> hiveInit() async{
  await Hive.initFlutter();
  Hive.registerAdapter(ConnectedStateAdapter());
  Hive.registerAdapter(DirectoryDataAdapter());
  Hive.registerAdapter(LocalEntryAdapter());
  await Hive.openBox("settings");
  await Hive.openBox<DirectoryData>("dirs");
  await Hive.openBox<LocalEntry>("database");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hiveInit();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const InitApp());
}

class InitApp extends StatefulWidget {
  const InitApp({super.key});

  @override
  State<InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {



  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box("settings").listenable(),
      builder: (context, box, _) {
        final state = box.containsKey("state")? box.get("state") : null;
        return MultiProvider(
          providers: [
            Provider<ServerSyncService>(create: (_) => ServerSyncService(state: state)),
            Provider<DatabaseService>(create: (_) => DatabaseService(_))
          ],
          child: const MyApp(),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Permission.manageExternalStorage.request();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aperture',
      theme: ThemeData(
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, brightness: Brightness.dark)),
      home: const HomePage(title: 'Aperture'),
      debugShowCheckedModeBanner: false,
    );
  }
}

