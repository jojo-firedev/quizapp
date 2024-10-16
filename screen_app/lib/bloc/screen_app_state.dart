part of 'screen_app_bloc.dart';

@immutable
sealed class ScreenAppState {}

final class ScreenAppInitial extends ScreenAppState {}

final class ScreenAppConnecting extends ScreenAppState {}

final class ScreenAppWaitingForData extends ScreenAppState {}

final class ScreenAppShowCategory extends ScreenAppState {
  final Map<String, bool> categories;
  final String? selectedCategory;

  ScreenAppShowCategory(this.categories, this.selectedCategory);
}

final class ScreenAppShowQuestion extends ScreenAppState {
  final String question;
  final String category;
  final String jugendfeuerwehr;

  ScreenAppShowQuestion(this.question, this.category, this.jugendfeuerwehr);
}

final class ScreenAppShowCountdown extends ScreenAppState {
  final String question;
  final String category;
  final int countdown;

  ScreenAppShowCountdown(this.question, this.category, this.countdown);
}

final class ScreenAppShowAnswer extends ScreenAppState {
  final String question;
  final String answer;
  final String category;
  final String jugendfeuerwehr;

  ScreenAppShowAnswer(
      this.question, this.answer, this.category, this.jugendfeuerwehr);
}

final class ScreenAppShowScore extends ScreenAppState {
  final int score;

  ScreenAppShowScore(this.score);
}

final class ScreenAppShowPointInput extends ScreenAppState {
  final List<String> jugendfeuerwehren;
  final List<int> currentPoints;
  final List<int> inputPoints;

  ScreenAppShowPointInput(
      this.jugendfeuerwehren, this.currentPoints, this.inputPoints);
}
