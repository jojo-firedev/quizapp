part of 'quiz_config_bloc.dart';

@immutable
sealed class QuizConfigEvent {}

class SelectJugendfeuerwehr extends QuizConfigEvent {
  final Jugendfeuerwehr jugendfeuerwehr;

  SelectJugendfeuerwehr(this.jugendfeuerwehr);
}

class RemoveJugendfeuerwehr extends QuizConfigEvent {
  final int index;

  RemoveJugendfeuerwehr(this.index);
}

class ReoderJugendfeuerwehr extends QuizConfigEvent {
  final int oldIndex;
  final int newIndex;

  ReoderJugendfeuerwehr(this.oldIndex, this.newIndex);
}

class StartNeuenTag extends QuizConfigEvent {
  final DateTime datum;
  final int durchlaeufe;

  StartNeuenTag(this.datum, this.durchlaeufe);
}

class ConfirmNeuerTag extends QuizConfigEvent {}

class ConfirmKategorieReihenfolge extends QuizConfigEvent {
  final List<Thema> kategorien;

  ConfirmKategorieReihenfolge(this.kategorien);
}

class ExportData extends QuizConfigEvent {}

class FragenJugendfeuerwehrZuordnen extends QuizConfigEvent {}
