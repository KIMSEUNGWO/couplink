

import 'package:couplink_app/entity/event_entity.dart';
import 'package:hive/hive.dart';

part 'Event.g.dart';

@HiveType(typeId: 1)
class Event extends HiveObject {

  @HiveField(0)
  final String eventId;
  @HiveField(1)
  final int userId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final EventTarget target;

  @HiveField(4)
  final DateTime startDate;
  @HiveField(5)
  final DateTime endDate;

  @HiveField(6)
  final EventVisibility visibility;
  @HiveField(7)
  final int color;

  @HiveField(8)
  final String? description;

  @HiveField(9)
  final DateTime createAt = DateTime.now();
  @HiveField(10)
  DateTime? lastModified = null;

  @HiveField(11)
  EventSync syncStatus = EventSync.PENDING;
  @HiveField(12)
  bool isDeleted = false;

  Event({required this.eventId, required this.userId, required this.title, required this.target, required this.startDate, required this.endDate, required this.visibility, required this.color, this.description});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event && other.eventId == eventId;
  }

  @override
  int get hashCode => eventId.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'userId' : userId,
      'title': title,
      'target': target.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'visibility': visibility.name,
      'color': color,
      'createAt' : createAt.toIso8601String(),
      'lastModified' : lastModified,
      'syncStatus' : syncStatus.name,
      'isDeleted' : isDeleted
    };
  }
}