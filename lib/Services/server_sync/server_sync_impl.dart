import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'connected_state.dart';

class ServerSyncService {
  ConnectedState _state;
  late Box<ConnectedState> stateBox;
  final Box<dynamic> settingsBox = Hive.box("settings");

  ServerSyncService({ConnectedState? state})
      : _state = state ??
            ConnectedState(
              connected: false,
              ip: "",
            ) {
    init();
  }

  Future<void> init() async {
    stateBox = await Hive.openBox<ConnectedState>("connectState");
    if (_state.connected && _state.ip.isNotEmpty && _state.pin != null) {

    }
  }

  ConnectedState get state => _state;

  Future<void> connect({
    required String ip,
    required String deviceID,
    required String deviceName,
    required String pin,
    String? location,
    bool global = false,
    bool readOnly = false,
  }) async {
    try {
      Dio dio = Dio();
      String url = 'http://$ip:8000/sync/connect';

      FormData formData = FormData.fromMap({
        'DeviceID': deviceID,
        'DeviceName': deviceName,
        'PIN': pin,
        'Location': location ?? '',
        "OS": "{\"Android\":13.0}"
        // 'Global': global.toString(),
        // 'ReadOnly': readOnly.toString(),
      });

      Response response = await dio.get(url, data: formData);

      if (response.statusCode == 200) {
        // Handle successful response
        print('Connection successful');
        _state = ConnectedState(
          connected: true,
          ip: ip,
          lastConnected: DateTime.now(),
          pin: pin,
          deviceID: deviceID,
          deviceName: deviceName,
        );
        stateBox.put(ip, _state);
        settingsBox.put("state", _state);
      } else {
        // Handle error response
        print('Connection failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle Dio errors
      print('Error: $error');
    }
  }

  Future<bool> tryConnect(
      {required String ip,
      required String deviceID,
      required String deviceName}) async {
    Dio dio = Dio();

    // Check for cache
    final cache = await checkStoredCache(ip);
    if (cache != null) {
      return true;
    }
    try {
      FormData formData = FormData.fromMap({
        'DeviceID': deviceID,
        'DeviceName': deviceName,
      });
      Response response = await dio.get(
        'http://$ip:8000/sync/server',
        data: formData,
      );
      if (response.statusCode == 200) {
        // Process the response as needed
        Map<String, dynamic> jsonData = response.data;

        String deviceId = jsonData['DeviceID'];
        String devName = jsonData['DeviceName'];
        String lastSync = jsonData['LastSync'];
        bool isGlobal = jsonData['Global'];

        return true;
      }
      return false;
    } on DioError catch (e, stack) {
      // Handle any errors that occur during the request
      if (e.type == DioErrorType.badResponse) {
        // Not in databasee create new connection'
        return false;
      }
      print('Error: ${e.type}');
      rethrow;
    }
  }


  Future<ConnectedState?> checkStoredCache(String ip) async {
    if (stateBox.containsKey(ip)) {
      return stateBox.get(ip);
    }
    return null;
  }
}
