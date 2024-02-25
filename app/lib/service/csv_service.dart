import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';

import 'package:quizapp/models/jugendfeuerwehr.dart';

class CsvService {
  Future<List<Jugendfeuerwehr>> readCsv() async {
    print('Reading CSV');
    final input = File(
            '/Users/jonas.hofses/dev/quizapp/app/lib/data/jugendfeuerwehre-lklg.csv')
        .openRead();
    List<dynamic> fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    // fields = fields.removeAt(0);
    List<Jugendfeuerwehr> list = fields
        .map((e) => Jugendfeuerwehr(
              name: e[0],
              ort: e[1],
              gemeinde: e[2],
            ))
        .toList();

    print(list.first.gemeinde.toString());
    return list;
  }
}
