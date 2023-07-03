import 'package:aperture/Services/server_sync/server_sync_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showPinInputDialog({
  required BuildContext context,
  required ip,
  required String deviceID,
  required String deviceName,
}) async {
  final ServerSyncService syncService = context.read();
  final pin = TextEditingController();
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Enter PIN'),
        content: TextField(
          decoration: InputDecoration(hintText: 'Enter PIN'),
          controller: pin,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Submit'),
            onPressed: () async{
              await syncService.connect(
                ip: ip,
                deviceID: deviceID,
                deviceName: deviceName,
                pin: pin.text.trim(),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  // Handle the submitted PIN
}

Future<void> showExtendedInputDialog(
    {required BuildContext context,
    required String deviceID,
    required String deviceName,
    required String ip}) async {
  // Show dialog with extended inputs
  // Customize this dialog according to your needs
  TextEditingController pin = TextEditingController();
  TextEditingController name = TextEditingController(text: deviceName);
  TextEditingController id = TextEditingController(text: deviceID);
  bool isGlobal = false;
  bool isReadOnly = false;
  final ServerSyncService syncService = context.read();
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Enter Details'),
        content: Column(
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Enter PIN'),
              controller: pin,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Override Name'),
              controller: name,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Override ID'),
              controller: id,
            ),
            Row(
              children: [
                Checkbox(
                  value: isGlobal,
                  onChanged: (value) {
                    isGlobal = value!;
                  },
                ),
                const Text('Global'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isReadOnly,
                  onChanged: (value) {
                    isReadOnly = value!;
                  },
                ),
                const Text('Read Only'),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Submit'),
            onPressed: () async {
              await syncService.connect(
                ip: ip,
                deviceID: id.text.trim(),
                deviceName: name.text.trim(),
                pin: pin.text.trim(),
              );
              Navigator.of(context).pop();
              // Handle the submitted values
            },
          ),
        ],
      );
    },
  );
  // Handle the submitted values
}
