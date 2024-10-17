class Punkte {
  int kategorieReihenfolge;
  int gesetztePunkte;
  List<int> erhaltenePunkte = [];

  int get endpunkte => erhaltenePunkte.fold(0, (a, b) => a + b);

  Punkte({
    required this.kategorieReihenfolge,
    required this.gesetztePunkte,
  });

  // Convert Points object to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'kategorieReihenfolge': kategorieReihenfolge,
      'gesetztePunkte': gesetztePunkte,
      'erhaltenePunkte': erhaltenePunkte,
    };
  }

  // Create a Points object from a JSON map
  factory Punkte.fromJson(Map<String, dynamic> json) {
    return Punkte(
      kategorieReihenfolge: json['kategorieReihenfolge'],
      gesetztePunkte: json['gesetztePunkte'],
    )..erhaltenePunkte = List<int>.from(json['erhaltenePunkte']);
  }
}
