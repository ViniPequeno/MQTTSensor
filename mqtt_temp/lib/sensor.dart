import 'package:flutter/foundation.dart';

class Sensor {
  int temp;
  int umi;
  DateTime date;

  Sensor({required this.temp, required this.umi, required this.date});

  factory Sensor.fromJson(DateTime time, Map<String, dynamic> json) {
    return Sensor(
        date: time,
        temp: int.parse(json['temp'].toString()),
        umi: int.parse(json['umi'].toString()));
  }
}
