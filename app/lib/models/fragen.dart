import 'dart:convert';

class Fragen {
  final List<FragenFragen> fragen;

  Fragen({
    required this.fragen,
  });

  factory Fragen.fromRawJson(String str) => Fragen.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Fragen.fromJson(Map<String, dynamic> json) => Fragen(
        fragen: List<FragenFragen>.from(
            json["fragen"].map((x) => FragenFragen.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "fragen": List<dynamic>.from(fragen.map((x) => x.toJson())),
      };
}

class FragenFragen {
  final String thema;
  final int reihenfolge;
  final List<FragenFragenClass> fragen;

  FragenFragen({
    required this.thema,
    required this.reihenfolge,
    required this.fragen,
  });

  factory FragenFragen.fromRawJson(String str) =>
      FragenFragen.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FragenFragen.fromJson(Map<String, dynamic> json) => FragenFragen(
        thema: json["thema"],
        reihenfolge: json["reihenfolge"],
        fragen: List<FragenFragenClass>.from(
            json["fragen"].map((x) => FragenFragenClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "thema": thema,
        "reihenfolge": reihenfolge,
        "fragen": List<dynamic>.from(fragen.map((x) => x.toJson())),
      };
}

class FragenFragenClass {
  final String frage;
  final String antwort;

  FragenFragenClass({
    required this.frage,
    required this.antwort,
  });

  factory FragenFragenClass.fromRawJson(String str) =>
      FragenFragenClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FragenFragenClass.fromJson(Map<String, dynamic> json) =>
      FragenFragenClass(
        frage: json["frage"],
        antwort: json["antwort"],
      );

  Map<String, dynamic> toJson() => {
        "frage": frage,
        "antwort": antwort,
      };
}
