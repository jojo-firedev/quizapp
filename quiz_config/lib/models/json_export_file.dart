import 'dart:convert';

class JsonExportFile {
  List<ExportTeilnehmer>? teilnehmer;
  List<ExportKategorie>? kategorien;
  List<String> buzzerTischZuordnung = [];

  JsonExportFile({
    this.teilnehmer,
    this.kategorien,
    this.buzzerTischZuordnung = const [],
  });

  JsonExportFile copyWith({
    List<ExportTeilnehmer>? teilnehmer,
    List<ExportKategorie>? kategorien,
  }) =>
      JsonExportFile(
        teilnehmer: teilnehmer ?? this.teilnehmer,
        kategorien: kategorien ?? this.kategorien,
      );

  factory JsonExportFile.fromRawJson(String str) =>
      JsonExportFile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JsonExportFile.fromJson(Map<String, dynamic> json) => JsonExportFile(
        teilnehmer: json["teilnehmer"] == null
            ? []
            : List<ExportTeilnehmer>.from(
                json["teilnehmer"]!.map((x) => ExportTeilnehmer.fromJson(x))),
        kategorien: json["kategorien"] == null
            ? []
            : List<ExportKategorie>.from(
                json["kategorien"]!.map((x) => ExportKategorie.fromJson(x))),
        buzzerTischZuordnung: [],
      );

  Map<String, dynamic> toJson() => {
        "teilnehmer": teilnehmer == null
            ? []
            : List<dynamic>.from(teilnehmer!.map((x) => x.toJson())),
        "kategorien": kategorien == null
            ? []
            : List<dynamic>.from(kategorien!.map((x) => x.toJson())),
        "buzzer_tisch_zuordnung": [],
      };
}

class ExportKategorie {
  int? reihenfolge;
  String? name;
  bool abgeschlossen = false;

  ExportKategorie({
    this.reihenfolge,
    this.name,
    this.abgeschlossen = false,
  });

  ExportKategorie copyWith({
    int? reihenfolge,
    String? name,
  }) =>
      ExportKategorie(
        reihenfolge: reihenfolge ?? this.reihenfolge,
        name: name ?? this.name,
      );

  factory ExportKategorie.fromRawJson(String str) =>
      ExportKategorie.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExportKategorie.fromJson(Map<String, dynamic> json) =>
      ExportKategorie(
        reihenfolge: json["reihenfolge"],
        name: json["name"],
        abgeschlossen: json["abgeschlossen"],
      );

  Map<String, dynamic> toJson() => {
        "reihenfolge": reihenfolge,
        "name": name,
        "abgeschlossen": abgeschlossen,
      };
}

class ExportTeilnehmer {
  ExportJugendfeuerwehr? jugendfeuerwehr;
  List<ExportFrage>? fragen;
  List<String> punkte = [];

  ExportTeilnehmer({
    this.jugendfeuerwehr,
    this.fragen,
    this.punkte = const [],
  });

  ExportTeilnehmer copyWith({
    ExportJugendfeuerwehr? jugendfeuerwehr,
    List<ExportFrage>? fragen,
  }) =>
      ExportTeilnehmer(
        jugendfeuerwehr: jugendfeuerwehr ?? this.jugendfeuerwehr,
        fragen: fragen ?? this.fragen,
      );

  factory ExportTeilnehmer.fromRawJson(String str) =>
      ExportTeilnehmer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExportTeilnehmer.fromJson(Map<String, dynamic> json) =>
      ExportTeilnehmer(
        jugendfeuerwehr: json["jugendfeuerwehr"] == null
            ? null
            : ExportJugendfeuerwehr.fromJson(json["jugendfeuerwehr"]),
        fragen: json["fragen"] == null
            ? []
            : List<ExportFrage>.from(
                json["fragen"]!.map((x) => ExportFrage.fromJson(x))),
        punkte: json["punkte"] == null
            ? []
            : List<String>.from(json["punkte"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "jugendfeuerwehr": jugendfeuerwehr?.toJson(),
        "fragen": fragen == null
            ? []
            : List<dynamic>.from(fragen!.map((x) => x.toJson())),
        "punkte": [],
      };
}

class ExportFrage {
  int? kategorieReihenfolge;
  String? frage;
  String? antwort;

  ExportFrage({
    this.kategorieReihenfolge,
    this.frage,
    this.antwort,
  });

  ExportFrage copyWith({
    int? kategorie,
    String? frage,
    String? antwort,
  }) =>
      ExportFrage(
        kategorieReihenfolge: kategorie ?? this.kategorieReihenfolge,
        frage: frage ?? this.frage,
        antwort: antwort ?? this.antwort,
      );

  factory ExportFrage.fromRawJson(String str) =>
      ExportFrage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExportFrage.fromJson(Map<String, dynamic> json) => ExportFrage(
        kategorieReihenfolge: json["kategorie"],
        frage: json["frage"],
        antwort: json["antwort"],
      );

  Map<String, dynamic> toJson() => {
        "kategorie": kategorieReihenfolge,
        "frage": frage,
        "antwort": antwort,
      };
}

class ExportJugendfeuerwehr {
  int? reihenfolge;
  String? name;
  int? tisch;

  ExportJugendfeuerwehr({
    this.reihenfolge,
    this.name,
    this.tisch,
  });

  ExportJugendfeuerwehr copyWith({
    int? reihenfolge,
    String? name,
    int? tisch,
  }) =>
      ExportJugendfeuerwehr(
        reihenfolge: reihenfolge ?? this.reihenfolge,
        name: name ?? this.name,
        tisch: tisch ?? this.tisch,
      );

  factory ExportJugendfeuerwehr.fromRawJson(String str) =>
      ExportJugendfeuerwehr.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExportJugendfeuerwehr.fromJson(Map<String, dynamic> json) =>
      ExportJugendfeuerwehr(
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
