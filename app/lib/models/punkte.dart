class Punkte {
  int kategorieReihenfolge;
  int gesetztePunkte;
  List<int> erhaltenePunkte = [];

  int get endpunkte =>
      gesetztePunkte + erhaltenePunkte.fold(0, (a, b) => a + b);

  Punkte({
    required this.kategorieReihenfolge,
    required this.gesetztePunkte,
  });
}
