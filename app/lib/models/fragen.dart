import 'dart:convert';

class FragenList {
  final List<FragenKategorie> fragen;

  FragenList({required this.fragen});

  factory FragenList.fromJson(Map<String, dynamic> json) {
    return FragenList(
      fragen: (json["fragen"] as List)
          .map((e) => FragenKategorie.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fragen": fragen.map((e) => e.toJson()).toList(),
    };
  }

  String toRawJson() => jsonEncode(toJson());
}

class FragenKategorie {
  final String thema;
  final int reihenfolge;
  final List<FragenFrage> fragen;
  bool abgeschlossen;

  FragenKategorie({
    required this.thema,
    required this.reihenfolge,
    required this.fragen,
    this.abgeschlossen = false,
  });

  factory FragenKategorie.fromJson(Map<String, dynamic> json) {
    return FragenKategorie(
      thema: json["thema"],
      reihenfolge: json["reihenfolge"],
      fragen:
          (json["fragen"] as List).map((e) => FragenFrage.fromJson(e)).toList(),
      abgeschlossen: json["abgeschlossen"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "thema": thema,
      "reihenfolge": reihenfolge,
      "fragen": fragen.map((e) => e.toJson()).toList(),
      "abgeschlossen": abgeschlossen,
    };
  }
}

class FragenFrage {
  final String frage;
  final String antwort;
  bool abgeschlossen;

  FragenFrage({
    required this.frage,
    required this.antwort,
    this.abgeschlossen = false,
  });

  factory FragenFrage.fromJson(Map<String, dynamic> json) {
    return FragenFrage(
      frage: json["frage"],
      antwort: json["antwort"],
      abgeschlossen: json["abgeschlossen"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "frage": frage,
      "antwort": antwort,
      "abgeschlossen": abgeschlossen,
    };
  }
}
