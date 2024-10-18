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
}
