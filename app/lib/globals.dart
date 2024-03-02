import 'dart:io';

import 'package:logger/logger.dart';

class Global {
  static List<Socket> sockets = [];
  static List<String> macs = [];
  // static BuzzerSocketService? buzzerSocketService;
  static Logger logger = Logger(
    printer: PrettyPrinter(),
    level: Level.debug, // Set the logging level
  );

  static void printSockets() {
    Global.logger.d('Sockets: ${sockets.length}');
  }
}