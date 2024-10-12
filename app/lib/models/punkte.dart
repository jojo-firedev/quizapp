class RundenPunkte {
  int startPunkte;
  int gesetztePunkte;
  List<int> erhaltenePunkte;
  int gehoertZuJfTisch;

  int get endpunkte => startPunkte + erhaltenePunkte.fold(0, (a, b) => a + b);

  RundenPunkte({
    required this.startPunkte,
    required this.gesetztePunkte,
    required this.gehoertZuJfTisch,
    this.erhaltenePunkte = const [],
  });
}

class GlobalerPunkteSpeicher {
  int kategorieReihenfolge;
  List<RundenPunkte> rundenPunkte;

  int punkteStandFuerJfTisch(int jfTisch) {
    return rundenPunkte
        .where((element) => element.gehoertZuJfTisch == jfTisch)
        .fold(0, (a, b) => a + b.endpunkte);
  }

  GlobalerPunkteSpeicher({
    required this.kategorieReihenfolge,
    this.rundenPunkte = const [],
  });
}
