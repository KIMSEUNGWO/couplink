
import 'package:couplink_app/entity/event_queue_entity.dart';
import 'package:hive/hive.dart';

part 'EventQueueItem.g.dart';

@HiveType(typeId: 2)
class EventQueueItem {

  @HiveField(0)
  final String queueId;        // 큐 항목 고유 ID
  @HiveField(1)
  final String eventId;           // 관련 일정 ID
  @HiveField(2)
  final QueueOperation operationType; // 작업 유형 (CREATE/UPDATE/DELETE)
  @HiveField(3)
  final Map<String, dynamic> eventData; // 일정 데이터 JSON
  @HiveField(4)
  final DateTime timestamp;    // 작업 발생 시간
  @HiveField(5)
  int retryCount = 0;          // 재시도 횟수
  @HiveField(6)
  QueueStatus status = QueueStatus.PENDING; // 상태

  EventQueueItem({
    required this.queueId,
    required this.eventId,
    required this.operationType,
    required this.eventData,
    required this.timestamp,
    this.retryCount = 0,
    this.status = QueueStatus.PENDING,
  });

  // Hive를 위한 fromJson 메서드
  factory EventQueueItem.fromJson(Map<String, dynamic> json) {
    return EventQueueItem(
      queueId: json['queueId'],
      eventId: json['eventId'],
      operationType: QueueOperation.values.firstWhere(
              (e) => e.toString() == 'QueueOperation.${json['operationType']}'),
      eventData: json['eventData'],
      timestamp: DateTime.parse(json['timestamp']),
      retryCount: json['retryCount'] ?? 0,
      status: QueueStatus.values.firstWhere(
              (e) => e.toString() == 'QueueStatus.${json['status']}'),
    );
  }

  // Hive를 위한 toJson 메서드
  Map<String, dynamic> toJson() {
    return {
      'queueId': queueId,
      'eventId': eventId,
      'operationType': operationType.toString().split('.').last,
      'eventData': eventData,
      'timestamp': timestamp.toIso8601String(),
      'retryCount': retryCount,
      'status': status.toString().split('.').last,
    };
  }

  // 재시도 횟수 증가 메서드
  EventQueueItem incrementRetry() {
    return EventQueueItem(
      queueId: queueId,
      eventId: eventId,
      operationType: operationType,
      eventData: eventData,
      timestamp: timestamp,
      retryCount: retryCount + 1,
      status: status,
    );
  }

  // 상태 업데이트 메서드
  EventQueueItem updateStatus(QueueStatus newStatus) {
    return EventQueueItem(
      queueId: queueId,
      eventId: eventId,
      operationType: operationType,
      eventData: eventData,
      timestamp: timestamp,
      retryCount: retryCount,
      status: newStatus,
    );
  }
}