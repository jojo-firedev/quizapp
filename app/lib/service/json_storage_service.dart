import 'package:quizapp/globals.dart';
import 'package:quizapp/models/buzzer_tisch_zuordnung.dart';
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
    Global.buzzerTischZuordnung = jsonStorageFile.buzzerTischZuordnung ?? [];
    Global.teilnehmer = jsonStorageFile.teilnehmer;
    Global.jugendfeuerwehren =
        jsonStorageFile.teilnehmer.map((e) => e.jugendfeuerwehr).toList();
    Global.kategorien = jsonStorageFile.kategorien;
  }

  Future<void> saveTeilnehmer(List<Teilnehmer> teilnehmer) async {
    JsonStorageFile jsonStorageFile = JsonStorageFile(
      buzzerTischZuordnung: Global.buzzerTischZuordnung,
      teilnehmer: teilnehmer,
      kategorien: Global.kategorien,
    );
    await fileManagerService.writeJsonStorageFile(jsonStorageFile);
  }

  Future<void> saveBuzzerTischZuordnung(
      List<BuzzerTischZuordnung> buzzerTischZuordnung) async {
    JsonStorageFile jsonStorageFile = JsonStorageFile(
      buzzerTischZuordnung: buzzerTischZuordnung,
      teilnehmer: Global.teilnehmer,
      kategorien: Global.kategorien,
    );
    await fileManagerService.writeJsonStorageFile(jsonStorageFile);
  }

  Future<void> saveKategorien(List<Kategorie> kategorien) async {
    JsonStorageFile jsonStorageFile = JsonStorageFile(
      buzzerTischZuordnung: Global.buzzerTischZuordnung,
      teilnehmer: Global.teilnehmer,
      kategorien: kategorien,
    );
    await fileManagerService.writeJsonStorageFile(jsonStorageFile);
  }
}
