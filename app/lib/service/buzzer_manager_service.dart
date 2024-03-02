import 'dart:async';

import 'package:quizapp/globals.dart';
import 'package:quizapp/models/buzzer_assignment.dart';
import 'package:quizapp/service/buzzer_socket_service.dart';
import 'package:quizapp/service/buzzer_udp_listener_service.dart';
import 'package:quizapp/service/buzzer_udp_service.dart';

class BuzzerManagerService {
  late BuzzerUdpService buzzerUdpService;
  late BuzzerUdpListenerService buzzerUdpListenerService;
  late BuzzerSocketService buzzerSocketService;

  BuzzerManagerService();

  void setup() {
    if (Global.buzzerType == BuzzerType.socket) {
      buzzerSocketService = BuzzerSocketService();
    } else if (Global.buzzerType == BuzzerType.udp) {
      buzzerUdpService = BuzzerUdpService();
      buzzerUdpListenerService = BuzzerUdpListenerService();
    }
  }

  void listenToStream() {
    Global.streamController.stream.listen((event) {
      Map<String, dynamic> jsonObject = event;

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
          BuzzerUdpService().sendBuzzerRelease();
        case ConnectionMode.assignment:
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
              BuzzerUdpService().sendBuzzerLock(winnerMac: mac);
              break;
            default:
          }
        default:
          break;
      }
    });
  }

  void sendConfig() {
    buzzerUdpService.sendConfig();
  }

  void connectAllBuzzer() {
    Global.connectionMode = ConnectionMode.parring;
    sendBuzzerRelease();
  }

  void sendBuzzerLock() {
    if (Global.buzzerType == BuzzerType.socket) {
      buzzerSocketService.sendBuzzerLock();
    } else if (Global.buzzerType == BuzzerType.udp) {
      buzzerUdpService.sendBuzzerLock();
    }
  }

  void sendBuzzerRelease() {
    if (Global.buzzerType == BuzzerType.socket) {
      buzzerSocketService.sendBuzzerRelease();
    } else if (Global.buzzerType == BuzzerType.udp) {
      buzzerUdpService.sendBuzzerRelease();
    }
  }

  void sendPing() {
    if (Global.buzzerType == BuzzerType.socket) {
      buzzerSocketService.sendPing();
    } else if (Global.buzzerType == BuzzerType.udp) {
      buzzerUdpService.sendPing();
    }
  }

  void assignBuzzer({required String name, required String gemeinde}) {
    print('Start assigning buzzer for $name');
    StreamSubscription<Map<String, dynamic>> subscription =
        Global.streamController.stream.listen((event) async {});

    subscription.onData((data) {
      String mac = data.keys.first;

      assignBuzzerToJugendfeuerwehr(name: name, gemeinde: gemeinde, mac: mac);
      subscription.cancel();
    });
  }

  void assignBuzzerToJugendfeuerwehr(
      {required String name, required String gemeinde, required String mac}) {
    print('Assigne Buzzer $mac to $name');
    Global.assignedBuzzer.add(BuzzerAssignment(
      name: name,
      gemeinde: gemeinde,
      mac: mac,
    ));
  }
}

enum BuzzerType { udp, socket, silent }

enum ConnectionMode {
  idle,
  parring,
  assignment,
  game,
}
