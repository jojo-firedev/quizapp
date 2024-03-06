import 'dart:convert';
import 'dart:io';

import 'package:quizapp/models/buzzer_assignment.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';

class FileManagerService {
  const FileManagerService();

  void saveJFsToJson(List<Jugendfeuerwehr> jf) {
    final jfJson = jf.map((e) => e.toJson()).toList();
    final jfString = jsonEncode(jfJson);
    File('assets/data/jugendfeuerwehren.json').writeAsString(jfString);
  }

  Future<List<Jugendfeuerwehr>> readAllJFsFromJson() async {
    final jsonString =
        await File('assets/data/jugendfeuerwehren.json').readAsString();
    final jfJson = jsonDecode(jsonString);
    final jf = jfJson
        .map<Jugendfeuerwehr>((e) => Jugendfeuerwehr.fromJson(e))
        .toList();
    return jf;
  }

  void saveBuzzerAssignmentToJson(List<BuzzerAssignment> buzzerAssignment) {
    final buzzerAssignmentJson =
        buzzerAssignment.map((e) => e.toJson()).toList();
    final buzzerAssignmentString = jsonEncode(buzzerAssignmentJson);
    File('assets/data/buzzer_assignment.json')
        .writeAsString(buzzerAssignmentString);
  }

  Future<List<BuzzerAssignment>> readBuzzerAssignmentFromJson() async {
    final jsonString =
        await File('assets/data/buzzer_assignment.json').readAsString();
    final buzzerAssignmentJson = jsonDecode(jsonString);
    final buzzerAssignment = buzzerAssignmentJson
        .map<BuzzerAssignment>((e) => BuzzerAssignment.fromJson(e))
        .toList();
    return buzzerAssignment;
  }
}
