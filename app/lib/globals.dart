import 'dart:io';

import 'package:logger/logger.dart';
import 'package:quizapp/models/buzzer_assignment.dart';
import 'package:quizapp/models/jf_buzzer_assignment.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/models/punkte.dart';
import 'package:quizapp/service/buzzer_manager_service.dart';

class Global {
  static List<Socket> sockets = [];
  static List<String> macs = [];
  static ConnectionMode connectionMode = ConnectionMode.idle;
  static BuzzerType buzzerType = BuzzerType.socket;
  static List<BuzzerAssignment> assignedBuzzer = [];
  static List<Jugendfeuerwehr> jugendfeuerwehren = [];
  static List<JfBuzzerAssignment> jfBuzzerAssignments = [];
  static List<GlobalerPunkteSpeicher> globalerPunkteSpeicher = [];
  static int? currentAssignmentData;
  static BuzzerManagerService buzzerManagerService = BuzzerManagerService();

  static Logger logger = Logger(
    printer: PrettyPrinter(),
    level: Level.debug, // Set the logging level
  );

  static void printSockets() {
    Global.logger.d('Sockets: ${sockets.length}');
  }
}
