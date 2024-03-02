import 'dart:convert';

import 'package:quizapp/globals.dart';
import 'package:quizapp/service/buzzer_socket_service.dart';
import 'package:quizapp/service/buzzer_udp_listener_service.dart';
import 'package:quizapp/service/buzzer_udp_service.dart';

class BuzzerManagerService {
  BuzzerType buzzerType = BuzzerType.udp;
  bool _isBuzzerLocked = false;
  late BuzzerUdpService buzzerUdpService;
  late BuzzerUdpListenerService buzzerUdpListenerService;
  late BuzzerSocketService buzzerSocketService;

  BuzzerManagerService(this.buzzerType) {
    setup();
  }

  bool get isBuzzerLocked => _isBuzzerLocked;

  set isBuzzerLocked(bool value) {
    _isBuzzerLocked = value;
  }

  void setup() {
    if (buzzerType == BuzzerType.socket) {
      buzzerSocketService = BuzzerSocketService();
    } else if (buzzerType == BuzzerType.udp) {
      buzzerUdpService = BuzzerUdpService();
      buzzerUdpListenerService = BuzzerUdpListenerService();
    }
  }

  void sendConfig() {
    buzzerUdpService.sendConfigWithIP();
  }

  void sendBuzzerLock() {
    if (buzzerType == BuzzerType.socket) {
      buzzerSocketService.sendBuzzerLock();
    } else if (buzzerType == BuzzerType.udp) {
      buzzerUdpService.sendBuzzerLock();
    }
  }

  void sendBuzzerRelease() {
    if (buzzerType == BuzzerType.socket) {
      buzzerSocketService.sendBuzzerRelease();
    } else if (buzzerType == BuzzerType.udp) {
      buzzerUdpService.sendBuzzerRelease();
    }
  }

  void sendPing() {
    if (buzzerType == BuzzerType.socket) {
      buzzerSocketService.sendPing();
    } else if (buzzerType == BuzzerType.udp) {
      buzzerUdpService.sendPing();
    }
  }

  void handleMessage(data, ip, port, internalbuzzerType) {
    String message = utf8.decode(data);
    Map<String, dynamic> jsonObject = jsonDecode(message);

    Global.logger.d('Received message from $ip:$port: $message');

    if (jsonObject.values.first == 'Connected') {
      String mac = jsonObject.keys.first;
      Global.macs.add(mac);
    } else if (jsonObject.values.first == 'ButtonPressed') {
      print('Button pressed');
      String mac = jsonObject.keys.first;
      if (internalbuzzerType == BuzzerType.socket) {
        buzzerSocketService.sendBuzzerLock(winnerMac: mac);
      } else if (internalbuzzerType == BuzzerType.udp) {
        buzzerUdpService.sendBuzzerLock(winnerMac: mac);
      }
    }
  }
}

enum BuzzerType { udp, socket, silent }
