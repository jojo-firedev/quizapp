import 'dart:convert';

class Frage {
  int kategorie;
  String frage;
  String antwort;
  bool beantwortet = false;

  Frage({
    required this.kategorie,
    required this.frage,
    required this.antwort,
    this.beantwortet = false,
  });

  factory Frage.fromRawJson(String str) => Frage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Frage.fromJson(Map<String, dynamic> json) => Frage(
        kategorie: json["kategorie"],
        frage: json["frage"],
        antwort: json["antwort"],
        beantwortet: json["beantwortet"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "kategorie": kategorie,
        "frage": frage,
        "antwort": antwort,
        "beantwortet": beantwortet,
      };
}
