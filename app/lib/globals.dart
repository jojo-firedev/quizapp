import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:quizapp/models/buzzer_assignment.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/service/buzzer_manager_service.dart';

class Global {
  static List<Socket> sockets = [];
  static List<String> macs = [];
  static ConnectionMode connectionMode = ConnectionMode.idle;
  static BuzzerType buzzerType = BuzzerType.udp;
  static bool isBuzzerLocked = false;
  static List<BuzzerAssignment> assignedBuzzer = [];
  static Jugendfeuerwehr? currentAssignmentData;
  static final streamController = StreamController<Map<String, dynamic>>();
  static BuzzerManagerService? buzzerManagerService;

  static Logger logger = Logger(
    printer: PrettyPrinter(),
    level: Level.debug, // Set the logging level
  );

  static void printSockets() {
    Global.logger.d('Sockets: ${sockets.length}');
  }
}
