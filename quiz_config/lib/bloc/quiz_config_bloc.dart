import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:quiz_config/models/json_export_file.dart';
import 'package:quiz_config/models/jugendfeuerwehr.dart';
import 'package:quiz_config/presentation/import_fragen_screen.dart';
import 'package:quiz_config/services/create_export_teilnehmer_list.dart';
import 'package:quiz_config/services/file_manager_service.dart';

part 'quiz_config_event.dart';
part 'quiz_config_state.dart';

class QuizConfigBloc extends Bloc<QuizConfigEvent, QuizConfigState> {
  int durchlaeufe = 1;
  DateTime datum = DateTime.now();
  List<Jugendfeuerwehr> jugendfeuerwehren = [];
  List<Jugendfeuerwehr> ausgewaehlteJugendfeuerwehren = [];

  List<Thema> themenListe = [];

  List<ExportTeilnehmer> exportTeilnehmer = [];
  List<ExportKategorie> exportKategorien = [];

  Future<List<Jugendfeuerwehr>> loadCSVData() async {
    return await FileManager.loadJugendfeuerwehren(
        'assets/jugendfeuerwehren-lklg.csv');
  }

  QuizConfigBloc() : super(QuizConfigInitial()) {
    loadCSVData().then((value) {
      jugendfeuerwehren = value;
    });

    on<StartNeuenTag>((event, emit) {
      durchlaeufe = event.durchlaeufe;
      datum = event.datum;
      emit(QuizConfigStartNeuenTag(datum, durchlaeufe));
    });

    on<ConfirmNeuerTag>((event, emit) {
      emit(QuizConfigImportFragen(
          ausgewaehlteJugendfeuerwehren.map((e) => e.name).toList()));
    });

    on<SelectJugendfeuerwehr>((event, emit) {
      ausgewaehlteJugendfeuerwehren.add(event.jugendfeuerwehr);
      jugendfeuerwehren.remove(event.jugendfeuerwehr);
      emit(QuizConfigSelectJugendfeuerwehren(
          jugendfeuerwehren, ausgewaehlteJugendfeuerwehren));
    });

    on<RemoveJugendfeuerwehr>((event, emit) {
      Jugendfeuerwehr jugendfeuerwehr =
          ausgewaehlteJugendfeuerwehren[event.index];
      ausgewaehlteJugendfeuerwehren.removeAt(event.index);
      jugendfeuerwehren.add(jugendfeuerwehr);
      jugendfeuerwehren.sort((a, b) => a.gemeinde.compareTo(b.gemeinde));
      emit(QuizConfigSelectJugendfeuerwehren(
          jugendfeuerwehren, ausgewaehlteJugendfeuerwehren));
    });

    on<ReoderJugendfeuerwehr>((event, emit) {
      final item = ausgewaehlteJugendfeuerwehren.removeAt(event.oldIndex);
      ausgewaehlteJugendfeuerwehren.insert(event.newIndex, item);
      emit(QuizConfigSelectJugendfeuerwehren(
          jugendfeuerwehren, ausgewaehlteJugendfeuerwehren));
    });

    on<ConfirmKategorieReihenfolge>((event, emit) {
      themenListe = event.kategorien;
      exportKategorien = event.kategorien
          .asMap()
          .entries
          .map((e) => ExportKategorie(reihenfolge: e.key, name: e.value.thema))
          .toList();

      emit(QuizConfigSelectJugendfeuerwehren(
        jugendfeuerwehren,
        ausgewaehlteJugendfeuerwehren,
      ));
    });

    on<FragenJugendfeuerwehrZuordnen>((event, emit) {
      exportTeilnehmer = createExportTeilnehmerList(
        ausgewaehlteJugendfeuerwehren,
        themenListe,
      );

      emit(QuizConfigAssignFragen(exportTeilnehmer, exportKategorien));
    });

    on<ShowFragenJugendfeuerwehrZuordnen>((event, emit) {
      emit(QuizConfigAssignFragen(null, null));
    });

    on<ExportToJsonFile>((event, emit) {
      FileManager.saveJsonString(
        JsonExportFile(
          teilnehmer: exportTeilnehmer,
          kategorien: exportKategorien,
        ).toRawJson(),
        'Quizdaten_${DateFormat('yyyy-MM-dd').format(datum)}_$durchlaeufe',
      );
    });
  }
}
