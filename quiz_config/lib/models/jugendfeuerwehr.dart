class Jugendfeuerwehr {
  final String name;
  final String gemeinde;

  Jugendfeuerwehr({required this.name, required this.gemeinde});

  factory Jugendfeuerwehr.fromCsv(List<dynamic> row) {
    return Jugendfeuerwehr(
      name: row[0] as String,
      gemeinde: row[1] as String,
    );
  }
}
