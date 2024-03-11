import 'dart:convert';

class FragenList {
  final List<FragenKategorie> fragen;

  FragenList({
    required this.fragen,
  });

  factory FragenList.fromRawJson(String str) =>
      FragenList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FragenList.fromJson(Map<String, dynamic> json) => FragenList(
        fragen: List<FragenKategorie>.from(
            json["fragen"].map((x) => FragenKategorie.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "fragen": List<dynamic>.from(fragen.map((x) => x.toJson())),
      };
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

  factory FragenKategorie.fromRawJson(String str) =>
      FragenKategorie.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FragenKategorie.fromJson(Map<String, dynamic> json) =>
      FragenKategorie(
        thema: json["thema"],
        reihenfolge: json["reihenfolge"],
        fragen: List<FragenFrage>.from(
            json["fragen"].map((x) => FragenFrage.fromJson(x))),
        abgeschlossen: json["abgeschlossen"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "thema": thema,
        "reihenfolge": reihenfolge,
        "fragen": List<dynamic>.from(fragen.map((x) => x.toJson())),
        "abgeschlossen": abgeschlossen,
      };
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

  factory FragenFrage.fromRawJson(String str) =>
      FragenFrage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FragenFrage.fromJson(Map<String, dynamic> json) => FragenFrage(
        frage: json["frage"],
        antwort: json["antwort"],
        abgeschlossen: json["abgeschlossen"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "frage": frage,
        "antwort": antwort,
        "abgeschlossen": abgeschlossen,
      };
}
