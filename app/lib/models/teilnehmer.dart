import 'package:quizapp/globals.dart';
import 'package:quizapp/models/frage.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/models/punkte.dart';

class Teilnehmer {
  final Jugendfeuerwehr jugendfeuerwehr;
  final List<Frage> fragen;
  List<Punkte> punkte = [];

  Teilnehmer({
    required this.jugendfeuerwehr,
    required this.fragen,
  });

  /// Logging method for debugging purposes
  void logPointsPerCategory(int kategorieReihenfolge) {
    final Punkte punkt = punkte
        .where(
            (element) => element.kategorieReihenfolge == kategorieReihenfolge)
        .first;

    Global.logger.d(
      'jugendfeuerwehr: ${jugendfeuerwehr.name}\n'
      'gesetztePunkte: ${punkt.gesetztePunkte}\n'
      'erhaltenePunkte: ${punkt.erhaltenePunkte}\n'
      'endpunkte: ${punkt.endpunkte}',
    );
  }

  int get gesamtPunkte => punkte.fold(0, (a, b) => a + b.endpunkte);

  // Convert JfBuzzerAssignment object to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'jugendfeuerwehr': jugendfeuerwehr.toJson(),
      'punkte': punkte.map((point) => point.toJson()).toList(),
      'fragen': fragen.map((frage) => frage.toJson()).toList(),
    };
  }

  // Create a JfBuzzerAssignment object from a JSON map
  factory Teilnehmer.fromJson(Map<String, dynamic> json) {
    Teilnehmer teilnehmer = Teilnehmer(
      jugendfeuerwehr: Jugendfeuerwehr.fromJson(json['jugendfeuerwehr']),
      fragen: (json['fragen'] as List)
          .map((frageJson) => Frage.fromJson(frageJson))
          .toList(),
    );
    if (json['punkte'] != null) {
      teilnehmer.punkte = (json['punkte'] as List)
          .map((pointJson) => Punkte.fromJson(pointJson))
          .toList();
    }
    return teilnehmer;
  }
}
