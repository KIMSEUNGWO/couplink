import 'package:hive/hive.dart';

part 'event_queue_entity.g.dart';

@HiveType(typeId: 106)
enum QueueOperation {
  @HiveField(0)
  CREATE,
  @HiveField(1)
  UPDATE,
  @HiveField(2)
  DELETE
}

@HiveType(typeId: 107)
enum QueueStatus {

  @HiveField(0)
  PENDING,
  @HiveField(1)
  PROCESSING,
  @HiveField(2)
  FAILED
}