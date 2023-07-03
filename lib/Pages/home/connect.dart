import 'package:animated_icon/animated_icon.dart';
import 'package:aperture/Pages/home/dialogs.dart';
import 'package:aperture/Services/server_sync/connected_state.dart';
import 'package:aperture/Services/server_sync/server_sync_impl.dart';
import 'package:aperture/Utils/device_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectServer extends StatefulWidget {
  const ConnectServer({super.key, this.connectedState});

  final ConnectedState? connectedState;

  @override
  State<ConnectServer> createState() => _ConnectServerState();
}

class _ConnectServerState extends State<ConnectServer> {
  final ipTextController = TextEditingController();
  bool help_expanded = false;

  Future<void> handleConnection(
      BuildContext context, ServerSyncService syncService) async {
    final info = await getDeviceInfo();
    final res = await syncService.tryConnect(
      ip: ipTextController.text.trim(),
      deviceID: info.deviceModelName,
      deviceName: info.deviceName,
    );
    if (res) {
      await showPinInputDialog(
        context: context,
        deviceName: info.deviceName,
        deviceID: info.deviceModelName,
        ip: ipTextController.text.trim(),
      );
    } else {
      showExtendedInputDialog(
        context: context,
        deviceName: info.deviceName,
        deviceID: info.deviceModelName,
        ip: ipTextController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final syncService = context.read<ServerSyncService>();
    return Container(
      decoration: BoxDecoration(
          color: theme.primaryColorDark,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: ipTextController,
            maxLines: 1,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter the IP",
              border: InputBorder.none,
              label: Text('I.P. Address'),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              handleConnection(context, syncService);
            },
            child: const Text('Connect'),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            // constraints: BoxConstraints(maxHeight: 1000),
            child: ExpansionPanelList(
              expansionCallback: (i, v) {
                setState(() {
                  help_expanded = !help_expanded;
                });
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text("Can't find the IP address ?"));
                  },
                  body: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset("assets/helpIP.png"),
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'You can find the ip on the top right corner of the application',
                          softWrap: true,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                  isExpanded: help_expanded,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ServerState extends StatefulWidget {
  const ServerState({super.key, required this.connectedState});

  final ConnectedState connectedState;

  @override
  State<ServerState> createState() => _ServerStateState();
}

class _ServerStateState extends State<ServerState> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.primaryColorDark),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!widget.connectedState.connected) ...{
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AnimateIcon(
                  animateIcon: AnimateIcons.tongueOut,
                  color: theme.colorScheme.primary,
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                ),
                const Text('Not connected to a Server!'),
              ],
            ),
          } else ...{
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AnimateIcon(
                  animateIcon: AnimateIcons.internet,
                  color: theme.colorScheme.secondary,
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                ),
                Text('Connected to : ${widget.connectedState.ip}'),
              ],
            ),
          }
        ],
      ),
    );
  }
}
