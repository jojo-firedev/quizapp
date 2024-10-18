import 'package:quiz_config/models/frage.dart';
import 'package:quiz_config/models/json_export_file.dart';
import 'package:quiz_config/models/jugendfeuerwehr.dart';
import 'package:quiz_config/presentation/import_fragen_screen.dart';

List<ExportTeilnehmer> createExportTeilnehmerList(
    List<Jugendfeuerwehr> jugendfeuerwehren, List<Thema> themen) {
  // List to hold ExportTeilnehmer objects
  List<ExportTeilnehmer> exportTeilnehmerList = [];

  // Loop through each Jugendfeuerwehr to create an ExportTeilnehmer
  for (var jf in jugendfeuerwehren) {
    // Convert Jugendfeuerwehr to ExportJugendfeuerwehr
    ExportJugendfeuerwehr exportJf = ExportJugendfeuerwehr(
      reihenfolge: jugendfeuerwehren.indexOf(jf) + 1,
      name: jf.name,
      tisch: jugendfeuerwehren.indexOf(jf) +
          1, // Assuming table number is the index + 1
    );

    // Create a list of ExportFrage, one per Thema
    List<ExportFrage> exportFragen = [];
    for (var thema in themen) {
      if (thema.fragen.isNotEmpty) {
        // Pick the first question from each Thema as a representative question
        Frage frage = thema.fragen.first;
        ExportFrage exportFrage = ExportFrage(
          kategorieReihenfolge: thema.reihenfolge,
          frage: frage.frage,
          antwort: frage.antwort,
        );
        exportFragen.add(exportFrage);
      }
    }

    // Create an ExportTeilnehmer with the Jugendfeuerwehr and list of Fragen
    ExportTeilnehmer exportTeilnehmer = ExportTeilnehmer(
      jugendfeuerwehr: exportJf,
      fragen: exportFragen,
    );

    // Add the ExportTeilnehmer to the list
    exportTeilnehmerList.add(exportTeilnehmer);
  }

  return exportTeilnehmerList;
}

void main() {
  // Example data
  List<Jugendfeuerwehr> jugendfeuerwehren = [
    Jugendfeuerwehr(name: "JF A", gemeinde: "Gemeinde A"),
    Jugendfeuerwehr(name: "JF B", gemeinde: "Gemeinde B"),
  ];

  List<Thema> themen = [
    Thema(
      thema: "Thema 1",
      reihenfolge: 1,
      fragen: [
        Frage(
            frage: "Frage 1.1",
            antwort: "Antwort 1.1",
            kategorie: "Kategorie 1"),
        Frage(
            frage: "Frage 1.2",
            antwort: "Antwort 1.2",
            kategorie: "Kategorie 1"),
      ],
    ),
    Thema(
      thema: "Thema 2",
      reihenfolge: 2,
      fragen: [
        Frage(
            frage: "Frage 2.1",
            antwort: "Antwort 2.1",
            kategorie: "Kategorie 2"),
      ],
    ),
  ];

  // Create the list of ExportTeilnehmer
  List<ExportTeilnehmer> exportTeilnehmerList =
      createExportTeilnehmerList(jugendfeuerwehren, themen);

  // Print the results
  for (var teilnehmer in exportTeilnehmerList) {
    print(teilnehmer.toRawJson());
  }
}
