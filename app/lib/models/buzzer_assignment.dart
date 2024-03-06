class BuzzerAssignment {
  final int tisch;
  final String mac;

  BuzzerAssignment({
    required this.tisch,
    required this.mac,
  });

  @override
  String toString() {
    return 'BuzzerAssignment{tisch: $tisch, mac: $mac}';
  }

  Map<String, dynamic> toJson() {
    return {
      'tisch': tisch,
      'mac': mac,
    };
  }

  factory BuzzerAssignment.fromJson(Map<String, dynamic> json) {
    return BuzzerAssignment(tisch: json['tisch'], mac: json['mac']);
  }
}
