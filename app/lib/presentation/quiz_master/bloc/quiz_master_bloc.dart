import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/models/frage.dart';
import 'package:quizapp/models/kategorie.dart';
import 'package:quizapp/models/teilnehmer.dart';
import 'package:quizapp/models/punkte.dart';
import 'package:quizapp/service/file_manager_service.dart';
import 'package:quizapp/service/json_storage_service.dart';

part 'quiz_master_event.dart';
part 'quiz_master_state.dart';

class QuizMasterBloc extends Bloc<QuizMasterEvent, QuizMasterState> {
  FileManagerService fileManagerService = const FileManagerService();
  JsonStorageService jsonStorageService = const JsonStorageService();
  int currentJfReihenfolge = 0;
  int currentQuestionIndex = 0;
  int currentCategoryReihenfolge = 0;
  int pressedJfReihenfolge = 0;
  int fehlVersuche = 0;

  // Config Parameter
  int maxFehlVersuche = 2;

  Frage? currentFrage;

  QuizMasterBloc() : super(QuizMasterInitial()) {
    // Seite laden mit JfBuzzerAssignments
    on<LoadPage>(_loadPage);

    // Richtige Antwort
    on<CorrectAnswer>(_correctAnswer);

    // Falsche Antwort
    on<WrongAnswer>(_wrongAnswer);

    // Bestätigung dass die Antwort gezeigt werden soll
    on<ShowAnswer>(_showAnswer);

    /// Bestätigung dass die nächste Frage gezeigt werden soll
    on<ShowNextQuestion>(_showNextQuestion);

    // Sperrt alle Buzzer
    on<LockAllBuzzers>(_lockAllBuzzers);

    // Freigabe aller Buzzer
    on<ReleaseAllBuzzers>(_releaseAllBuzzers);

    // Wähle Kategorie aus und gehe über in die Punkte Eingabe
    on<SelectKategorie>(_selectKategorie);

    // Bestätige die Eingabe der Punkte und geht über in die erste Frage
    on<BestaetigePunkte>(_bestaetigePunkte);

    // Aktualisiere einzelne Punkte
    on<AktualisierePunkte>(_aktualisierePunkte);
  }

  FutureOr<void> _loadPage(event, emit) async {
    Global.screenAppService.sendCategories(
      getKategorienThemaAbgeschlossen(Global.kategorien),
    );

    emit(QuizMasterCategorySelection(Global.kategorien));
  }

  FutureOr<void> _bestaetigePunkte(event, emit) {
    if (currentJfReihenfolge > Global.teilnehmer.length) {
      Global.kategorien
          .firstWhere(
              (element) => currentCategoryReihenfolge == element.reihenfolge)
          .abgeschlossen = true;

      jsonStorageService.saveKategorien(Global.kategorien);

      Global.screenAppService.sendCategories(
        getKategorienThemaAbgeschlossen(Global.kategorien),
      );

      emit(QuizMasterCategorySelection(Global.kategorien));
    } else {
      emit(QuizMasterQuestion(
        naechsteFrage(),
        getTeilnehmerByReihenfolge(currentJfReihenfolge).jugendfeuerwehr.name,
        getTeilnehmerByReihenfolge(currentJfReihenfolge).jugendfeuerwehr.name,
      ));

      Global.screenAppService.sendCountdown(
        currentFrage!.frage,
        getKategorieThema(Global.kategorien, currentCategoryReihenfolge),
        30,
      );

      Global.buzzerManagerService.sendBuzzerLock(
        mac: getBuzzerMacByTisch(
          getTeilnehmerByReihenfolge(currentJfReihenfolge)
              .jugendfeuerwehr
              .tisch,
        ),
      );
    }
  }

  FutureOr<void> _aktualisierePunkte(event, emit) {
    if (Global.teilnehmer
        .firstWhere((element) => element.jugendfeuerwehr.tisch == event.jfTisch)
        .punkte
        .where((element) =>
            element.kategorieReihenfolge == currentCategoryReihenfolge)
        .isNotEmpty) {
      Global.teilnehmer
          .firstWhere(
              (element) => element.jugendfeuerwehr.tisch == event.jfTisch)
          .punkte
          .removeWhere((element) =>
              element.kategorieReihenfolge == currentCategoryReihenfolge);
    }
    Global.teilnehmer
        .firstWhere((element) => element.jugendfeuerwehr.tisch == event.jfTisch)
        .punkte
        .add(Punkte(
          kategorieReihenfolge: currentCategoryReihenfolge,
          gesetztePunkte: event.points,
        ));

    List<String> jugendfeuerwehren = Global.teilnehmer
        .map((element) => element.jugendfeuerwehr.name)
        .toList();

    List<int> currentPoints =
        Global.teilnehmer.map((element) => element.gesamtPunkte).toList();

    Global.screenAppService.sendPointInput(
      jugendfeuerwehren,
      currentPoints,
      getInputPoints(currentCategoryReihenfolge),
    );

    emit(QuizMasterPoints(
      Global.teilnehmer,
      currentCategoryReihenfolge,
    ));
  }

  FutureOr<void> _selectKategorie(event, emit) async {
    currentCategoryReihenfolge = Global.kategorien
        .where((element) => element.reihenfolge == event.categoryReihenfolge)
        .first
        .reihenfolge;
    currentJfReihenfolge = 0;
    pressedJfReihenfolge = currentJfReihenfolge;

    Global.screenAppService.sendCategoriesWithFocus(
      getKategorienThemaAbgeschlossen(Global.kategorien),
      getKategorieThema(Global.kategorien, currentCategoryReihenfolge),
    );
    await Future.delayed(Duration(seconds: 2));

    Global.screenAppService.sendPointInput(
      Global.teilnehmer.map((element) => element.jugendfeuerwehr.name).toList(),
      Global.teilnehmer.map((element) => element.gesamtPunkte).toList(),
      getInputPoints(currentCategoryReihenfolge),
    );

    emit(QuizMasterPoints(
      Global.teilnehmer,
      currentCategoryReihenfolge,
    ));
  }

  FutureOr<void> _releaseAllBuzzers(event, emit) {
    Global.buzzerManagerService.sendBuzzerRelease();
  }

  FutureOr<void> _lockAllBuzzers(event, emit) {
    Global.buzzerManagerService.sendBuzzerLock();
  }

  FutureOr<void> _correctAnswer(event, emit) async {
    int gesetztePunkte = getGesetztePunkte(
      currentJfReihenfolge,
      currentCategoryReihenfolge,
    );
    Global.teilnehmer
        .firstWhere((element) =>
            element.jugendfeuerwehr.reihenfolge == pressedJfReihenfolge)
        .punkte
        .firstWhere(
          (element) =>
              element.kategorieReihenfolge == currentCategoryReihenfolge,
        )
        .erhaltenePunkte
        .add(gesetztePunkte);

    await jsonStorageService.saveTeilnehmer(Global.teilnehmer);

    emit(QuizMasterQuestionConfirmShowAnswer(
      currentFrage!,
      getTeilnehmerByReihenfolge(currentJfReihenfolge).jugendfeuerwehr.name,
      getTeilnehmerByReihenfolge(pressedJfReihenfolge).jugendfeuerwehr.name,
    ));

    Global.screenAppService.sendQuestion(
      currentFrage!.frage,
      getKategorieThema(Global.kategorien, currentCategoryReihenfolge),
      '',
    );
  }

  FutureOr<void> _wrongAnswer(event, emit) async {
    fehlVersuche++;
    Global.screenAppService.sendQuestion(
      currentFrage!.frage,
      getKategorieThema(Global.kategorien, currentCategoryReihenfolge),
      '',
    );

    emit(QuizMasterQuestion(
      currentFrage!,
      getTeilnehmerByReihenfolge(currentJfReihenfolge).jugendfeuerwehr.name,
      '',
    ));

    // Minus Punkte für falsche Antwort für die Jugendfeuerwehr,
    // die den Buzzer gedrückt hat
    Global.teilnehmer
        .firstWhere((element) =>
            element.jugendfeuerwehr.reihenfolge == pressedJfReihenfolge)
        .punkte
        .firstWhere(
          (element) =>
              element.kategorieReihenfolge == currentCategoryReihenfolge,
        )
        .erhaltenePunkte
        .add(-getGesetztePunkte(
          pressedJfReihenfolge,
          currentCategoryReihenfolge,
        ));

    // Save JfBuzzerAssignments after update
    await jsonStorageService.saveTeilnehmer(Global.teilnehmer);

    if (fehlVersuche > maxFehlVersuche) {
      emit(QuizMasterQuestionConfirmShowAnswer(
        currentFrage!,
        getTeilnehmerByReihenfolge(currentJfReihenfolge).jugendfeuerwehr.name,
        '',
      ));
      Global.screenAppService.sendQuestion(
        currentFrage!.frage,
        getKategorieThema(Global.kategorien, currentCategoryReihenfolge),
        '',
      );

      fehlVersuche = 0;
    } else {
      Global.buzzerManagerService.sendBuzzerRelease();

      // Listen to the buzzerManagerService stream
      await emit.forEach(
        Global.buzzerManagerService.stream,
        onData: (streamEvent) {
          if (streamEvent.values.first == 'ButtonPressed') {
            int pressedTisch = getTischByBuzzerMac(streamEvent.keys.first);
            pressedJfReihenfolge = getReihenfolgeByTisch(pressedTisch);

            Global.screenAppService.sendQuestion(
              currentFrage!.frage,
              getKategorieThema(Global.kategorien, currentCategoryReihenfolge),
              getTeilnehmerByReihenfolge(pressedJfReihenfolge)
                  .jugendfeuerwehr
                  .name,
            );

            return QuizMasterQuestion(
              currentFrage!,
              getTeilnehmerByReihenfolge(currentJfReihenfolge)
                  .jugendfeuerwehr
                  .name,
              getTeilnehmerByReihenfolge(pressedJfReihenfolge)
                  .jugendfeuerwehr
                  .name,
            );
          }

          return state;
        },
      );
    }
  }

  FutureOr<void> _showAnswer(ShowAnswer event, Emitter<QuizMasterState> emit) {
    Global.screenAppService.sendAnswer(
      currentFrage!.frage,
      currentFrage!.antwort,
      getKategorieThema(Global.kategorien, currentCategoryReihenfolge),
      getTeilnehmerByReihenfolge(pressedJfReihenfolge).jugendfeuerwehr.name,
    );

    emit(QuizMasterQuestionShowAnswer(
      currentFrage!,
      getTeilnehmerByReihenfolge(currentJfReihenfolge).jugendfeuerwehr.name,
      getTeilnehmerByReihenfolge(pressedJfReihenfolge).jugendfeuerwehr.name,
    ));
  }

  Future<void> _showNextQuestion(
      ShowNextQuestion event, Emitter<QuizMasterState> emit) async {
    fehlVersuche = 0;
    currentJfReihenfolge++;
    pressedJfReihenfolge = currentJfReihenfolge;

    if (currentJfReihenfolge >= Global.teilnehmer.length) {
      Global.kategorien
          .firstWhere(
              (element) => currentCategoryReihenfolge == element.reihenfolge)
          .abgeschlossen = true;

      await jsonStorageService.saveKategorien(Global.kategorien);

      for (Teilnehmer element in Global.teilnehmer) {
        element.logPointsPerCategory(currentCategoryReihenfolge);
      }

      Global.screenAppService.sendCategories(
        getKategorienThemaAbgeschlossen(Global.kategorien),
      );

      Global.buzzerManagerService.sendBuzzerLock();

      emit(QuizMasterCategorySelection(Global.kategorien));
    } else {
      Global.buzzerManagerService.sendBuzzerLock(
        mac: getBuzzerMacByTisch(
          getTeilnehmerByReihenfolge(currentJfReihenfolge)
              .jugendfeuerwehr
              .tisch,
        ),
      );

      emit(QuizMasterQuestion(
        naechsteFrage(),
        getTeilnehmerByReihenfolge(currentJfReihenfolge).jugendfeuerwehr.name,
        getTeilnehmerByReihenfolge(pressedJfReihenfolge).jugendfeuerwehr.name,
      ));

      Global.screenAppService.sendCountdown(currentFrage!.frage,
          getKategorieThema(Global.kategorien, currentCategoryReihenfolge), 30);
    }
  }

  /// Gibt die nächste Frage zurück
  Frage naechsteFrage() {
    Kategorie currentCategory = Global.kategorien.firstWhere(
        (element) => currentCategoryReihenfolge == element.reihenfolge);

    currentFrage = getTeilnehmerByReihenfolge(currentJfReihenfolge)
        .fragen
        .firstWhere(
            (element) => element.kategorie == currentCategory.reihenfolge);

    return currentFrage!;
  }

  /// SCREEN APP: Gibt die Punkte der Jugendfeuerwehr zurück
  List<int> getInputPoints(int currentCategoryReihenfolge) {
    return Global.teilnehmer
        .map((element) => element.punkte
            .firstWhere(
              (element) =>
                  element.kategorieReihenfolge == currentCategoryReihenfolge,
              orElse: () => Punkte(
                kategorieReihenfolge: currentCategoryReihenfolge,
                gesetztePunkte: 0,
              ),
            )
            .gesetztePunkte)
        .toList();
  }

  /// SCREEN APP: Gibt die Kategorien als Map zurück
  Map<String, bool> getKategorienThemaAbgeschlossen(
      List<Kategorie> kategorien) {
    return Map.fromEntries(
      kategorien.map(
        (element) => MapEntry(element.thema, element.abgeschlossen),
      ),
    );
  }

  /// Gibt das Thema der Kategorie anhand der Reihenfolge zurück
  String getKategorieThema(
    List<Kategorie> kategorien,
    int currentCategoryReihenfolge,
  ) {
    return kategorien
        .firstWhere(
            (element) => currentCategoryReihenfolge == element.reihenfolge)
        .thema;
  }

  /// Gibt die Buzzer Mac Adresse anhand des Tisches zurück
  String getBuzzerMacByTisch(int tisch) {
    return Global.buzzerTischZuordnung
        .firstWhere(
          (element) => element.tisch == tisch,
        )
        .mac;
  }

  /// Gibt den Tisch anhand der Buzzer Mac Adresse zurück
  int getTischByBuzzerMac(String mac) {
    return Global.buzzerTischZuordnung
        .firstWhere(
          (element) => element.mac == mac,
        )
        .tisch;
  }

  /// Gibt die Reihenfolge der Jugendfeuerwehr anhand des Tisches zurück
  int getReihenfolgeByTisch(int tisch) {
    return Global.teilnehmer
        .firstWhere((element) => element.jugendfeuerwehr.tisch == tisch)
        .jugendfeuerwehr
        .reihenfolge;
  }

  /// Gibt den Teilnehmer anhand des Tisches zurück
  Teilnehmer getTeilnehmerByTisch(int tisch) {
    return Global.teilnehmer
        .firstWhere((element) => element.jugendfeuerwehr.tisch == tisch);
  }

  /// Gibt den Teilnehmer anhand der Reihenfolge zurück
  Teilnehmer getTeilnehmerByReihenfolge(int reihenfolge) {
    return Global.teilnehmer.firstWhere(
        (element) => element.jugendfeuerwehr.reihenfolge == reihenfolge);
  }

  /// Gibt die gesetzten Punkte für die Jugendfeuerwehr mit der Reihenfolge zurück
  int getGesetztePunkte(int jfReihenfolge, int currentCategoryReihenfolge) {
    return getTeilnehmerByReihenfolge(jfReihenfolge)
        .punkte
        .firstWhere(
          (element) =>
              element.kategorieReihenfolge == currentCategoryReihenfolge,
        )
        .gesetztePunkte;
  }
}
