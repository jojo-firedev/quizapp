import 'package:quiz_config/models/frage.dart';
import 'package:quiz_config/models/json_export_file.dart';
import 'package:quiz_config/models/jugendfeuerwehr.dart';
import 'package:quiz_config/presentation/import_fragen_screen.dart';

List<ExportTeilnehmer> createExportTeilnehmerList(
    List<Jugendfeuerwehr> jugendfeuerwehren, List<Thema> themen) {
  // List to hold ExportTeilnehmer objects
  List<ExportTeilnehmer> exportTeilnehmerList = [];

  // Loop through each Jugendfeuerwehr to create an ExportTeilnehmer
  for (Jugendfeuerwehr jf in jugendfeuerwehren) {
    // Convert Jugendfeuerwehr to ExportJugendfeuerwehr
    ExportJugendfeuerwehr exportJf = ExportJugendfeuerwehr(
      reihenfolge: jugendfeuerwehren.indexOf(jf),
      name: jf.name,
      tisch: jugendfeuerwehren.indexOf(jf) +
          1, // Assuming table number is the index + 1
    );

    // Create a list of ExportFrage, one per Thema
    List<ExportFrage> exportFragen = [];
    for (Thema thema in themen) {
      if (thema.fragen.isNotEmpty) {
        // Pick the first question from each Thema as a representative question
        Frage frage = thema.fragen.first;

        ExportFrage exportFrage = ExportFrage(
          kategorieReihenfolge: thema.reihenfolge,
          frage: frage.frage,
          antwort: frage.antwort,
        );

        thema.fragen.removeAt(0); // Remove the question from the list

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
