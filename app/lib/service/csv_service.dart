import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:quizapp/globals.dart';

import 'package:quizapp/models/jugendfeuerwehr.dart';

class CsvService {
  const CsvService();

  Future<List<Jugendfeuerwehr>> readCsv() async {
    Global.logger.d('Reading CSV');
    final input = File('assets/data/jugendfeuerwehren-lklg.csv').openRead();
    List<dynamic> fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    fields = fields.sublist(1);
    List<Jugendfeuerwehr> list = fields
        .map((e) => Jugendfeuerwehr(
              name: e[0],
              gemeinde: e[1],
            ))
        .toList();

    return list;
  }
}
