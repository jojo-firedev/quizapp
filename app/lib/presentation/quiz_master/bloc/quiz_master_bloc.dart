import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/models/fragen.dart';
import 'package:quizapp/models/jf_buzzer_assignment.dart';
import 'package:quizapp/service/file_manager_service.dart';

part 'quiz_master_event.dart';
part 'quiz_master_state.dart';

class QuizMasterBloc extends Bloc<QuizMasterEvent, QuizMasterState> {
  FileManagerService fileManagerService = const FileManagerService();
  List<JfBuzzerAssignment> jfBuzzerAssignments = Global.jfBuzzerAssignments;
  late FragenList fragenList;
  int currentJfIndex = 0;
  int currentQuestionIndex = 0;
  int currentCategoryReihenfolge = 0;

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

    print('Random Index: $randomIndex');
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
      currentJfIndex = (currentJfIndex + 1) % jfBuzzerAssignments.length;
      Global.buzzerManagerService.sendBuzzerLock(
          mac: jfBuzzerAssignments[currentJfIndex].buzzerAssignment.mac);

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
          jfBuzzerAssignments[currentJfIndex].jugendfeuerwehr.name,
          "",
        ));
      }
    });

    on<WrongAnswer>((event, emit) async {
      Global.buzzerManagerService.sendBuzzerRelease();

      // Listen to the buzzerManagerService stream
      await emit.forEach(
        Global.buzzerManagerService.stream,
        onData: (streamEvent) {
          if (streamEvent.values.first == 'ButtonPressed') {
            print('Button pressed');
            int pressedJfIndex = jfBuzzerAssignments.indexWhere((assignment) =>
                assignment.buzzerAssignment.mac == streamEvent.keys.first);

            // Emit the QuizMasterQuestion state with the appropriate pressed button index
            return QuizMasterQuestion(
              fragenList.fragen
                  .where((element) =>
                      element.reihenfolge == currentCategoryReihenfolge)
                  .first
                  .fragen[currentQuestionIndex],
              jfBuzzerAssignments[currentJfIndex].jugendfeuerwehr.name,
              jfBuzzerAssignments[pressedJfIndex].jugendfeuerwehr.name,
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

    on<CategorySelected>((event, emit) {
      currentCategoryReihenfolge = fragenList.fragen
          .where((element) => element.reihenfolge == event.categoryReihenfolge)
          .first
          .reihenfolge;
      currentJfIndex = 0;

      emit(QuizMasterPoints());
    });

    on<SavePoints>((event, emit) {
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
          jfBuzzerAssignments[currentJfIndex].jugendfeuerwehr.name,
          jfBuzzerAssignments[currentJfIndex].jugendfeuerwehr.name,
        ));
      }
    });
  }
}
