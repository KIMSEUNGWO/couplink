//
// import 'package:couplink_app/entity/Event.dart';
// import 'package:couplink_app/entity/EventQueueItem.dart';
// import 'package:couplink_app/service/EventQueueService.dart';
// import 'package:couplink_app/service/NetworkService.dart';
// import 'package:couplink_app/service/SyncService.dart';
// import 'package:couplink_app/server/ApiService.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:workmanager/workmanager.dart';
//
// // 백그라운드 콜백 함수 - 별도 파일(예: sync_worker.dart)에 정의
// @pragma('vm:entry-point') // 중요: 이 함수가 트리 쉐이킹에 의해 제거되지 않도록 함
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     try {
//       // Hive 초기화
//       await Hive.initFlutter();
//       Hive.registerAdapter(EventAdapter());
//       Hive.registerAdapter(EventQueueItemAdapter());
//
//       final eventBox = await Hive.openBox<Event>('events');
//       final queueBox = await Hive.openBox<EventQueueItem>('event_queue');
//
//       // 서비스 초기화
//       final networkService = NetworkService();
//       final apiService = ApiService();
//       final queueService = EventQueueService(queueBox: queueBox, eventBox: eventBox);
//       final syncService = SyncService(
//         queueService: queueService,
//         apiService: apiService,
//         networkService: networkService,
//       );
//
//       // 온라인 상태 확인
//       if (await networkService.isOnline()) {
//         // 동기화 실행
//         await syncService.startSync();
//         print('백그라운드 동기화 완료');
//       } else {
//         print('오프라인 상태: 백그라운드 동기화 건너뜁니다');
//       }
//
//       return true;
//     } catch (e) {
//       print('백그라운드 동기화 오류: $e');
//       return false;
//     }
//   });
// }
//
// // 메인 앱에서 WorkManager 초기화 및 작업 등록
// void initBackgroundSync() {
//   Workmanager().initialize(
//     callbackDispatcher,
//     isInDebugMode: true,
//   );
//
//   // 주기적 동기화 작업 등록
//   Workmanager().registerPeriodicTask(
//     'event-sync',
//     'eventSync',
//     frequency: const Duration(minutes: 15),
//     constraints: Constraints(
//       networkType: NetworkType.connected,
//     ),
//     existingWorkPolicy: ExistingWorkPolicy.replace,
//   );
//
//   // 앱 시작 시 한 번 실행되는 작업 (초기 동기화)
//   Workmanager().registerOneOffTask(
//     'initial-sync',
//     'initialSync',
//     constraints: Constraints(
//       networkType: NetworkType.connected,
//     ),
//     existingWorkPolicy: ExistingWorkPolicy.replace,
//   );
// }