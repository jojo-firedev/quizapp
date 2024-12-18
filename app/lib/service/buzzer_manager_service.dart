import 'dart:async';
import 'dart:convert';

import 'package:quizapp/globals.dart';
import 'package:quizapp/models/buzzer_tisch_zuordnung.dart';
import 'package:quizapp/service/buzzer_socket_service.dart';
import 'package:quizapp/service/buzzer_udp_listener_service.dart';
import 'package:quizapp/service/buzzer_udp_service.dart';

class BuzzerManagerService {
  late BuzzerUdpService buzzerUdpService;
  late BuzzerUdpListenerService buzzerUdpListenerService;
  late BuzzerSocketService buzzerSocketService;

  final _streamController = StreamController<Map<String, dynamic>>();

  // Create a broadcast stream once at initialization
  late final Stream<Map<String, dynamic>> _broadcastStream;

  BuzzerManagerService() {
    // Convert the original stream to a broadcast stream once
    _broadcastStream = _streamController.stream.asBroadcastStream();
    setup();
  }

  // Expose the broadcast stream
  Stream<Map<String, dynamic>> get stream => _broadcastStream;

  void setup() {
    buzzerUdpService = BuzzerUdpService();

    if (Global.buzzerType == BuzzerType.socket) {
      buzzerSocketService = BuzzerSocketService();
    } else if (Global.buzzerType == BuzzerType.udp) {
      buzzerUdpListenerService = BuzzerUdpListenerService();
    }
  }

  void close() {
    _streamController.close(); // Close the stream controller
    if (Global.buzzerType == BuzzerType.udp) {
      buzzerUdpListenerService.stopListening();
    } else {
      buzzerSocketService.stopListening();
    }
  }

  void handleMessage(String message, String senderAddress, int senderPort) {
    Map<String, dynamic> jsonObject = jsonDecode(message);

    _streamController.sink.add(jsonObject);
    Global.logger
        .d('Received message from $senderAddress:$senderPort: $message');

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
        if (jsonObject.values.first != 'ButtonPressed') {
          break;
        } else if (Global.currentAssignmentData == null) {
          break;
        } else if (Global.buzzerTischZuordnung
            .any((element) => element.tisch == Global.currentAssignmentData)) {
          break;
        }

        Global.buzzerTischZuordnung.add(BuzzerTischZuordnung(
            tisch: Global.currentAssignmentData!, mac: jsonObject.keys.first));
        Global.logger.d(Global.buzzerTischZuordnung.toString());
        Global.currentAssignmentData = null;

        List<String> macs =
            Global.buzzerTischZuordnung.map((e) => e.mac).toList();
        Global.buzzerManagerService.sendBuzzerRelease(macs: macs);
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
  }

  void sendConfig() {
    buzzerUdpService.sendConfig();
  }

  void connectAllBuzzer() {
    Global.connectionMode = ConnectionMode.parring;
    sendBuzzerRelease();
  }

  void sendBuzzerLock({String? mac, List<String>? macs}) {
    if (macs == null) {
      if (mac == null) {
        macs = [];
      } else {
        macs = [mac];
      }
    }

    if (Global.buzzerType == BuzzerType.socket) {
      buzzerSocketService.sendBuzzerLock(macs: macs);
    } else if (Global.buzzerType == BuzzerType.udp) {
      buzzerUdpService.sendBuzzerLock(macs: macs);
    }
  }

  void sendBuzzerRelease({String? mac, List<String>? macs}) {
    if (macs == null) {
      if (mac == null) {
        macs = [];
      } else {
        macs = [mac];
      }
    }

    if (Global.buzzerType == BuzzerType.socket) {
      buzzerSocketService.sendBuzzerRelease(macs: macs);
    } else if (Global.buzzerType == BuzzerType.udp) {
      buzzerUdpService.sendBuzzerRelease(macs: macs);
    }
  }

  void sendPing() {
    if (Global.buzzerType == BuzzerType.socket) {
      buzzerSocketService.sendPing();
    } else if (Global.buzzerType == BuzzerType.udp) {
      buzzerUdpService.sendPing();
    }
  }
}

enum BuzzerType { udp, socket, silent }

enum ConnectionMode {
  idle,
  parring,
  assignment,
  game,
}
