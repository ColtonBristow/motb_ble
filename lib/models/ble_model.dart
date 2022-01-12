import 'dart:convert';

class BLE {
  final String name;
  final String uuid;
  final int major;
  final int minor;

  final int rsi;
  final double distance;
  final String proximity;

  BLE({
    required this.minor,
    required this.name,
    required this.uuid,
    required this.major,
    required this.rsi,
    required this.distance,
    required this.proximity,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uuid': uuid,
      'major': major,
      'minor': minor,
      'rsi': rsi,
      'distance': distance,
      'proximity': proximity,
    };
  }

  factory BLE.fromMap(Map<String, dynamic> map) {
    return BLE(
      name: map['name'] ?? '',
      uuid: map['uuid'] ?? '',
      major: int.tryParse(map['major']) ?? 0,
      minor: int.tryParse(map['minor']) ?? 0,
      rsi: int.tryParse(map['rsi'] ?? '0') ?? 0,
      distance: double.tryParse(map['distance']) ?? 0.0,
      proximity: map['proximity'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BLE.fromJson(String source) => BLE.fromMap(json.decode(source));
}
