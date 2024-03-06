import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/models/buzzer_assignment.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/models/question.dart';

part 'quiz_master_event.dart';
part 'quiz_master_state.dart';

class QuizMasterBloc extends Bloc<QuizMasterEvent, QuizMasterState> {
  List<Jugendfeuerwehr> jugendfeuerwehren = Global.jugendfeuerwehren;
  List<BuzzerAssignment> buzzerAssignments = Global.assignedBuzzer;
  List<Question> questions = [
    Question('Fra4erh<ge 1', 'Antworfgyjten'),
    Question('Frawhege 2', 'Antwort<rdfhen'),
    Question('Fragwerhe 3', 'Antwowerhrten'),
    Question('Frage w4ezh e4', 'Antwo<rsdhnrten'),
    Question('Fragw4ee 5', 'Antw<wesghorten'),
  ];
  int currentJfIndex = 0;
  int currentQuestionIndex = 0;

  QuizMasterBloc() : super(QuizMasterInitial()) {
    on<LoadPage>((event, emit) {
      int randomIndex;
      do {
        randomIndex = Random().nextInt(questions.length);
      } while (questions[randomIndex].isAnswered);

      questions[randomIndex].isAnswered = true;

      print('Random Index: $randomIndex');
      currentQuestionIndex = randomIndex;

      currentJfIndex = (currentJfIndex + 1) % jugendfeuerwehren.length;
      Global.buzzerManagerService
          .sendBuzzerLock(mac: buzzerAssignments[currentJfIndex].mac);

      emit(QuizMasterQuestion(
        questions[currentQuestionIndex].question,
        questions[currentQuestionIndex].correctAnswer,
        jugendfeuerwehren[currentJfIndex].name,
        jugendfeuerwehren[currentJfIndex].name,
      ));
    });

    on<CorrectAnswer>((event, emit) {
      int randomIndex;
      do {
        randomIndex = Random().nextInt(questions.length);
      } while (questions[randomIndex].isAnswered);

      questions[randomIndex].isAnswered = true;

      print('Random Index: $randomIndex');
      currentQuestionIndex = randomIndex;

      currentJfIndex = (currentJfIndex + 1) % jugendfeuerwehren.length;
      Global.buzzerManagerService
          .sendBuzzerLock(mac: buzzerAssignments[currentJfIndex].mac);

      emit(QuizMasterQuestion(
        questions[currentQuestionIndex].question,
        questions[currentQuestionIndex].correctAnswer,
        jugendfeuerwehren[currentJfIndex].name,
        jugendfeuerwehren[currentJfIndex].name,
      ));
    });

    on<WrongAnswer>((event, emit) async {
      Global.buzzerManagerService.sendBuzzerRelease();
      await Global.streamController.stream.listen((event) {
        if (event.values.first == 'ButtonPressed') {
          print('Button pressed');
          int pressedJfIndex = buzzerAssignments
              .indexWhere((assignment) => assignment.mac == event.keys.first);

          emit(QuizMasterQuestion(
            questions[currentQuestionIndex].question,
            questions[currentQuestionIndex].correctAnswer,
            jugendfeuerwehren[currentJfIndex].name,
            jugendfeuerwehren[pressedJfIndex].name,
          ));
        }
      });
    });

    on<LockAllBuzzers>((event, emit) {
      Global.buzzerManagerService.sendBuzzerLock();
    });

    on<ReleaseAllBuzzers>((event, emit) {
      Global.buzzerManagerService.sendBuzzerRelease();
    });
  }
}
