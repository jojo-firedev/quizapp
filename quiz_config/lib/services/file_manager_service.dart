import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:quiz_config/models/jugendfeuerwehr.dart';

class FileManager {
  static Future<List<Jugendfeuerwehr>> loadJugendfeuerwehren(
      String path) async {
    final rawData = await rootBundle.loadString(path);
    List<List<dynamic>> csvData = const CsvToListConverter()
        .convert(rawData, eol: '\n', shouldParseNumbers: false);
    return csvData.skip(1).map((row) => Jugendfeuerwehr.fromCsv(row)).toList();
  }

  static Future<void> saveJsonString(String jsonString, String fileName) async {
    try {
      // Let the user pick a directory where the file will be saved
      String? directoryPath = await FilePicker.platform.getDirectoryPath();

      if (directoryPath != null) {
        // Create a reference to the new file
        String filePath = '$directoryPath/$fileName.json';
        File jsonFile = File(filePath);

        // Write the JSON string to the file
        await jsonFile.writeAsString(jsonString);

        print('File saved successfully at $filePath');
      } else {
        print('Directory path was not selected');
      }
    } catch (e) {
      print('Error saving file: $e');
    }
  }
}
