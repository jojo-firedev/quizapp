import 'dart:convert';

class Kategorie {
  int reihenfolge;
  String thema;
  bool abgeschlossen;

  Kategorie({
    required this.reihenfolge,
    required this.thema,
    this.abgeschlossen = false,
  });

  factory Kategorie.fromRawJson(String str) =>
      Kategorie.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Kategorie.fromJson(Map<String, dynamic> json) => Kategorie(
        reihenfolge: json["reihenfolge"],
        thema: json["name"],
        abgeschlossen: json["abgeschlossen"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "reihenfolge": reihenfolge,
        "name": thema,
        "abgeschlossen": abgeschlossen,
      };
}
