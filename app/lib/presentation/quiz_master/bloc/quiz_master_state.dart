part of 'quiz_master_bloc.dart';

@immutable
sealed class QuizMasterState {}

final class QuizMasterInitial extends QuizMasterState {}

final class QuizMasterQuestion extends QuizMasterState {
  final FragenFrage frage;
  final String currentJf;
  final String pressedJf;

  QuizMasterQuestion(this.frage, this.currentJf, this.pressedJf);
}

final class QuizMasterPoints extends QuizMasterState {
  final List<JfBuzzerAssignment> jfBuzzerAssignments;
  final int currentCategoryReihenfolge;

  QuizMasterPoints(
    this.jfBuzzerAssignments,
    this.currentCategoryReihenfolge,
  );
}

final class QuizMasterCategorySelection extends QuizMasterState {
  final FragenList fragenList;

  QuizMasterCategorySelection(this.fragenList);
}
