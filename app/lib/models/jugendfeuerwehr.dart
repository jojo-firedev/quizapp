class Jugendfeuerwehr {
  final int reihnfolge;
  final String name;
  final String gemeinde;
  final int tisch;

  Jugendfeuerwehr({
    required this.reihnfolge,
    required this.name,
    required this.gemeinde,
    required this.tisch,
  });

  factory Jugendfeuerwehr.fromJson(Map<String, dynamic> json) {
    return Jugendfeuerwehr(
      reihnfolge: json['reihnfolge'],
      name: json['name'],
      gemeinde: json['gemeinde'],
      tisch: json['tisch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reihnfolge': reihnfolge,
      'name': name,
      'gemeinde': gemeinde,
      'tisch': tisch,
    };
  }
}
