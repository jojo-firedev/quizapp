part of 'quiz_master_bloc.dart';

@immutable
sealed class QuizMasterState {}

final class QuizMasterInitial extends QuizMasterState {}

final class QuizMasterQuestion extends QuizMasterState {
  final Frage frage;
  final String currentJf;
  final String pressedJf;

  QuizMasterQuestion(this.frage, this.currentJf, this.pressedJf);
}

final class QuizMasterQuestionConfirmShowAnswer extends QuizMasterQuestion {
  QuizMasterQuestionConfirmShowAnswer(
    super.frage,
    super.currentJf,
    super.pressedJf,
  );
}

final class QuizMasterQuestionShowAnswer extends QuizMasterQuestion {
  QuizMasterQuestionShowAnswer(
    super.frage,
    super.currentJf,
    super.pressedJf,
  );
}

final class QuizMasterPoints extends QuizMasterState {
  final List<Teilnehmer> jfBuzzerAssignments;
  final int currentCategoryReihenfolge;

  QuizMasterPoints(
    this.jfBuzzerAssignments,
    this.currentCategoryReihenfolge,
  );
}

final class QuizMasterCategorySelection extends QuizMasterState {
  final List<Kategorie> kategorieList;

  QuizMasterCategorySelection(this.kategorieList);
}

final class QuizMasterResults extends QuizMasterState {
  final List<Teilnehmer> teilnehmerList;

  QuizMasterResults(this.teilnehmerList);
}
