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

    return ausgewaehlteFrage;
  }

  QuizMasterBloc() : super(QuizMasterInitial()) {
    on<LoadPage>((event, emit) async {
      fragenList = await fileManagerService.readFragen();

      emit(QuizMasterCategorySelection(fragenList));
    });

    on<CorrectAnswer>((event, emit) async {
      // Get point number of the origin Jugendfeuerwehr
      int gesetztePunkte = Global.jfBuzzerAssignments[currentJfIndex].points
          .firstWhere(
            (element) =>
                element.kategorieReihenfolge == currentCategoryReihenfolge,
          )
          .gesetztePunkte;

      // Add the positive points to pressed Jugendfeuerwehr
      Global.jfBuzzerAssignments[pressedJfIndex].points
          .firstWhere(
            (element) =>
                element.kategorieReihenfolge == currentCategoryReihenfolge,
          )
          .erhaltenePunkte
          .add(gesetztePunkte);

      // Save points after update
      await fileManagerService.savePoints(
        Global.jfBuzzerAssignments
            .expand((assignment) => assignment.points)
            .toList(),
      );

      if (currentJfIndex + 1 == Global.jfBuzzerAssignments.length) {
        currentJfIndex = 0;
        fragenList.fragen
            .firstWhere(
                (element) => currentCategoryReihenfolge == element.reihenfolge)
            .abgeschlossen = true;

        // Save questions after update
        await fileManagerService.saveFragen(fragenList);
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

        emit(QuizMasterCategorySelection(fragenList));
      } else {
        emit(QuizMasterQuestion(
          getNextFrage(),
          Global.jfBuzzerAssignments[currentJfIndex].jugendfeuerwehr.name,
          Global.jfBuzzerAssignments[pressedJfIndex].jugendfeuerwehr.name,
        ));
      }
    });

    on<WrongAnswer>((event, emit) async {
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

      await fileManagerService.savePoints(
        Global.jfBuzzerAssignments
            .expand((assignment) => assignment.points)
            .toList(),
      );

      Global.buzzerManagerService.sendBuzzerRelease();

      // Listen to the buzzerManagerService stream
      await emit.forEach(
        Global.buzzerManagerService.stream,
        onData: (streamEvent) {
          if (streamEvent.values.first == 'ButtonPressed') {
            pressedJfIndex = Global.jfBuzzerAssignments.indexWhere(
                (assignment) =>
                    assignment.buzzerAssignment.mac == streamEvent.keys.first);

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

    on<SelectCategory>((event, emit) {
      currentCategoryReihenfolge = fragenList.fragen
          .where((element) => element.reihenfolge == event.categoryReihenfolge)
          .first
          .reihenfolge;
      currentJfIndex = 0;

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

        emit(QuizMasterCategorySelection(fragenList));
      } else {
        emit(QuizMasterQuestion(
          getNextFrage(),
          Global.jfBuzzerAssignments[currentJfIndex].jugendfeuerwehr.name,
          Global.jfBuzzerAssignments[currentJfIndex].jugendfeuerwehr.name,
        ));

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

      emit(QuizMasterPoints(
        Global.jfBuzzerAssignments,
        currentCategoryReihenfolge,
      ));
    });
  }
}
