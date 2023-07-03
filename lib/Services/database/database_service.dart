import 'dart:io';
import 'package:aperture/Services/server_sync/connected_state.dart';
import 'package:aperture/Utils/encrypt.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'directory_data.dart';

class DatabaseService {
  final Box<DirectoryData> dirsBox = Hive.box<DirectoryData>("dirs");
  final Box<dynamic> settingsBox = Hive.box("settings");
  final BuildContext context;

  DatabaseService(this.context) {
    if (settingsBox.containsKey("state")) {
      build();
    }
  }

  Future<void> build() async {
    print("Building database");
    final ConnectedState _state = settingsBox.get("state");
    final res = await syncDatabase(
      ip: _state.ip,
      deviceID: _state.deviceID!,
      deviceName: _state.deviceName!,
      pin: _state.pin!,
    );
    final fileMap = await buildFileMap();
    print("Filemap : ${fileMap}");

    for (final entry in res['local_entries']) {
      final id = entry['id'] as String;
      final fileEntry = entry['entry'];

      if (fileMap.containsKey(id)) {
        final fileLocation = fileMap[id]!;
        final filePath = fileLocation.clientPath;
        fileMap.remove(id);
      } else {
        // Pull the file using pullFile function
        final fileName = fileEntry['file_name'] as String;
        final clientPath = fileEntry['file_location'] as String;
        final relativePath = fileEntry['relative_path'] as String;
        await pullFile(
          ip: _state.ip,
          deviceID: _state.deviceID!,
          deviceName: _state.deviceName!,
          pin: _state.pin!,
          fileName: fileName,
          clientPath: clientPath,
          relativePath: relativePath
        );
      }
    }

    // Remaining entries in fileMap correspond to files that need to be pushed
    for (final fileLocation in fileMap.values) {
      final filePath = fileLocation.clientPath;
      final relativePath = fileLocation.relativePath;
      await pushFile(
        ip: _state.ip,
        deviceID: _state.deviceID!,
        deviceName: _state.deviceName!,
        pin: _state.pin!,
        fileName: filePath.split("/").last,
        relativePath: relativePath,
        dirPath: fileLocation.dirPath,
        clientPath: fileLocation.clientPath
      ); // Modify the arguments accordingly
    }
  }

  List<DirectoryData> get dirs => dirsBox.values.toList(growable: false);

  Future<void> addDirectory(String name, String path) async {
    build();
    await dirsBox.add(DirectoryData(name: name, path: path));
  }

  Future<void> removeDirectory(int index) async {
    await dirsBox.deleteAt(index);
  }

  Future<Map<String, dynamic>> syncDatabase({
    required String ip,
    required String deviceID,
    required String deviceName,
    required String pin,
    bool isGlobal = false,
  }) async {
    try {
      Dio dio = Dio();
      String url = 'http://$ip:8000/sync/database';

      FormData formData = FormData.fromMap({
        'DeviceID': deviceID,
        'DeviceName': deviceName,
        'PIN': pin,
        'Global': isGlobal.toString(),
      });

      Response response = await dio.get(url, data: formData);

      if (response.statusCode == 200) {
        // Handle successful response
        return response.data;
      } else {
        // Handle error response
        throw DioError(
          response: response,
          error: 'Connection failed with status code: ${response.statusCode}',
          requestOptions: response.requestOptions,
        );
      }
    } catch (error) {
      // Handle Dio errors
      rethrow;
    }
  }

  Future<Map<String, FileLocation>> buildFileMap() async {
    final fileMap = <String, FileLocation>{};
    print(dirs);

    // Request necessary permissions

      for (final dirData in dirs) {
        final dirPath = dirData.path;
        final directory = Directory(dirPath);
        // print(directory.list(recursive: true));

        if (directory.existsSync()) {
          await for (final fileEntity in directory.list(recursive: true)) {
            if (fileEntity is File) {
              final relativePath = fileEntity.path.substring(dirPath.length + 1);
              // if (fileEntity) {
              //
              // }
              final hash = createSHA256Hash(relativePath);
              final fileLocation = FileLocation(
                dirPath: dirPath,
                clientPath: fileEntity.path,
                relativePath: relativePath,
              );
              fileMap[hash] = fileLocation;
            }
          }
        }
      }

    return fileMap;
  }

  Future<void> pushFile({
    required String ip,
    required String fileName,
    required String relativePath,
    required String clientPath,
    required String dirPath,
    required String deviceID,
    required String deviceName,
    required String pin,
  }) async {
    print("Pushing from file Path $clientPath");
    try {
      final formData = FormData.fromMap({
        'File': await MultipartFile.fromFile(clientPath, filename: fileName),
        'FileName': fileName,
        'RelativePath': relativePath,
        'DirPath': dirPath,
        'ClientPath': clientPath,
        'DeviceID': deviceID,
        'DeviceName': deviceName,
        'PIN': pin,
      });

      final response =
          await Dio().post('http://$ip:8000/push/file', data: formData);

      if (response.statusCode == 204) {
        print('File pushed successfully');
      } else {
        print('Failed to push file');
      }
    } catch (e) {
      print('Failed to push file: $e');
    }
  }

  Future<void> pullFile({
    required String ip,
    required String fileName,
    required String clientPath,
    required String deviceID,
    required String deviceName,
    required String pin,
    required String relativePath,
  }) async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'http://$ip:8000/pull/file',
        queryParameters: {
          'fileName': fileName,
          'relativePath': relativePath,
          'deviceID': deviceID,
          'deviceName': deviceName,
          'pin': pin,
        },
        options: Options(responseType: ResponseType.bytes),
      );

      final filePath = clientPath;
      await File(filePath).writeAsBytes(response.data);
      print('File pulled and saved to: $filePath');
    } catch (e) {
      print('Failed to pull file: $e');
    }
  }
}

class FileLocation {
  final String dirPath;
  final String clientPath;
  final String relativePath;

  FileLocation({
    required this.dirPath,
    required this.clientPath,
    required this.relativePath,
  });
}
