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
