import 'dart:convert';

class BuzzerAssignment {
  int tisch;
  String mac;

  BuzzerAssignment({
    required this.tisch,
    required this.mac,
  });

  factory BuzzerAssignment.fromRawJson(String str) =>
      BuzzerAssignment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BuzzerAssignment.fromJson(Map<String, dynamic> json) =>
      BuzzerAssignment(
        tisch: json["tisch"],
        mac: json["mac"],
      );

  Map<String, dynamic> toJson() => {
        "tisch": tisch,
        "mac": mac,
      };
}
