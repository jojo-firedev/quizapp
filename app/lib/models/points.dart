class Points {
  int kategorieReihenfolge;
  int gesetztePunkte;
  List<int> erhaltenePunkte = [];

  int get endpunkte => erhaltenePunkte.fold(0, (a, b) => a + b);

  Points({
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
  factory Points.fromJson(Map<String, dynamic> json) {
    return Points(
      kategorieReihenfolge: json['kategorieReihenfolge'],
      gesetztePunkte: json['gesetztePunkte'],
    )..erhaltenePunkte = List<int>.from(json['erhaltenePunkte']);
  }
}
