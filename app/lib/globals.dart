import 'dart:io';

import 'package:logger/logger.dart';
import 'package:quizapp/models/buzzer_tisch_zuordnung.dart';
import 'package:quizapp/models/kategorie.dart';
import 'package:quizapp/models/teilnehmer.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/service/buzzer_manager_service.dart';
import 'package:quizapp/service/screen_app_service.dart';

class Global {
  static String jsonDateiPfad = '';
  static List<Socket> sockets = [];
  static List<String> macs = [];
  static ConnectionMode connectionMode = ConnectionMode.idle;
  static BuzzerType buzzerType = BuzzerType.socket;
  static List<BuzzerTischZuordnung> buzzerTischZuordnung = [];
  static List<Jugendfeuerwehr> jugendfeuerwehren = [];
  static List<Teilnehmer> teilnehmer = [];
  static List<Kategorie> kategorien = [];
  static int? currentAssignmentData;
  static BuzzerManagerService buzzerManagerService = BuzzerManagerService();
  static ScreenAppService screenAppService = ScreenAppService();

  static Logger logger = Logger(
    printer: PrettyPrinter(),
    level: Level.debug, // Set the logging level
  );

  static void printSockets() {
    Global.logger.d('Sockets: ${sockets.length}');
  }
}
