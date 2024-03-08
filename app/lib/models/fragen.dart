import 'dart:convert';

class Fragen {
  Map<String, String> themen;
  Map<String, List<FragenElement>> fragen;

  Fragen({
    required this.themen,
    required this.fragen,
  });

  factory Fragen.fromRawJson(String str) => Fragen.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Fragen.fromJson(Map<String, dynamic> json) => Fragen(
        themen: Map.from(json["themen"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        fragen: Map.from(json["fragen"]).map((k, v) => MapEntry<String,
                List<FragenElement>>(k,
            List<FragenElement>.from(v.map((x) => FragenElement.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "themen":
            Map.from(themen).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "fragen": Map.from(fragen).map((k, v) => MapEntry<String, dynamic>(
            k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };
}

class FragenElement {
  String frage;
  String antwort;

  FragenElement({
    required this.frage,
    required this.antwort,
  });

  factory FragenElement.fromRawJson(String str) =>
      FragenElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FragenElement.fromJson(Map<String, dynamic> json) => FragenElement(
        frage: json["frage"],
        antwort: json["antwort"],
      );

  Map<String, dynamic> toJson() => {
        "frage": frage,
        "antwort": antwort,
      };
}
