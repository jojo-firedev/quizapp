part of 'quiz_master_bloc.dart';

@immutable
sealed class QuizMasterEvent {}

class LoadPage extends QuizMasterEvent {}

class CorrectAnswer extends QuizMasterEvent {}

class WrongAnswer extends QuizMasterEvent {}

class ShowAnswer extends QuizMasterEvent {}

class ShowNextQuestion extends QuizMasterEvent {}

class EndQuiz extends QuizMasterEvent {}

class LockAllBuzzers extends QuizMasterEvent {}

class ReleaseAllBuzzers extends QuizMasterEvent {}

class SelectKategorie extends QuizMasterEvent {
  final int categoryReihenfolge;

  SelectKategorie(this.categoryReihenfolge);
}

class BestaetigePunkte extends QuizMasterEvent {}

class AktualisierePunkte extends QuizMasterEvent {
  final int jfTisch;
  final int points;

  AktualisierePunkte({required this.jfTisch, required this.points});
}

class ShowResults extends QuizMasterEvent {}
