import 'dart:io';

import 'package:quizapp/service/buzzer_socket_service.dart';

class Global {
  static List<Socket> sockets = [];
  static List<String> macs = [];
  static BuzzerSocketService? buzzerSocketService;

  static void printSockets() {
    print('Sockets: ${sockets.length}');
  }
}
