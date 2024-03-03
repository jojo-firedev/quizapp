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
          BuzzerUdpService().sendBuzzerRelease();
          break;
        case ConnectionMode.assignment:
          print('Received message: $jsonObject for Assignement');
          if (jsonObject.values.first != 'ButtonPressed') {
            break;
          } else if (Global.currentAssignmentData == null) {
            break;
          }

          Global.assignedBuzzer.add(BuzzerAssignment(
              gemeinde: Global.currentAssignmentData!.gemeinde,
              name: Global.currentAssignmentData!.name,
              mac: jsonObject.keys.first));
          Global.logger.d(Global.assignedBuzzer.toString());
          Global.currentAssignmentData = null;
          sendBuzzerRelease();
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
              break;
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
}

enum BuzzerType { udp, socket, silent }

enum ConnectionMode {
  idle,
  parring,
  assignment,
  game,
}
