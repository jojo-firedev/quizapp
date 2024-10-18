import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_config/bloc/quiz_config_bloc.dart';
import 'package:quiz_config/models/frage.dart';

class Thema {
  final String thema;
  final int reihenfolge;
  final List<Frage> fragen;

  Thema({required this.thema, required this.reihenfolge, required this.fragen});
}

class ImportFragenScreen extends StatefulWidget {
  const ImportFragenScreen({super.key});

  @override
  State<ImportFragenScreen> createState() => _ImportFragenScreenState();
}

class _ImportFragenScreenState extends State<ImportFragenScreen> {
  String? _filePath;
  List<Thema> _themenListe = [];
  String? _selectedKategorie;

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['csv', 'xlsx']);

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _filePath = file.path;
      });
      _readFile(file);
    } else {
      // User canceled the picker
    }
  }

  Future<void> _readFile(File file) async {
    String extension = file.path.split('.').last;
    Map<String, List<Frage>> fragenMap = {};
    if (extension == 'csv' || extension == 'CSV') {
      final input = file.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter(eol: '\n'))
          .toList();
      List<String> headers =
          fields.first.map((header) => header.toString()).toList();
      for (var row in fields.skip(1)) {
        Map<String, dynamic> rowData = {
          for (var i = 0; i < headers.length; i++) headers[i]: row[i]
        };
        String kategorie = rowData['Kategorie'] ?? '';
        Frage frage = Frage(
          frage: rowData['Frage'] ?? '',
          antwort: rowData['Antwort'] ?? '',
          kategorie: kategorie,
        );
        if (!fragenMap.containsKey(kategorie)) {
          fragenMap[kategorie] = [];
        }
        fragenMap[kategorie]!.add(frage);
      }
    } else if (extension == 'xlsx') {
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;
        if (sheet.rows.isNotEmpty) {
          List<String> headers = sheet.rows.first
              .map((header) => header?.value.toString() ?? '')
              .toList();
          for (var row in sheet.rows.skip(1)) {
            Map<String, dynamic> rowData = {
              for (var i = 0; i < headers.length; i++)
                headers[i]: row[i]?.value.toString() ?? ''
            };
            String kategorie = rowData['Kategorie'] ?? '';
            Frage frage = Frage(
              frage: rowData['Frage'] ?? '',
              antwort: rowData['Antwort'] ?? '',
              kategorie: kategorie,
            );
            if (!fragenMap.containsKey(kategorie)) {
              fragenMap[kategorie] = [];
            }
            fragenMap[kategorie]!.add(frage);
          }
        }
      }
    } else {
      throw Exception('Unsupported file type');
    }

    List<Thema> themenListe = [];
    int reihenfolge = 1;
    fragenMap.forEach((kategorie, fragen) {
      themenListe.add(
          Thema(thema: kategorie, reihenfolge: reihenfolge++, fragen: fragen));
    });

    setState(() {
      _themenListe = themenListe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importiere Fragen'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => BlocProvider.of<QuizConfigBloc>(context).add(
          ConfirmKategorieReihenfolge(_themenListe),
        ),
        label: Text('Speichern & Weiter'),
        icon: const Icon(Icons.arrow_forward),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left panel with categories
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kategorie Liste',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ReorderableListView(
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final Thema item = _themenListe.removeAt(oldIndex);
                          _themenListe.insert(newIndex, item);
                        });
                      },
                      children: [
                        for (int index = 0;
                            index < _themenListe.length;
                            index++)
                          ListTile(
                            key: ValueKey(_themenListe[index].thema),
                            title: Text(_themenListe[index].thema),
                            onTap: () {
                              setState(() {
                                _selectedKategorie = _themenListe[index].thema;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Right panel with questions from selected category
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fragen aus ausgewählter Kategorie',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _selectedKategorie != null
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: _themenListe
                                .firstWhere((thema) =>
                                    thema.thema == _selectedKategorie!)
                                .fragen
                                .length,
                            itemBuilder: (context, index) {
                              Frage frage = _themenListe
                                  .firstWhere((thema) =>
                                      thema.thema == _selectedKategorie!)
                                  .fragen[index];
                              return ListTile(
                                title: Text('Frage: ${frage.frage}'),
                                subtitle: Text('Antwort: ${frage.antwort}'),
                              );
                            },
                          ),
                        )
                      : const Text('Keine Kategorie ausgewählt'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}