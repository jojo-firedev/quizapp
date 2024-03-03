import 'package:quizapp/globals.dart';
import 'package:quizapp/models/buzzer_assignment.dart';
import 'package:quizapp/service/buzzer_socket_service.dart';
import 'package:quizapp/service/buzzer_udp_listener_service.dart';
import 'package:quizapp/service/buzzer_udp_service.dart';

class BuzzerManagerService {
  late BuzzerUdpService buzzerUdpService;
  late BuzzerUdpListenerService buzzerUdpListenerService;
  late BuzzerSocketService buzzerSocketService;

  BuzzerManagerService() {
    setup();
  }

  void setup() {
    if (Global.buzzerType == BuzzerType.socket) {
      buzzerSocketService = BuzzerSocketService();
    } else if (Global.buzzerType == BuzzerType.udp) {
      buzzerUdpService = BuzzerUdpService();
      buzzerUdpListenerService = BuzzerUdpListenerService();
    }
  }

  void close() {
    if (Global.buzzerType == BuzzerType.udp) {
      buzzerUdpListenerService.stopListening();
    } else {
      buzzerSocketService.stopListening();
    }
  }

  void sendConfig() {
    buzzerUdpService.sendConfig();
  }

  void connectAllBuzzer() {
    Global.connectionMode = ConnectionMode.parring;
    sendBuzzerRelease();
  }

  void sendBuzzerLock({String? winnerMac}) {
    if (Global.buzzerType == BuzzerType.socket) {
      buzzerSocketService.sendBuzzerLock(winnerMac: winnerMac);
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
