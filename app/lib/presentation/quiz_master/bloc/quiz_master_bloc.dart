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
        .where((element) => currentCategoryReihenfolge == element.reihenfolge)
        .first
        .fragen
        .every((element) => element.abgeschlossen);
  }

  FragenFrage getNextFrage() {
    int randomIndex;
    FragenKategorie currentCategory = fragenList.fragen
        .where((element) => currentCategoryReihenfolge == element.reihenfolge)
        .first;
    do {
      randomIndex = Random().nextInt(currentCategory.fragen.length);
    } while (currentCategory.fragen[randomIndex].abgeschlossen);

    currentQuestionIndex = randomIndex;

    fragenList.fragen
        .where((element) => currentCategoryReihenfolge == element.reihenfolge)
        .first
        .fragen[currentQuestionIndex]
        .abgeschlossen = true;

    return currentCategory.fragen[currentQuestionIndex];
  }

  QuizMasterBloc() : super(QuizMasterInitial()) {
    on<LoadPage>((event, emit) async {
      fragenList = await fileManagerService.readFragen();

      emit(QuizMasterCategorySelection(fragenList));
    });

    on<CorrectAnswer>((event, emit) {
      // Get point number of the origin Jugendfeuerwehr
      int gesetztePunkte = Global.jfBuzzerAssignments[currentJfIndex].points
          .where(
            (element) =>
                element.kategorieReihenfolge == currentCategoryReihenfolge,
          )
          .first
          .gesetztePunkte;

      // Add the positive points to pressed Jugendfeuerwehr
      Global.jfBuzzerAssignments[pressedJfIndex].points
          .where(
            (element) =>
                element.kategorieReihenfolge == currentCategoryReihenfolge,
          )
          .first
          .erhaltenePunkte
          .add(gesetztePunkte);

      if (currentJfIndex + 1 == Global.jfBuzzerAssignments.length) {
        currentJfIndex = 0;

        fragenList.fragen
            .where(
                (element) => currentCategoryReihenfolge == element.reihenfolge)
            .first
            .abgeschlossen = true;

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
            .where(
                (element) => currentCategoryReihenfolge == element.reihenfolge)
            .first
            .abgeschlossen = true;

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
      // Get point number of the origin Jugendfeuerwehr
      int gesetztePunkte = Global.jfBuzzerAssignments[currentJfIndex].points
          .where(
            (element) =>
                element.kategorieReihenfolge == currentCategoryReihenfolge,
          )
          .first
          .gesetztePunkte;

      // Add the negative points to the origin Jugendfeuerwehr
      Global.jfBuzzerAssignments[currentJfIndex].points
          .where(
            (element) =>
                element.kategorieReihenfolge == currentCategoryReihenfolge,
          )
          .first
          .erhaltenePunkte
          .add(-gesetztePunkte);

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
                  .where((element) =>
                      element.reihenfolge == currentCategoryReihenfolge)
                  .first
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
            .where(
                (element) => currentCategoryReihenfolge == element.reihenfolge)
            .first
            .abgeschlossen = true;

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
          .where((element) => element.jugendfeuerwehr.tisch == event.jfTisch)
          .first
          .points
          .where((element) =>
              element.kategorieReihenfolge == currentCategoryReihenfolge)
          .isNotEmpty) {
        Global.jfBuzzerAssignments
            .where((element) => element.jugendfeuerwehr.tisch == event.jfTisch)
            .first
            .points
            .removeWhere((element) =>
                element.kategorieReihenfolge == currentCategoryReihenfolge);
      }
      Global.jfBuzzerAssignments
          .where((element) => element.jugendfeuerwehr.tisch == event.jfTisch)
          .first
          .points
          .add(Points(
            kategorieReihenfolge: currentCategoryReihenfolge,
            gesetztePunkte: event.points,
          ));
    });
  }
}
