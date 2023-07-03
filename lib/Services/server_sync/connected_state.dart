import 'package:hive/hive.dart';

part 'connected_state.g.dart';

@HiveType(typeId: 0, adapterName: "ConnectedStateAdapter")
class ConnectedState {
  @HiveField(0)
  final bool connected;
  @HiveField(1)
  final String ip;
  @HiveField(2)
  final DateTime? lastConnected;
  @HiveField(3)
  final String? pin;
  @HiveField(4)
  final String? deviceName;
  @HiveField(5)
  final String? deviceID;

  ConnectedState({
    required this.connected,
    required this.ip,
    this.lastConnected,
    this.pin,
    this.deviceName,
    this.deviceID
  });
}
