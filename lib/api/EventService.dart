
import 'package:couplink_app/api/ApiService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EventService {

  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;

  late final ApiService _apiService;

  EventService._internal();

  init({
    required ApiService apiService,
  }) {
    _apiService = apiService;
  }

  // 이벤트 동기화 관련 API 호출
  // 1. 이벤트 배치 생성/수정
  Future<Response> postEventsBatch(List<Map<String, dynamic>> batchData) async {
    try {
      return await _apiService.dio.post('/events/batch', data: {'events': batchData});
    } catch (e) {
      debugPrint('배치 이벤트 전송 오류: $e');
      rethrow;
    }
  }

  // 2. 이벤트 배치 삭제
  Future<Response> deleteEventsBatch(List<String> eventIds) async {
    try {
      return await _apiService.dio.delete('/events/batch', data: {'eventIds': eventIds});
    } catch (e) {
      debugPrint('배치 이벤트 삭제 오류: $e');
      rethrow;
    }
  }

  // 3. 마지막 동기화 이후 변경된 이벤트 조회
  Future<Response> getSyncEvents(String lastSyncTimestamp, String deviceId) async {
    try {
      return await _apiService.dio.get('/events', queryParameters: {
        'lastSyncTimestamp': lastSyncTimestamp,
        'deviceId': deviceId,
      });
    } catch (e) {
      debugPrint('이벤트 동기화 조회 오류: $e');
      rethrow;
    }
  }

  // 4. 단일 이벤트 상세 조회
  Future<Response> getEvent(int eventId) async {
    try {
      return await _apiService.dio.get('/events/$eventId');
    } catch (e) {
      debugPrint('이벤트 조회 오류: $e');
      rethrow;
    }
  }

}