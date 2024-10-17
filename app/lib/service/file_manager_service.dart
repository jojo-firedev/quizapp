import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/models/buzzer_tisch_zuordnung.dart';
import 'package:quizapp/models/json_storage_file.dart';

class FileManagerService {
  const FileManagerService();

  Future<void> selectJsonConfigFile() async {
    // Open the file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'], // Restrict to JSON files
    );

    if (result != null && result.files.single.path != null) {
      // Get the file path
      String filePath = result.files.single.path!;

      // Speichern des Pfads in der globalen Variable
      Global.jsonDateiPfad = filePath;
    } else {
      print("File picking canceled or failed");
    }
  }

  // Generische Methode zum Speichern von JSON-Dateien
  Future<void> _saveToFile<T>(
    String fileName,
    List<T> data,
    Function(T) toJson,
  ) async {
    final jsonString = jsonEncode(data.map((e) => toJson(e)).toList());
    await File(fileName).writeAsString(jsonString);
  }

  // Generische Methode zum Speichern von Rohdaten in einer Datei
  Future<void> _saveRawToFile(String data) async {
    await File(Global.jsonDateiPfad).writeAsString(data);
  }

  // Generische Methode zum Lesen von JSON-Dateien
  Future<List<T>> _readFromFile<T>(
    String fileName,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final jsonString = await File(fileName).readAsString();
      final jsonData = jsonDecode(jsonString) as List;
      return jsonData.map<T>((json) => fromJson(json)).toList();
    } catch (e) {
      print("Error reading file: $e");
      return [];
    }
  }

  // Generische Methode zum Lesen von Rohdaten aus einer Datei
  Future<String> _readRawFromFile() async {
    try {
      return await File(Global.jsonDateiPfad).readAsString();
    } catch (e) {
      print("Error reading file: $e");
      return '';
    }
  }

  // Lese komplette JSON Import Datei ein
  Future<JsonStorageFile> readJsonStorageFile() async {
    String rawReturn = await _readRawFromFile();
    return JsonStorageFile.fromRawJson(rawReturn);
  }

  // Schreibe komplette JSON Import Datei
  Future<void> writeJsonStorageFile(JsonStorageFile jsonStorageFile) async {
    final jsonString = jsonStorageFile.toRawJson();
    await _saveRawToFile(jsonString);
  }

  // Future<void> saveJFs(List<Jugendfeuerwehr> jf) async {
  //   await _saveToFile('jugendfeuerwehren.json', jf, (e) => e.toJson());
  // }

  // Future<List<Jugendfeuerwehr>> readJFs() async {
  //   return _readFromFile('jugendfeuerwehren.json', Jugendfeuerwehr.fromJson);
  // }

  Future<void> saveBuzzerAssignment(
      List<BuzzerTischZuordnung> buzzerAssignment) async {
    await _saveToFile(
        'buzzer_assignment.json', buzzerAssignment, (e) => e.toJson());
  }

  Future<List<BuzzerTischZuordnung>> readBuzzerAssignment() async {
    return _readFromFile(
        'buzzer_assignment.json', BuzzerTischZuordnung.fromJson);
  }

  // Future<FragenList> readFragen() async {
  //   try {
  //     final jsonString = await File('fragen.json').readAsString();
  //     return FragenList.fromJson(jsonDecode(jsonString));
  //   } catch (e) {
  //     print("Error reading Fragen: $e");
  //     return FragenList(fragen: []);
  //   }
  // }

  // Future<void> saveFragen(FragenList fragenList) async {
  //   final fragenString = fragenList.toRawJson();
  //   await File('fragen.json').writeAsString(fragenString);
  // }

  // // Save Points to a file
  // Future<void> savePoints(List<Points> points) async {
  //   await _saveToFile('points.json', points, (e) => e.toJson());
  // }

  // // Read Points from a file
  // Future<List<Points>> readPoints() async {
  //   return _readFromFile('points.json', Points.fromJson);
  // }

  // // Save JfBuzzerAssignment list to a JSON file
  // Future<void> saveJfBuzzerAssignments(
  //     List<JfBuzzerAssignment> assignments) async {
  //   await _saveToFile(
  //       'jf_buzzer_assignments.json', assignments, (e) => e.toJson());
  // }

  // // Read JfBuzzerAssignment list from a JSON file
  // Future<List<JfBuzzerAssignment>> readJfBuzzerAssignments() async {
  //   return _readFromFile(
  //       'jf_buzzer_assignments.json', JfBuzzerAssignment.fromJson);
  // }
}
