import 'package:couplink_app/api/EventService.dart';
import 'package:couplink_app/entity/Event.dart';
import 'package:couplink_app/entity/EventQueueItem.dart';
import 'package:couplink_app/service/EventCalendarService.dart';
import 'package:couplink_app/service/EventQueueService.dart';
import 'package:couplink_app/entity/event_entity.dart';
import 'package:couplink_app/entity/event_queue_entity.dart';
import 'package:couplink_app/service/NetworkService.dart';
import 'package:flutter/material.dart';

class SyncService {
  // 싱글톤 패턴 구현
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;

  late EventCalendarService eventCalendarService;
  late EventQueueService queueService;
  late EventService eventService;
  late NetworkService networkService;

  SyncService._internal();

  // 초기화 메서드
  Future<void> init({
    required EventQueueService queueService,
    required EventService eventService,
    required NetworkService networkService,
    required EventCalendarService eventCalendarService,
  }) async {
    this.queueService = queueService;
    this.eventService = eventService;
    this.networkService = networkService;
    this.eventCalendarService = eventCalendarService;
  }

  // 1. 동기화 프로세스 시작
  Future<void> startSync() async {
    // 네트워크 연결 확인
    if (!await networkService.isOnline()) {
      debugPrint('오프라인 상태: 동기화를 건너뜁니다.');
      return;
    }

    // 처리해야 할 작업 가져오기 - PENDING 상태 및 재시도 가능한 FAILED 상태
    final pendingOperations = queueService.getPendingOperations();
    final failedOperations = queueService.getRetryableFailedOperations();

    // 모든 처리할 작업 병합
    final operationsToProcess = [...pendingOperations, ...failedOperations];

    if (operationsToProcess.isEmpty) {
      debugPrint('동기화할 작업이 없습니다.');
      return;
    }

    debugPrint('${operationsToProcess.length}개의 작업 동기화 시작 (대기: ${pendingOperations.length}, 실패 재시도: ${failedOperations.length})');

    // 배치 처리를 위한 그룹화 (예: CREATE와 UPDATE는 함께 처리 가능)
    final createAndUpdateOps = pendingOperations
        .where((op) => op.operationType == QueueOperation.CREATE ||
        op.operationType == QueueOperation.UPDATE)
        .toList();

    final deleteOps = pendingOperations
        .where((op) => op.operationType == QueueOperation.DELETE)
        .toList();

    // 생성 및 업데이트 작업 처리
    if (createAndUpdateOps.isNotEmpty) {
      await _processCreateAndUpdateOperations(createAndUpdateOps);
    }

    // 삭제 작업 처리
    if (deleteOps.isNotEmpty) {
      await _processDeleteOperations(deleteOps);
    }

    debugPrint('동기화 완료');
  }

  // 2. 생성 및 업데이트 작업 처리
  Future<void> _processCreateAndUpdateOperations(List<EventQueueItem> operations) async {
    try {
      // 배치 요청 준비
      final batchData = operations.map((op) => {
        'operation': op.operationType.toString().split('.').last,
        'event': op.eventData,
      }).toList();

      // 모든 작업을 처리 중으로 표시
      for (var op in operations) {
        await queueService.updateOperationStatus(op.queueId, QueueStatus.PROCESSING);
      }

      // 배치 API 호출
      final response = await eventService.postEventsBatch(batchData);

      // 응답 처리
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;

        // 각 작업의 결과 확인
        for (int i = 0; i < operations.length; i++) {
          final op = operations[i];
          final result = results[i];

          if (result['success'] == true) {
            // 성공한 작업 제거
            await queueService.removeOperation(op.queueId);

            // 관련 이벤트의 syncStatus 업데이트
            final event = await queueService.eventBox.get(op.eventId);
            if (event != null) {
              event.syncStatus = EventSync.SYNCED;
              event.lastModified = DateTime.now();
              await queueService.eventBox.put(op.eventId, event);
            }
          } else {
            // 실패한 작업 재시도 카운트 증가
            await queueService.incrementRetryCount(op.queueId);
            await queueService.updateOperationStatus(op.queueId, QueueStatus.FAILED);
          }
        }
      } else {
        // 전체 요청 실패
        for (var op in operations) {
          await queueService.incrementRetryCount(op.queueId);
          await queueService.updateOperationStatus(op.queueId, QueueStatus.FAILED);
        }
      }
    } catch (e) {
      debugPrint('배치 동기화 오류: $e');
      for (var op in operations) {
        await queueService.incrementRetryCount(op.queueId);
        await queueService.updateOperationStatus(op.queueId, QueueStatus.FAILED);
      }
    }
  }

  // 3. 삭제 작업 처리
  Future<void> _processDeleteOperations(List<EventQueueItem> operations) async {
    try {
      // 배치 삭제 요청 준비
      final eventIds = operations.map((op) => op.eventId).toList();

      // 모든 작업을 처리 중으로 표시
      for (var op in operations) {
        await queueService.updateOperationStatus(op.queueId, QueueStatus.PROCESSING);
      }

      // 배치 삭제 API 호출
      final response = await eventService.deleteEventsBatch(eventIds);

      // 응답 처리
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;

        // 각 작업의 결과 확인
        for (int i = 0; i < operations.length; i++) {
          final op = operations[i];
          final result = results[i];

          if (result['success'] == true) {
            // 성공한 작업 제거
            await queueService.removeOperation(op.queueId);

            // 로컬 DB에서 이벤트 완전 삭제 (선택적)
            // await queueService.eventBox.delete(op.eventId);
          } else {
            // 실패한 작업 재시도 카운트 증가
            await queueService.incrementRetryCount(op.queueId);
            await queueService.updateOperationStatus(op.queueId, QueueStatus.FAILED);
          }
        }
      } else {
        // 전체 요청 실패
        for (var op in operations) {
          await queueService.incrementRetryCount(op.queueId);
          await queueService.updateOperationStatus(op.queueId, QueueStatus.FAILED);
        }
      }
    } catch (e) {
      debugPrint('삭제 동기화 오류: $e');
      for (var op in operations) {
        await queueService.incrementRetryCount(op.queueId);
        await queueService.updateOperationStatus(op.queueId, QueueStatus.FAILED);
      }
    }
  }

  // 4. 이벤트 생성 및 큐 추가 (일정 생성 시 호출)
  Future<void> createEvent(Event event) async {
    // 로컬 DB에 저장
    await eventCalendarService.put(event.eventId, event);

    // 이벤트 큐에 작업 추가
    await queueService.addCreateOperation(event);

    // 온라인 상태면 즉시 동기화 시도
    if (await networkService.isOnline()) {
      startSync();
    }
  }

  // 5. 이벤트 수정 및 큐 추가 (일정 수정 시 호출)
  Future<void> updateEvent(Event event) async {
    // 수정 시간 업데이트
    event.lastModified = DateTime.now();
    event.syncStatus = EventSync.PENDING;

    // 로컬 DB에 저장
    await eventCalendarService.put(event.eventId, event);

    // 이벤트 큐에 작업 추가
    await queueService.addUpdateOperation(event);

    // 온라인 상태면 즉시 동기화 시도
    if (await networkService.isOnline()) {
      startSync();
    }
  }

  // 6. 이벤트 삭제 및 큐 추가 (일정 삭제 시 호출)
  Future<void> deleteEvent(Event event) async {
    // 삭제 표시
    event.isDeleted = true;
    event.syncStatus = EventSync.PENDING;
    event.lastModified = DateTime.now();

    // 로컬 DB에 저장 (나중에 서버와 동기화 후 완전 삭제)
    await eventCalendarService.put(event.eventId, event);

    // 이벤트 큐에 작업 추가
    await queueService.addDeleteOperation(event);

    // 온라인 상태면 즉시 동기화 시도
    if (await networkService.isOnline()) {
      startSync();
    }
  }
}