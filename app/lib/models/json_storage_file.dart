import 'dart:convert';

import 'package:quizapp/models/buzzer_tisch_zuordnung.dart';
import 'package:quizapp/models/kategorie.dart';
import 'package:quizapp/models/teilnehmer.dart';

class JsonStorageFile {
  List<Teilnehmer> teilnehmer;
  List<Kategorie> kategorien;
  List<BuzzerTischZuordnung>? buzzerTischZuordnung;

  JsonStorageFile({
    required this.teilnehmer,
    required this.buzzerTischZuordnung,
    required this.kategorien,
  });

  factory JsonStorageFile.fromRawJson(String str) =>
      JsonStorageFile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JsonStorageFile.fromJson(Map<String, dynamic> json) =>
      JsonStorageFile(
        teilnehmer: List<Teilnehmer>.from(
            json["teilnehmer"].map((x) => Teilnehmer.fromJson(x))),
        kategorien: List<Kategorie>.from(
            json["kategorien"].map((x) => Kategorie.fromJson(x))),
        buzzerTischZuordnung: (json["buzzer_tisch_zuordnung"] != null)
            ? List<BuzzerTischZuordnung>.from(json["buzzer_tisch_zuordnung"]
                .map((x) => BuzzerTischZuordnung.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "teilnehmer": List<dynamic>.from(teilnehmer.map((x) => x.toJson())),
        "kategorien": List<dynamic>.from(kategorien.map((x) => x.toJson())),
        if (buzzerTischZuordnung != null)
          "buzzer_tisch_zuordnung":
              List<dynamic>.from(buzzerTischZuordnung!.map((x) => x.toJson())),
      };
}
