import 'package:flutter/material.dart';

final class CalendarEventModel {
  CalendarEventModel({
    required this.id,
    required this.name,
    required this.begin,
    required this.end,
    this.eventColor = Colors.green,
  });

  String id;
  String name;
  DateTime begin;
  DateTime end;
  Color eventColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalendarEventModel && other.id == id;
  }
  @override
  int get hashCode => id.hashCode;
}
