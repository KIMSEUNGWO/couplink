// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class PushNotificationService {
//   final SyncService syncService;
//
//   PushNotificationService({required this.syncService});
//
//   late FirebaseMessaging _messaging;
//   late FlutterLocalNotificationsPlugin _notificationsPlugin;
//
//   Future<void> init() async {
//     // FCM 초기화
//     _messaging = FirebaseMessaging.instance;
//
//     // 알림 권한 요청
//     await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // FCM 토큰 가져오기 및 서버 등록
//     String? token = await _messaging.getToken();
//     if (token != null) {
//       await _registerFcmToken(token);
//     }
//
//     // 토큰 갱신 시 처리
//     _messaging.onTokenRefresh.listen(_registerFcmToken);
//
//     // 로컬 알림 초기화
//     _notificationsPlugin = FlutterLocalNotificationsPlugin();
//     const initializationSettings = InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//       iOS: DarwinInitializationSettings(),
//     );
//     await _notificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onNotificationTap,
//     );
//
//     // 포그라운드 메시지 처리
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//
//     // 백그라운드/종료 상태에서 알림 탭 처리
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
//
//     // 앱이 종료된 상태에서 알림 탭으로 열린 경우 처리
//     await _checkInitialMessage();
//   }
//
//   // FCM 토큰 서버 등록
//   Future<void> _registerFcmToken(String token) async {
//     try {
//       // 기기 고유 ID 가져오기 (별도 구현 필요)
//       final deviceId = await getDeviceId();
//
//       // API 서비스를 통해 서버에 등록
//       await ApiService().registerDevice(deviceId, token);
//
//       print('FCM 토큰 등록 성공: $token');
//     } catch (e) {
//       print('FCM 토큰 등록 오류: $e');
//     }
//   }
//
//   // 포그라운드 메시지 처리
//   Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     print('포그라운드 메시지 수신: ${message.data}');
//
//     // 알림 표시
//     _showNotification(message);
//
//     // 메시지 데이터에 따라 동기화 처리
//     await _processSyncMessage(message);
//   }
//
//   // 알림 탭 처리
//   Future<void> _handleNotificationTap(RemoteMessage message) async {
//     print('알림 탭: ${message.data}');
//
//     // 특정 화면으로 이동 (예: 일정 상세 화면)
//     _navigateToScreen(message);
//
//     // 동기화 처리
//     await _processSyncMessage(message);
//   }
//
//   // 앱이 종료된 상태에서 알림 탭으로 열린 경우 처리
//   Future<void> _checkInitialMessage() async {
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//
//     if (initialMessage != null) {
//       _handleNotificationTap(initialMessage);
//     }
//   }
//
//   // 로컬 알림 표시
//   Future<void> _showNotification(RemoteMessage message) async {
//     final androidDetails = AndroidNotificationDetails(
//       'event_channel',
//       'Event Notifications',
//       channelDescription: 'Notifications for calendar events',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//
//     final iOSDetails = const DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     final notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iOSDetails,
//     );
//
//     // 알림 ID 생성 (메시지 데이터에서 가져오거나 임의 생성)
//     final id = message.data['eventId']?.hashCode ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
//
//     await _notificationsPlugin.show(
//       id,
//       message.notification?.title ?? '새 알림',
//       message.notification?.body ?? '',
//       notificationDetails,
//       payload: message.data.toString(),
//     );
//   }
//
//   // 알림 탭 콜백
//   void _onNotificationTap(NotificationResponse response) {
//     // 페이로드 파싱
//     if (response.payload != null) {
//       try {
//         // 여기서는 간단한 예시만 표현
//         // 실제로는 JSON 파싱 등을 통해 구조화된 데이터 처리 필요
//         print('로컬 알림 탭: ${response.payload}');
//
//         // 필요한 화면으로 이동
//       } catch (e) {
//         print('알림 페이로드 파싱 오류: $e');
//       }
//     }
//   }
//
//   // 특정 화면으로 이동
//   void _navigateToScreen(RemoteMessage message) {
//     // 메시지 데이터에 따라 다른 화면으로 이동
//     if (message.data.containsKey('eventId')) {
//       final eventId = int.tryParse(message.data['eventId']);
//       if (eventId != null) {
//         // GlobalNavigator.pushNamed('/event/$eventId');
//         print('일정 화면으로 이동: $eventId');
//       }
//     } else if (message.data['type'] == 'relation_update') {
//       // GlobalNavigator.pushNamed('/relation');
//       print('연인 관계 화면으로 이동');
//     }
//   }
//
//   // 동기화 관련 메시지 처리
//   Future<void> _processSyncMessage(RemoteMessage message) async {
//     // 메시지 유형 확인
//     final messageType = message.data['type'];
//
//     switch (messageType) {
//       case 'event_created':
//       case 'event_updated':
//       case 'event_deleted':
//       // 특정 이벤트 동기화
//         if (message.data.containsKey('eventId')) {
//           final eventId = int.tryParse(message.data['eventId']);
//           if (eventId != null) {
//             // 특정 이벤트만 동기화
//             await _syncSpecificEvent(eventId);
//           }
//         }
//         break;
//
//       case 'relation_connected':
//       // 연인 연결됨 - 전체 일정 동기화
//         await syncService.startSync();
//         break;
//
//       case 'relation_disconnected':
//       // 연인 연결 해제 - 공유 일정 처리
//         await _handleRelationDisconnect();
//         break;
//
//       case 'force_sync':
//       // 강제 전체 동기화
//         await syncService.startSync();
//         break;
//
//       default:
//       // 기본적으로 변경사항 있으면 동기화
//         if (message.data['requiresSync'] == 'true') {
//           await syncService.startSync();
//         }
//     }
//   }
//
//   // 특정 이벤트 동기화
//   Future<void> _syncSpecificEvent(int eventId) async {
//     try {
//       // API에서 최신 이벤트 데이터 가져오기
//       final response = await ApiService().getEvent(eventId);
//
//       if (response.statusCode == 200) {
//         final eventData = response.data;
//
//         // Hive에서 기존 이벤트 조회
//         final eventBox = await Hive.openBox<Event>('events');
//         final existingEvent = eventBox.get(eventId);
//
//         if (existingEvent == null) {
//           // 로컬에 없는 새 이벤트면 추가
//           final newEvent = Event.fromJson(eventData);
//           newEvent.syncStatus = EventSync.SYNCED;
//           await eventBox.put(eventId, newEvent);
//         } else if (eventData['lastModified'] != null) {
//           // 서버 버전이 더 최신인지 확인
//           final serverLastModified = DateTime.parse(eventData['lastModified']);
//           final localLastModified = existingEvent.lastModified ?? existingEvent.createAt;
//
//           if (serverLastModified.isAfter(localLastModified)) {
//             // 서버 버전이 더 최신이면 업데이트
//             final updatedEvent = Event.fromJson(eventData);
//             updatedEvent.syncStatus = EventSync.SYNCED;
//             await eventBox.put(eventId, updatedEvent);
//           } else if (existingEvent.syncStatus == EventSync.PENDING) {
//             // 로컬 변경사항 우선 (나중에 동기화 시 해결)
//             print('로컬 변경사항과 서버 변경사항 충돌: $eventId');
//           }
//         }
//       }
//     } catch (e) {
//       print('특정 이벤트 동기화 오류: $e');
//     }
//   }
//
//   // 연인 관계 해제 처리
//   Future<void> _handleRelationDisconnect() async {
//     try {
//       // Hive에서 이벤트 조회
//       final eventBox = await Hive.openBox<Event>('events');
//
//       // 공유 일정 필터링
//       final sharedEvents = eventBox.values.where(
//               (event) => event.visibility == EventVisibility.SHARED
//       ).toList();
//
//       // 내가 생성한 일정은 개인 일정으로 변경, 상대방 일정은 삭제
//       for (var event in sharedEvents) {
//         if (event.userId == getCurrentUserId()) {
//           // 내 일정은 PRIVATE으로 변경
//           event.visibility = EventVisibility.PRIVATE;
//           event.syncStatus = EventSync.PENDING;
//           event.lastModified = DateTime.now();
//           await eventBox.put(event.eventId, event);
//
//           // 변경 사항 큐에 추가
//           await syncService.updateEvent(event);
//         } else {
//           // 상대방 일정은 삭제
//           await eventBox.delete(event.eventId);
//         }
//       }
//
//       // 관계 정보 초기화 (별도 구현 필요)
//       // await clearRelationInfo();
//
//       print('연인 관계 해제 처리 완료');
//     } catch (e) {
//       print('연인 관계 해제 처리 오류: $e');
//     }
//   }
//
//   // 현재 사용자 ID 가져오기 (별도 구현 필요)
//   int getCurrentUserId() {
//     // SharedPreferences 등에서 가져오기
//     return 0; // 임시 값
//   }
//
//   // 기기 ID 가져오기 (별도 구현 필요)
//   Future<String> getDeviceId() async {
//     // device_info_plus 등을 사용하여 구현
//     return 'device-${DateTime.now().millisecondsSinceEpoch}'; // 임시 값
//   }
// }