import 'package:quizapp/globals.dart';
import 'package:quizapp/models/buzzer_assignment.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/models/points.dart';

class JfBuzzerAssignment {
  final Jugendfeuerwehr jugendfeuerwehr;
  final BuzzerAssignment buzzerAssignment;
  List<Points> points = [];

  JfBuzzerAssignment({
    required this.jugendfeuerwehr,
    required this.buzzerAssignment,
  });

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

  // Convert JfBuzzerAssignment object to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'jugendfeuerwehr': jugendfeuerwehr.toJson(),
      'buzzerAssignment': buzzerAssignment.toJson(),
      'points': points.map((point) => point.toJson()).toList(),
    };
  }

  // Create a JfBuzzerAssignment object from a JSON map
  factory JfBuzzerAssignment.fromJson(Map<String, dynamic> json) {
    return JfBuzzerAssignment(
      jugendfeuerwehr: Jugendfeuerwehr.fromJson(json['jugendfeuerwehr']),
      buzzerAssignment: BuzzerAssignment.fromJson(json['buzzerAssignment']),
    )..points = (json['points'] as List)
        .map((pointJson) => Points.fromJson(pointJson))
        .toList();
  }
}
