part of 'quiz_config_bloc.dart';

@immutable
sealed class QuizConfigState {}

final class QuizConfigInitial extends QuizConfigState {}

final class QuizConfigStartNeuenTag extends QuizConfigState {
  final DateTime datum;
  final int durchlaeufe;

  QuizConfigStartNeuenTag(this.datum, this.durchlaeufe);
}

final class QuizConfigImportFragen extends QuizConfigState {
  final List<String> kategorien;

  QuizConfigImportFragen(this.kategorien);
}

final class QuizConfigSelectJugendfeuerwehren extends QuizConfigState {
  final List<Jugendfeuerwehr> jugendfeuerwehren;
  final List<Jugendfeuerwehr> ausgewaehlteJugendfeuerwehren;

  QuizConfigSelectJugendfeuerwehren(
      this.jugendfeuerwehren, this.ausgewaehlteJugendfeuerwehren);
}

final class QuizConfigAssignFragen extends QuizConfigState {
  final List<Jugendfeuerwehr> selectedItems;

  QuizConfigAssignFragen(this.selectedItems);
}
