part of 'quiz_master_bloc.dart';

@immutable
sealed class QuizMasterEvent {}

class LoadPage extends QuizMasterEvent {}

class CorrectAnswer extends QuizMasterEvent {}

class WrongAnswer extends QuizMasterEvent {}

class ShowAnswer extends QuizMasterEvent {}

class EndQuiz extends QuizMasterEvent {}

class LockAllBuzzers extends QuizMasterEvent {}

class ReleaseAllBuzzers extends QuizMasterEvent {}

class SelectCategory extends QuizMasterEvent {
  final int categoryReihenfolge;

  SelectCategory(this.categoryReihenfolge);
}

class ConfirmPoints extends QuizMasterEvent {}

class PointsUpdated extends QuizMasterEvent {
  final int jfTisch;
  final int points;

  PointsUpdated({required this.jfTisch, required this.points});
}
