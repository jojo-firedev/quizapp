import 'package:quizapp/globals.dart';
import 'package:quizapp/models/buzzer_tisch_zuordnung.dart';
import 'package:quizapp/models/frage.dart';
import 'package:quizapp/models/json_storage_file.dart';
import 'package:quizapp/models/kategorie.dart';
import 'package:quizapp/models/teilnehmer.dart';
import 'package:quizapp/service/file_manager_service.dart';

class JsonStorageService {
  const JsonStorageService();

  final FileManagerService fileManagerService = const FileManagerService();

  Future<void> importCompleteJsonFile() async {
    JsonStorageFile jsonStorageFile =
        await fileManagerService.readJsonStorageFile();
    Global.teilnehmer = jsonStorageFile.teilnehmer;
    Global.jugendfeuerwehren =
        jsonStorageFile.teilnehmer.map((e) => e.jugendfeuerwehr).toList();
    Global.kategorien = jsonStorageFile.kategorien;

    Global.buzzerTischZuordnung =
        await fileManagerService.readBuzzerAssignment();
  }

  Future<void> saveTeilnehmer(List<Teilnehmer> teilnehmer) async {
    JsonStorageFile jsonStorageFile = JsonStorageFile(
      teilnehmer: teilnehmer,
      kategorien: Global.kategorien,
    );
    await fileManagerService.writeJsonStorageFile(jsonStorageFile);
  }

  Future<void> saveBuzzerTischZuordnung(
      List<BuzzerTischZuordnung> buzzerTischZuordnung) async {
    fileManagerService.saveBuzzerAssignment(buzzerTischZuordnung);
  }

  Future<void> saveKategorien(List<Kategorie> kategorien) async {
    JsonStorageFile jsonStorageFile = JsonStorageFile(
      teilnehmer: Global.teilnehmer,
      kategorien: kategorien,
    );
    await fileManagerService.writeJsonStorageFile(jsonStorageFile);
  }

  Future<void> resetJsonStorage() async {
    JsonStorageFile jsonStorageFile = JsonStorageFile(
      teilnehmer: Global.teilnehmer
          .map(
            (e) => Teilnehmer(
              jugendfeuerwehr: e.jugendfeuerwehr,
              fragen: e.fragen
                  .map((e) => Frage(
                        kategorie: e.kategorie,
                        frage: e.frage,
                        antwort: e.antwort,
                        beantwortet: false,
                      ))
                  .toList(),
            ),
          )
          .toList(),
      kategorien: Global.kategorien
          .map((e) => Kategorie(reihenfolge: e.reihenfolge, thema: e.thema))
          .toList(),
    );
    await fileManagerService.writeJsonStorageFile(jsonStorageFile);
  }
}
