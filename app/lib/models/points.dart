class Points {
  int kategorieReihenfolge;
  int gesetztePunkte;
  List<int> erhaltenePunkte = [];

  int get endpunkte => erhaltenePunkte.fold(0, (a, b) => a + b);

  Points({
    required this.kategorieReihenfolge,
    required this.gesetztePunkte,
  });
}
