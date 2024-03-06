part of 'quiz_master_bloc.dart';

@immutable
sealed class QuizMasterState {}

final class QuizMasterInitial extends QuizMasterState {}

final class QuizMasterQuestion extends QuizMasterState {
  final String question;
  final String answer;
  final String currentJf;
  final String pressedJf;

  QuizMasterQuestion(
      this.question, this.answer, this.currentJf, this.pressedJf);
}
