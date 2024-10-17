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

  Frage? currentFrage;

  QuizMasterBloc() : super(QuizMasterInitial()) {
    // Seite laden mit JfBuzzerAssignments
    on<LoadPage>((event, emit) async {
      Global.screenAppService.sendCategories(
        getKategorienThemaAbgeschlossen(Global.kategorien),
      );

      emit(QuizMasterCategorySelection(Global.kategorien));
    });

    // Richtige Antwort
    on<CorrectAnswer>((event, emit) async {
      Global.screenAppService.sendAnswer(
        currentFrage!.frage,
        currentFrage!.antwort,
        getKategorieThema(Global.kategorien, currentCategoryReihenfolge),
        getTeilnehmerByReihenfolge(pressedJfReihenfolge).jugendfeuerwehr.name,
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
          .add(getGesetztePunkte(
            currentJfReihenfolge,
            currentCategoryReihenfolge,
          ));

      await jsonStorageService.saveTeilnehmer(Global.teilnehmer);

      if (currentJfReihenfolge + 1 == Global.teilnehmer.length) {
        currentJfReihenfolge = 0;
        Global.kategorien
            .firstWhere(
                (element) => currentCategoryReihenfolge == element.reihenfolge)
            .abgeschlossen = true;

        await jsonStorageService.saveKategorien(Global.kategorien);

        Global.screenAppService.sendCategories(
          getKategorienThemaAbgeschlossen(Global.kategorien),
        );

        emit(QuizMasterCategorySelection(Global.kategorien));
        return;
      } else {
        currentJfReihenfolge++;
      }

      pressedJfReihenfolge = currentJfReihenfolge;

      Global.buzzerManagerService.sendBuzzerLock(
        mac: getBuzzerMacByTisch(
          getTeilnehmerByReihenfolge(currentJfReihenfolge)
              .jugendfeuerwehr
              .tisch,
        ),
      );

      if (currentJfReihenfolge > Global.teilnehmer.length) {
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

        emit(QuizMasterCategorySelection(Global.kategorien));
      } else {
        emit(QuizMasterQuestion(
          naechsteFrage(),
          getTeilnehmerByReihenfolge(currentJfReihenfolge).jugendfeuerwehr.name,
          Global.teilnehmer[pressedJfReihenfolge].jugendfeuerwehr.name,
        ));

        Global.screenAppService.sendCountdown(
            currentFrage!.frage,
            getKategorieThema(Global.kategorien, currentCategoryReihenfolge),
            30);
      }
    });

    // Handle wrong answer
    on<WrongAnswer>((event, emit) async {
      Global.screenAppService.sendQuestion(
        currentFrage!.frage,
        getKategorieThema(Global.kategorien, currentCategoryReihenfolge),
        '',
      );

      Global.teilnehmer
          .firstWhere((element) =>
              element.jugendfeuerwehr.reihenfolge == currentJfReihenfolge)
          .punkte
          .firstWhere(
            (element) =>
                element.kategorieReihenfolge == currentCategoryReihenfolge,
          )
          .erhaltenePunkte
          .add(-getGesetztePunkte(
              currentJfReihenfolge, currentCategoryReihenfolge));

      // Save JfBuzzerAssignments after update
      await jsonStorageService.saveTeilnehmer(Global.teilnehmer);

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
    });

    on<LockAllBuzzers>((event, emit) {
      Global.buzzerManagerService.sendBuzzerLock();
    });

    on<ReleaseAllBuzzers>((event, emit) {
      Global.buzzerManagerService.sendBuzzerRelease();
    });

    on<SelectCategory>((event, emit) async {
      currentCategoryReihenfolge = Global.kategorien
          .where((element) => element.reihenfolge == event.categoryReihenfolge)
          .first
          .reihenfolge;
      currentJfReihenfolge = 0;

      Global.screenAppService.sendCategoriesWithFocus(
        getKategorienThemaAbgeschlossen(Global.kategorien),
        getKategorieThema(Global.kategorien, currentCategoryReihenfolge),
      );
      await Future.delayed(Duration(seconds: 2));

      Global.screenAppService.sendPointInput(
        Global.teilnehmer
            .map((element) => element.jugendfeuerwehr.name)
            .toList(),
        Global.teilnehmer.map((element) => element.gesamtPunkte).toList(),
        getInputPoints(currentCategoryReihenfolge),
      );

      emit(QuizMasterPoints(
        Global.teilnehmer,
        currentCategoryReihenfolge,
      ));
    });

    on<ConfirmPoints>((event, emit) {
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
    });

    // Listen des PointsUpdated-Ereignisses und Aktualisieren der Punkteliste der jeweiligen Jugendfeuerwehr nach Tischnummer
    on<PointsUpdated>((event, emit) {
      if (Global.teilnehmer
          .firstWhere(
              (element) => element.jugendfeuerwehr.tisch == event.jfTisch)
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
          .firstWhere(
              (element) => element.jugendfeuerwehr.tisch == event.jfTisch)
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
    });
  }

  Frage naechsteFrage() {
    Kategorie currentCategory = Global.kategorien.firstWhere(
        (element) => currentCategoryReihenfolge == element.reihenfolge);

    currentFrage = getTeilnehmerByReihenfolge(currentJfReihenfolge)
        .fragen
        .firstWhere(
            (element) => element.kategorie == currentCategory.reihenfolge);

    return currentFrage!;
  }

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

  Map<String, bool> getKategorienThemaAbgeschlossen(
      List<Kategorie> kategorien) {
    return Map.fromEntries(
      kategorien.map(
        (element) => MapEntry(element.thema, element.abgeschlossen),
      ),
    );
  }

  String getKategorieThema(
    List<Kategorie> kategorien,
    int currentCategoryReihenfolge,
  ) {
    return kategorien
        .firstWhere(
            (element) => currentCategoryReihenfolge == element.reihenfolge)
        .thema;
  }

  String getBuzzerMacByTisch(int tisch) {
    return Global.buzzerTischZuordnung
        .firstWhere(
          (element) => element.tisch == tisch,
        )
        .mac;
  }

  int getTischByBuzzerMac(String mac) {
    return Global.buzzerTischZuordnung
        .firstWhere(
          (element) => element.mac == mac,
        )
        .tisch;
  }

  int getReihenfolgeByTisch(int tisch) {
    return Global.teilnehmer
        .firstWhere((element) => element.jugendfeuerwehr.tisch == tisch)
        .jugendfeuerwehr
        .reihenfolge;
  }

  Teilnehmer getTeilnehmerByTisch(int tisch) {
    return Global.teilnehmer
        .firstWhere((element) => element.jugendfeuerwehr.tisch == tisch);
  }

  Teilnehmer getTeilnehmerByReihenfolge(int reihenfolge) {
    return Global.teilnehmer.firstWhere(
        (element) => element.jugendfeuerwehr.reihenfolge == reihenfolge);
  }

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
