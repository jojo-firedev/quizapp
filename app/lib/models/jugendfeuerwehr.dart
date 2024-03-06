class Jugendfeuerwehr {
  final int reihenfolge;
  final String name;
  final int tisch;

  Jugendfeuerwehr({
    required this.reihenfolge,
    required this.name,
    required this.tisch,
  });

  factory Jugendfeuerwehr.fromJson(Map<String, dynamic> json) {
    return Jugendfeuerwehr(
      reihenfolge: json['reihnfolge'],
      name: json['name'],
      tisch: json['tisch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reihnfolge': reihenfolge,
      'name': name,
      'tisch': tisch,
    };
  }
}
