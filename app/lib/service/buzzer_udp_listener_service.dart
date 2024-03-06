import 'dart:convert';
import 'dart:io';

import 'package:quizapp/globals.dart';
import 'package:quizapp/models/buzzer_assignment.dart';
import 'package:quizapp/service/buzzer_manager_service.dart';

class BuzzerUdpListenerService {
  RawDatagramSocket? _socket;
  final int buzzerUdpPort = 8090;
  final int localUdpPort = 8084;

  BuzzerUdpListenerService() {
    startListening();
    Global.logger.d('Buzzer UDP listener started on port $localUdpPort');
  }

  void startListening() async {
    try {
      // Create a new UDP socket
      _socket =
          await RawDatagramSocket.bind(InternetAddress.anyIPv4, localUdpPort);

      // Listen for UDP packets
      _socket!.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram? result = _socket!.receive();
          if (result != null) {
            String message = utf8.decode(result.data);
            Map<String, dynamic> jsonObject = jsonDecode(message);

            Global.logger.d(
                'Received message from ${result.address.address}:${result.port}: $message');

            print(Global.connectionMode);

            switch (Global.connectionMode) {
              case ConnectionMode.idle:
                break;
              case ConnectionMode.parring:
                String mac = jsonObject.keys.first;
                if (!Global.macs.contains(mac)) {
                  Global.macs.add(mac);
                  Global.logger.d('Added mac: $mac');
                }
                Global.logger.d(Global.macs);
                Global.buzzerManagerService.sendBuzzerRelease();
                break;
              case ConnectionMode.assignment:
                print('Received message: $jsonObject for Assignement');
                if (jsonObject.values.first != 'ButtonPressed') {
                  break;
                } else if (Global.currentAssignmentData == null) {
                  break;
                }
                Global.assignedBuzzer.add(BuzzerAssignment(
                    tisch: Global.currentAssignmentData!,
                    mac: jsonObject.keys.first));
                Global.logger.d(Global.assignedBuzzer.toString());
                Global.currentAssignmentData = null;
                Global.buzzerManagerService.sendBuzzerRelease();
                break;
              case ConnectionMode.game:
                switch (jsonObject.values.first) {
                  case 'Connected':
                    String mac = jsonObject.keys.first;
                    if (!Global.macs.contains(mac)) {
                      Global.macs.add(mac);
                    }
                    break;
                  case 'ButtonPressed':
                    String mac = jsonObject.keys.first;
                    if (!Global.macs.contains(mac)) {
                      Global.macs.add(mac);
                    }
                    Global.buzzerManagerService.sendBuzzerLock(mac: mac);
                    break;
                  default:
                    break;
                }
              default:
                break;
            }

            Global.streamController.add(jsonObject);
          }
        }
      });
    } catch (e) {
      Global.logger.d('Error: $e');
    }
  }

  void stopListening() {
    _socket?.close();
  }
}
