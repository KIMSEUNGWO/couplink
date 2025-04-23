import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkService {
  // 싱글톤 패턴 구현
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final Connectivity _connectivity = Connectivity();

  // 현재 네트워크 연결 상태 확인
  Future<bool> isOnline() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult[0] != ConnectivityResult.none;
    } catch (e) {
      debugPrint('네트워크 상태 확인 오류: $e');
      return false;
    }
  }

  // 네트워크 연결 상태 변화 스트림 제공
  Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }

  // 네트워크 변화 감지 및 콜백 실행
  void listenNetworkChanges(Function(bool isOnline) callback) {
    connectionStream.listen((isOnline) {
      callback(isOnline);
    });
  }
}