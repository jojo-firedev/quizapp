import 'package:meta/meta.dart';
import 'dart:convert';

class Fragen {
  Map<String, String> themen;
  FragenClass fragen;

  Fragen({
    required this.themen,
    required this.fragen,
  });

  factory Fragen.fromRawJson(String str) => Fragen.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Fragen.fromJson(Map<String, dynamic> json) => Fragen(
        themen: Map.from(json["themen"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        fragen: FragenClass.fromJson(json["fragen"]),
      );

  Map<String, dynamic> toJson() => {
        "themen":
            Map.from(themen).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "fragen": fragen.toJson(),
      };
}

class FragenClass {
  List<Feuerwehr> wirtschaft;
  List<Feuerwehr> politik;
  List<Feuerwehr> sport;
  List<Feuerwehr> feuerwehr;
  List<Feuerwehr> technik;

  FragenClass({
    required this.wirtschaft,
    required this.politik,
    required this.sport,
    required this.feuerwehr,
    required this.technik,
  });

  factory FragenClass.fromRawJson(String str) =>
      FragenClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FragenClass.fromJson(Map<String, dynamic> json) => FragenClass(
        wirtschaft: List<Feuerwehr>.from(
            json["wirtschaft"].map((x) => Feuerwehr.fromJson(x))),
        politik: List<Feuerwehr>.from(
            json["politik"].map((x) => Feuerwehr.fromJson(x))),
        sport: List<Feuerwehr>.from(
            json["sport"].map((x) => Feuerwehr.fromJson(x))),
        feuerwehr: List<Feuerwehr>.from(
            json["feuerwehr"].map((x) => Feuerwehr.fromJson(x))),
        technik: List<Feuerwehr>.from(
            json["technik"].map((x) => Feuerwehr.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "wirtschaft": List<dynamic>.from(wirtschaft.map((x) => x.toJson())),
        "politik": List<dynamic>.from(politik.map((x) => x.toJson())),
        "sport": List<dynamic>.from(sport.map((x) => x.toJson())),
        "feuerwehr": List<dynamic>.from(feuerwehr.map((x) => x.toJson())),
        "technik": List<dynamic>.from(technik.map((x) => x.toJson())),
      };
}

class Feuerwehr {
  String frage;
  String antwort;

  Feuerwehr({
    required this.frage,
    required this.antwort,
  });

  factory Feuerwehr.fromRawJson(String str) =>
      Feuerwehr.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Feuerwehr.fromJson(Map<String, dynamic> json) => Feuerwehr(
        frage: json["frage"],
        antwort: json["antwort"],
      );

  Map<String, dynamic> toJson() => {
        "frage": frage,
        "antwort": antwort,
      };
}
