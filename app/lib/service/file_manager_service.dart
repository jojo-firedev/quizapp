import 'dart:convert';
import 'dart:io';

import 'package:quizapp/models/buzzer_assignment.dart';
import 'package:quizapp/models/fragen.dart';
import 'package:quizapp/models/jf_buzzer_assignment.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/models/points.dart';

class FileManagerService {
  const FileManagerService();

  // Generische Methode zum Speichern von JSON-Dateien
  Future<void> _saveToFile<T>(
    String fileName,
    List<T> data,
    Function(T) toJson,
  ) async {
    String path = Platform.isLinux ? '/home/pi/quizapp/data/' : 'assets/data/';

    final jsonString = jsonEncode(data.map((e) => toJson(e)).toList());
    await File(path).writeAsString(jsonString);
  }

  // Generische Methode zum Lesen von JSON-Dateien
  Future<List<T>> _readFromFile<T>(
    String fileName,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    String path = Platform.isLinux ? '/home/pi/quizapp/data/' : 'assets/data/';

    try {
      final jsonString = await File(path).readAsString();
      final jsonData = jsonDecode(jsonString) as List;
      return jsonData.map<T>((json) => fromJson(json)).toList();
    } catch (e) {
      print("Error reading file: $e");
      return [];
    }
  }

  Future<void> saveJFs(List<Jugendfeuerwehr> jf) async {
    await _saveToFile('jugendfeuerwehren.json', jf, (e) => e.toJson());
  }

  Future<List<Jugendfeuerwehr>> readJFs() async {
    return _readFromFile('jugendfeuerwehren.json', Jugendfeuerwehr.fromJson);
  }

  Future<void> saveBuzzerAssignment(
      List<BuzzerAssignment> buzzerAssignment) async {
    await _saveToFile(
        'buzzer_assignment.json', buzzerAssignment, (e) => e.toJson());
  }

  Future<List<BuzzerAssignment>> readBuzzerAssignment() async {
    return _readFromFile('buzzer_assignment.json', BuzzerAssignment.fromJson);
  }

  Future<FragenList> readFragen() async {
    try {
      final jsonString = await File('fragen.json').readAsString();
      return FragenList.fromJson(jsonDecode(jsonString));
    } catch (e) {
      print("Error reading Fragen: $e");
      return FragenList(fragen: []);
    }
  }

  Future<void> saveFragen(FragenList fragenList) async {
    final fragenString = fragenList.toRawJson();
    await File('fragen.json').writeAsString(fragenString);
  }

  // Save Points to a file
  Future<void> savePoints(List<Points> points) async {
    await _saveToFile('points.json', points, (e) => e.toJson());
  }

  // Read Points from a file
  Future<List<Points>> readPoints() async {
    return _readFromFile('points.json', Points.fromJson);
  }

  // Save JfBuzzerAssignment list to a JSON file
  Future<void> saveJfBuzzerAssignments(
      List<JfBuzzerAssignment> assignments) async {
    await _saveToFile(
        'jf_buzzer_assignments.json', assignments, (e) => e.toJson());
  }

  // Read JfBuzzerAssignment list from a JSON file
  Future<List<JfBuzzerAssignment>> readJfBuzzerAssignments() async {
    return _readFromFile(
        'jf_buzzer_assignments.json', JfBuzzerAssignment.fromJson);
  }
}
