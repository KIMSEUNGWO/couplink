import 'package:couplink_app/entity/Event.dart';
import 'package:couplink_app/entity/EventQueueItem.dart';
import 'package:couplink_app/entity/event_queue_entity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class EventQueueService {
  static final EventQueueService _instance = EventQueueService._internal();
  factory EventQueueService() => _instance;
  final maxRetryCount = 5; // 최대 재시도 횟수 설정

  late Box<EventQueueItem> queueBox;
  late Box<Event> eventBox;

  // 프라이빗 생성자
  EventQueueService._internal();

  // 초기화 메서드 (main.dart에서 Hive 초기화 후 호출)
  Future<void> init(Box<EventQueueItem> queueBox, Box<Event> eventBox) async {
    this.queueBox = queueBox;
    this.eventBox = eventBox;
  }
  // 1. 일정 생성 시 큐에 추가
  Future<void> addCreateOperation(Event event) async {
    final queueItem = EventQueueItem(
      queueId: const Uuid().v4(),
      eventId: event.eventId,
      operationType: QueueOperation.CREATE,
      eventData: event.toJson(),
      timestamp: DateTime.now(),
    );

    await queueBox.put(queueItem.queueId, queueItem);
    debugPrint('일정 생성 작업이 큐에 추가됨: ${event.title}');
  }

  // 2. 일정 업데이트 시 큐에 추가
  Future<void> addUpdateOperation(Event event) async {
    final queueItem = EventQueueItem(
      queueId: const Uuid().v4(),
      eventId: event.eventId,
      operationType: QueueOperation.UPDATE,
      eventData: event.toJson(),
      timestamp: DateTime.now(),
    );

    await queueBox.put(queueItem.queueId, queueItem);
    debugPrint('일정 업데이트 작업이 큐에 추가됨: ${event.title}');
  }

  // 3. 일정 삭제 시 큐에 추가
  Future<void> addDeleteOperation(Event event) async {
    final queueItem = EventQueueItem(
      queueId: const Uuid().v4(),
      eventId: event.eventId,
      operationType: QueueOperation.DELETE,
      eventData: {
        'eventId': event.eventId,
        'isDeleted': true
      }, // 삭제는 최소한의 정보만 필요
      timestamp: DateTime.now(),
    );

    await queueBox.put(queueItem.queueId, queueItem);
    debugPrint('일정 삭제 작업이 큐에 추가됨: ${event.title}');
  }

  // 4. 대기 중인 작업 목록 가져오기
  List<EventQueueItem> getPendingOperations() {
    return queueBox.values
        .where((item) => item.status == QueueStatus.PENDING)
        .toList();
  }
  // 실패했지만 재시도 가능한 작업 목록 가져오기 (최대 재시도 횟수에 도달하지 않은 항목)
  List<EventQueueItem> getRetryableFailedOperations() {

    return queueBox.values
        .where((item) =>
    item.status == QueueStatus.FAILED &&
        item.retryCount < maxRetryCount)
        .toList();
  }

  // 5. 작업 처리 상태 업데이트
  Future<void> updateOperationStatus(String queueId, QueueStatus status) async {
    final item = queueBox.get(queueId);
    if (item != null) {
      await queueBox.put(queueId, item.updateStatus(status));
    }
  }

  // 6. 작업 재시도 횟수 증가
  Future<void> incrementRetryCount(String queueId) async {
    final item = queueBox.get(queueId);
    if (item != null) {
      await queueBox.put(queueId, item.incrementRetry());
    }
  }

  // 7. 성공한 작업 제거
  Future<void> removeOperation(String queueId) async {
    await queueBox.delete(queueId);
  }
}