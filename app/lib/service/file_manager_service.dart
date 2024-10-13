import 'dart:convert';
import 'dart:io';

import 'package:quizapp/models/buzzer_assignment.dart';
import 'package:quizapp/models/fragen.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';

class FileManagerService {
  const FileManagerService();

  void saveJFs(List<Jugendfeuerwehr> jf) {
    final jfJson = jf.map((e) => e.toJson()).toList();
    final jfString = jsonEncode(jfJson);
    File('assets/data/jugendfeuerwehren.json').writeAsString(jfString);
  }

  Future<List<Jugendfeuerwehr>> readJFs() async {
    final jsonString =
        await File('assets/data/jugendfeuerwehren.json').readAsString();
    final jfJson = jsonDecode(jsonString);
    final jf = jfJson
        .map<Jugendfeuerwehr>((e) => Jugendfeuerwehr.fromJson(e))
        .toList();
    return jf;
  }

  void saveBuzzerAssignment(List<BuzzerAssignment> buzzerAssignment) {
    final buzzerAssignmentJson =
        buzzerAssignment.map((e) => e.toJson()).toList();
    final buzzerAssignmentString = jsonEncode(buzzerAssignmentJson);
    File('assets/data/buzzer_assignment.json')
        .writeAsString(buzzerAssignmentString);
  }

  Future<List<BuzzerAssignment>> readBuzzerAssignment() async {
    final jsonString =
        await File('assets/data/buzzer_assignment.json').readAsString();
    final buzzerAssignmentJson = jsonDecode(jsonString);
    final buzzerAssignment = buzzerAssignmentJson
        .map<BuzzerAssignment>((e) => BuzzerAssignment.fromJson(e))
        .toList();
    return buzzerAssignment;
  }

  Future<FragenList> readFragen() async {
    final jsonString = await File('assets/data/fragen.json').readAsString();
    final fragenJson = jsonDecode(jsonString);
    final fragen = FragenList.fromJson(fragenJson);
    return fragen;
  }

  void saveFragen(FragenList fragenList) {
    final fragenString = fragenList.toRawJson();
    File('assets/data/fragen.json').writeAsString(fragenString);
  }
}
