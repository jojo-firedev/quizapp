import 'package:quizapp/globals.dart';
import 'package:quizapp/models/buzzer_assignment.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/models/points.dart';

class JfBuzzerAssignment {
  final Jugendfeuerwehr jugendfeuerwehr;
  final BuzzerAssignment buzzerAssignment;
  List<Points> points = [];

  /// Logging method for debugging purposes
  void logPointsPerCategory(int kategorieReihenfolge) {
    final Points point = points
        .where(
            (element) => element.kategorieReihenfolge == kategorieReihenfolge)
        .first;

    Global.logger.d(
      'jugendfeuerwehr: ${jugendfeuerwehr.name}\n'
      'gesetztePunkte: ${point.gesetztePunkte}\n'
      'erhaltenePunkte: ${point.erhaltenePunkte}\n'
      'endpunkte: ${point.endpunkte}',
    );
  }

  int get gesamtPunkte => points.fold(0, (a, b) => a + b.endpunkte);

  JfBuzzerAssignment({
    required this.jugendfeuerwehr,
    required this.buzzerAssignment,
  });
}
