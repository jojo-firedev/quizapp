import 'dart:convert';
import 'dart:io';

import 'package:quizapp/models/buzzer_assignment.dart';
import 'package:quizapp/models/fragen.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';

class FileManagerService {
  const FileManagerService();

  // Generische Methode zum Speichern von JSON-Dateien
  Future<void> _saveToFile<T>(
      String path, List<T> data, Function(T) toJson) async {
    final jsonString = jsonEncode(data.map((e) => toJson(e)).toList());
    await File(path).writeAsString(jsonString);
  }

  // Generische Methode zum Lesen von JSON-Dateien
  Future<List<T>> _readFromFile<T>(
      String path, T Function(Map<String, dynamic>) fromJson) async {
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
    await _saveToFile(
        'assets/data/jugendfeuerwehren.json', jf, (e) => e.toJson());
  }

  Future<List<Jugendfeuerwehr>> readJFs() async {
    return _readFromFile(
        'assets/data/jugendfeuerwehren.json', Jugendfeuerwehr.fromJson);
  }

  Future<void> saveBuzzerAssignment(
      List<BuzzerAssignment> buzzerAssignment) async {
    await _saveToFile('assets/data/buzzer_assignment.json', buzzerAssignment,
        (e) => e.toJson());
  }

  Future<List<BuzzerAssignment>> readBuzzerAssignment() async {
    return _readFromFile(
        'assets/data/buzzer_assignment.json', BuzzerAssignment.fromJson);
  }

  Future<FragenList> readFragen() async {
    try {
      final jsonString = await File('assets/data/fragen.json').readAsString();
      return FragenList.fromJson(jsonDecode(jsonString));
    } catch (e) {
      print("Error reading Fragen: $e");
      return FragenList(fragen: []);
    }
  }

  Future<void> saveFragen(FragenList fragenList) async {
    final fragenString = fragenList.toRawJson();
    await File('assets/data/fragen.json').writeAsString(fragenString);
  }
}
