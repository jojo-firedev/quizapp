class Frage {
  final String frage;
  final String antwort;
  final String kategorie;

  Frage({required this.frage, required this.antwort, required this.kategorie});

  factory Frage.fromCsv(List<dynamic> row) {
    return Frage(
      frage: row[0] as String,
      antwort: row[1] as String,
      kategorie: row[2] as String,
    );
  }
}
