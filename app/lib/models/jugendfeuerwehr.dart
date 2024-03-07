import 'dart:convert';

class Jugendfeuerwehr {
  int reihenfolge;
  String name;
  int tisch;

  Jugendfeuerwehr({
    required this.reihenfolge,
    required this.name,
    required this.tisch,
  });

  factory Jugendfeuerwehr.fromRawJson(String str) =>
      Jugendfeuerwehr.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Jugendfeuerwehr.fromJson(Map<String, dynamic> json) =>
      Jugendfeuerwehr(
        reihenfolge: json["reihenfolge"],
        name: json["name"],
        tisch: json["tisch"],
      );

  Map<String, dynamic> toJson() => {
        "reihenfolge": reihenfolge,
        "name": name,
        "tisch": tisch,
      };
}
