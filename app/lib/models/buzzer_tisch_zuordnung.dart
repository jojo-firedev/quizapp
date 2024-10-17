import 'dart:convert';

class BuzzerTischZuordnung {
  int tisch;
  String mac;

  BuzzerTischZuordnung({
    required this.tisch,
    required this.mac,
  });

  factory BuzzerTischZuordnung.fromRawJson(String str) =>
      BuzzerTischZuordnung.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BuzzerTischZuordnung.fromJson(Map<String, dynamic> json) =>
      BuzzerTischZuordnung(
        tisch: json["tisch"],
        mac: json["mac"],
      );

  Map<String, dynamic> toJson() => {
        "tisch": tisch,
        "mac": mac,
      };
}
