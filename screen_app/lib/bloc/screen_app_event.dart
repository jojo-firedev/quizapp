part of 'screen_app_bloc.dart';

@immutable
sealed class ScreenAppEvent {}

class ConnectToServer extends ScreenAppEvent {}

class DisplayCategories extends ScreenAppEvent {
  final Map<String, bool> categories;
  final String? selectedCategory;
  DisplayCategories({required this.categories, this.selectedCategory});
}

class DisplayQuestion extends ScreenAppEvent {
  final String question;
  final String category;
  final String jugendfeuerwehr;
  DisplayQuestion(
      {required this.question,
      required this.category,
      required this.jugendfeuerwehr});
}

class DisplayCountdown extends ScreenAppEvent {
  final String question;
  final String category;
  final int countdown;
  DisplayCountdown(
      {required this.question,
      required this.category,
      required this.countdown});
}

class DisplayAnswer extends ScreenAppEvent {
  final String question;
  final String answer;
  final String category;
  final String jugendfeuerwehr;
  DisplayAnswer(
      {required this.question,
      required this.answer,
      required this.category,
      required this.jugendfeuerwehr});
}

class DisplayScore extends ScreenAppEvent {
  final int score;
  DisplayScore({required this.score});
}

class DisplayPointInput extends ScreenAppEvent {
  final List<String> jugendfeuerwehren;
  final List<int> currentPoints;
  final List<int> inputPoints;

  DisplayPointInput({
    required this.jugendfeuerwehren,
    required this.currentPoints,
    required this.inputPoints,
  });
}
