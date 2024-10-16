import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/models/fragen.dart';
import 'package:quizapp/models/jf_buzzer_assignment.dart';
import 'package:quizapp/models/points.dart';
import 'package:quizapp/service/file_manager_service.dart';

part 'quiz_master_event.dart';
part 'quiz_master_state.dart';

class QuizMasterBloc extends Bloc<QuizMasterEvent, QuizMasterState> {
  FileManagerService fileManagerService = const FileManagerService();
  late FragenList fragenList;
  int currentJfIndex = 0;
  int currentQuestionIndex = 0;
  int currentCategoryReihenfolge = 0;
  int pressedJfIndex = 0;

  FragenFrage? currentFrage;

  bool checkIfAllQuestionsAnswered() {
    return fragenList.fragen
        .firstWhere(
            (element) => currentCategoryReihenfolge == element.reihenfolge)
        .fragen
        .every((element) => element.abgeschlossen);
  }

  FragenFrage getNextFrage() {
    FragenKategorie currentCategory = fragenList.fragen.firstWhere(
        (element) => currentCategoryReihenfolge == element.reihenfolge);

    List<FragenFrage> offeneFragen =
        currentCategory.fragen.where((frage) => !frage.abgeschlossen).toList();

    // Falls keine offenen Fragen vorhanden sind, returne eine Fehlerbehandlung (kann je nach App-Logik angepasst werden)
    if (offeneFragen.isEmpty) {
      throw Exception("Es sind keine offenen Fragen mehr in dieser Kategorie.");
    }

    // Wähle eine zufällige Frage aus den offenen Fragen aus
    int randomIndex = Random().nextInt(offeneFragen.length);
    FragenFrage ausgewaehlteFrage = offeneFragen[randomIndex];

    // Setze die ausgewählte Frage auf abgeschlossen
    ausgewaehlteFrage.abgeschlossen = true;

    // Speichere den neuen Status in der JSON-Datei
    fileManagerService.saveFragen(fragenList);

    currentFrage = ausgewaehlteFrage;
    return ausgewaehlteFrage;
  }

  QuizMasterBloc() : super(QuizMasterInitial()) {
    // Load Page with JfBuzzerAssignments
    on<LoadPage>((event, emit) async {
      fragenList = await fileManagerService.readFragen();

      // Erstelle eine Map aus 'Frage' und 'abgeschlossen' für alle offenen Fragen
      Map<String, bool> categories = Map.fromEntries(fragenList.fragen
          .map((element) => MapEntry(element.thema, element.abgeschlossen)));

      Global.socketService.sendCategories(categories);

      emit(QuizMasterCategorySelection(fragenList));
    });

    // Handle correct answer
    on<CorrectAnswer>((event, emit) async {
      Global.socketService.sendAnswer(
          currentFrage!.frage,
          currentFrage!.antwort,
          fragenList.fragen
              .firstWhere((element) =>
                  currentCategoryReihenfolge == element.reihenfolge)
              .thema,
          Global.jfBuzzerAssignments[pressedJfIndex].jugendfeuerwehr.name);

      int gesetztePunkte = Global.jfBuzzerAssignments[currentJfIndex].points
          .firstWhere(
            (element) =>
                element.kategorieReihenfolge == currentCategoryReihenfolge,
          )
          .gesetztePunkte;

      Global.jfBuzzerAssignments[pressedJfIndex].points
          .firstWhere(
            (element) =>
                element.kategorieReihenfolge == currentCategoryReihenfolge,
          )
          .erhaltenePunkte
          .add(gesetztePunkte);

      // Save JfBuzzerAssignments after update
      await fileManagerService
          .saveJfBuzzerAssignments(Global.jfBuzzerAssignments);

      if (currentJfIndex + 1 == Global.jfBuzzerAssignments.length) {
        currentJfIndex = 0;
        fragenList.fragen
            .firstWhere(
                (element) => currentCategoryReihenfolge == element.reihenfolge)
            .abgeschlossen = true;

        // Save questions after update
        await fileManagerService.saveFragen(fragenList);

        // Erstelle eine Map aus 'Frage' und 'abgeschlossen' für alle offenen Fragen
        Map<String, bool> categories = Map.fromEntries(fragenList.fragen
            .map((element) => MapEntry(element.thema, element.abgeschlossen)));

        Global.socketService.sendCategories(categories);

        emit(QuizMasterCategorySelection(fragenList));
        return;
      } else {
        currentJfIndex++;
      }

      pressedJfIndex = currentJfIndex;

      Global.buzzerManagerService.sendBuzzerLock(
        mac: Global.jfBuzzerAssignments[currentJfIndex].buzzerAssignment.mac,
      );

      if (checkIfAllQuestionsAnswered()) {
        fragenList.fragen
            .firstWhere(
                (element) => currentCategoryReihenfolge == element.reihenfolge)
            .abgeschlossen = true;

        await fileManagerService.saveFragen(fragenList);

        for (JfBuzzerAssignment element in Global.jfBuzzerAssignments) {
          element.logPointsPerCategory(currentCategoryReihenfolge);
        }

        // Erstelle eine Map aus 'Frage' und 'abgeschlossen' für alle offenen Fragen
        Map<String, bool> categories = Map.fromEntries(fragenList.fragen
            .map((element) => MapEntry(element.thema, element.abgeschlossen)));

        Global.socketService.sendCategories(categories);

        emit(QuizMasterCategorySelection(fragenList));
      } else {
        emit(QuizMasterQuestion(
          getNextFrage(),
          Global.jfBuzzerAssignments[currentJfIndex].jugendfeuerwehr.name,
          Global.jfBuzzerAssignments[pressedJfIndex].jugendfeuerwehr.name,
        ));

        Global.socketService.sendCountdown(
            currentFrage!.frage,
            fragenList.fragen
                .firstWhere((element) =>
                    currentCategoryReihenfolge == element.reihenfolge)
                .thema,
            30);
      }
    });

    // Handle wrong answer
    on<WrongAnswer>((event, emit) async {
      Global.socketService.sendQuestion(
        currentFrage!.frage,
        fragenList.fragen
            .firstWhere(
                (element) => currentCategoryReihenfolge == element.reihenfolge)
            .thema,
        '',
      );

      int gesetztePunkte = Global.jfBuzzerAssignments[currentJfIndex].points
          .firstWhere(
            (element) =>
                element.kategorieReihenfolge == currentCategoryReihenfolge,
          )
          .gesetztePunkte;

      Global.jfBuzzerAssignments[currentJfIndex].points
          .firstWhere(
            (element) =>
                element.kategorieReihenfolge == currentCategoryReihenfolge,
          )
          .erhaltenePunkte
          .add(-gesetztePunkte);

      // Save JfBuzzerAssignments after update
      await fileManagerService
          .saveJfBuzzerAssignments(Global.jfBuzzerAssignments);

      Global.buzzerManagerService.sendBuzzerRelease();

      // Listen to the buzzerManagerService stream
      await emit.forEach(
        Global.buzzerManagerService.stream,
        onData: (streamEvent) {
          if (streamEvent.values.first == 'ButtonPressed') {
            pressedJfIndex = Global.jfBuzzerAssignments.indexWhere(
                (assignment) =>
                    assignment.buzzerAssignment.mac == streamEvent.keys.first);

            Global.socketService.sendQuestion(
              currentFrage!.frage,
              fragenList.fragen
                  .firstWhere((element) =>
                      currentCategoryReihenfolge == element.reihenfolge)
                  .thema,
              Global.jfBuzzerAssignments[pressedJfIndex].jugendfeuerwehr.name,
            );

            // Emit the QuizMasterQuestion state with the appropriate pressed button index
            return QuizMasterQuestion(
              fragenList.fragen
                  .firstWhere((element) =>
                      element.reihenfolge == currentCategoryReihenfolge)
                  .fragen[currentQuestionIndex],
              Global.jfBuzzerAssignments[currentJfIndex].jugendfeuerwehr.name,
              Global.jfBuzzerAssignments[pressedJfIndex].jugendfeuerwehr.name,
            );
          }

          return state; // Return the current state if no button press event is detected
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
      currentCategoryReihenfolge = fragenList.fragen
          .where((element) => element.reihenfolge == event.categoryReihenfolge)
          .first
          .reihenfolge;
      currentJfIndex = 0;

      Global.socketService.sendCategoriesWithFocus(
        Map.fromEntries(fragenList.fragen
            .map((element) => MapEntry(element.thema, element.abgeschlossen))),
        fragenList.fragen
            .firstWhere(
                (element) => currentCategoryReihenfolge == element.reihenfolge)
            .thema,
      );
      await Future.delayed(Duration(seconds: 2));

      Global.socketService.sendPointInput(
        Global.jfBuzzerAssignments
            .map((element) => element.jugendfeuerwehr.name)
            .toList(),
        Global.jfBuzzerAssignments
            .map((element) => element.gesamtPunkte)
            .toList(),
        Global.jfBuzzerAssignments
            .map((element) => element.points
                .firstWhere(
                  (element) =>
                      element.kategorieReihenfolge ==
                      currentCategoryReihenfolge,
                  orElse: () => Points(
                    kategorieReihenfolge: currentCategoryReihenfolge,
                    gesetztePunkte: 0,
                  ),
                )
                .gesetztePunkte)
            .toList(),
      );

      emit(QuizMasterPoints(
        Global.jfBuzzerAssignments,
        currentCategoryReihenfolge,
      ));
    });

    on<ConfirmPoints>((event, emit) {
      if (checkIfAllQuestionsAnswered()) {
        fragenList.fragen
            .firstWhere(
                (element) => currentCategoryReihenfolge == element.reihenfolge)
            .abgeschlossen = true;

        // Speichern der aktualisierten Fragenliste
        fileManagerService.saveFragen(fragenList);

        Global.socketService.sendCategories(
          Map.fromEntries(fragenList.fragen.map(
              (element) => MapEntry(element.thema, element.abgeschlossen))),
        );

        emit(QuizMasterCategorySelection(fragenList));
      } else {
        emit(QuizMasterQuestion(
          getNextFrage(),
          Global.jfBuzzerAssignments[currentJfIndex].jugendfeuerwehr.name,
          Global.jfBuzzerAssignments[currentJfIndex].jugendfeuerwehr.name,
        ));

        Global.socketService.sendCountdown(
            currentFrage!.frage,
            fragenList.fragen
                .firstWhere((element) =>
                    currentCategoryReihenfolge == element.reihenfolge)
                .thema,
            30);

        Global.buzzerManagerService.sendBuzzerLock(
          mac: Global.jfBuzzerAssignments[currentJfIndex].buzzerAssignment.mac,
        );
      }
    });

    // Listen to the PointsUpdated event and update the points list of the respective Jugendfeuerwehr by Tisch number
    on<PointsUpdated>((event, emit) {
      if (Global.jfBuzzerAssignments
          .firstWhere(
              (element) => element.jugendfeuerwehr.tisch == event.jfTisch)
          .points
          .where((element) =>
              element.kategorieReihenfolge == currentCategoryReihenfolge)
          .isNotEmpty) {
        Global.jfBuzzerAssignments
            .firstWhere(
                (element) => element.jugendfeuerwehr.tisch == event.jfTisch)
            .points
            .removeWhere((element) =>
                element.kategorieReihenfolge == currentCategoryReihenfolge);
      }
      Global.jfBuzzerAssignments
          .firstWhere(
              (element) => element.jugendfeuerwehr.tisch == event.jfTisch)
          .points
          .add(Points(
            kategorieReihenfolge: currentCategoryReihenfolge,
            gesetztePunkte: event.points,
          ));

      List<String> jugendfeuerwehren = Global.jfBuzzerAssignments
          .map((element) => element.jugendfeuerwehr.name)
          .toList();

      List<int> currentPoints = Global.jfBuzzerAssignments
          .map((element) => element.gesamtPunkte)
          .toList();

      List<int> inputPoints = Global.jfBuzzerAssignments
          .map(
            (element) => element.points
                .firstWhere(
                  (element) =>
                      element.kategorieReihenfolge ==
                      currentCategoryReihenfolge,
                  orElse: () => Points(
                    kategorieReihenfolge: currentCategoryReihenfolge,
                    gesetztePunkte: 0,
                  ),
                )
                .gesetztePunkte,
          )
          .toList();

      Global.socketService.sendPointInput(
        jugendfeuerwehren,
        currentPoints,
        inputPoints,
      );

      emit(QuizMasterPoints(
        Global.jfBuzzerAssignments,
        currentCategoryReihenfolge,
      ));
    });
  }
}
