
import 'dart:io';

import 'package:couplink_app/api/EventService.dart';
import 'package:couplink_app/api/UserService.dart';
import 'package:couplink_app/entity/Event.dart';
import 'package:couplink_app/entity/EventQueueItem.dart';
import 'package:couplink_app/entity/event_entity.dart';
import 'package:couplink_app/entity/event_queue_entity.dart';
import 'package:couplink_app/firebase_options.dart';
import 'package:couplink_app/api/ApiService.dart';
import 'package:couplink_app/notifier/user_notifier.dart';
import 'package:couplink_app/service/EventCalendarService.dart';
import 'package:couplink_app/service/EventQueueService.dart';
import 'package:couplink_app/service/NetworkService.dart';
import 'package:couplink_app/service/SyncService.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class InitManager {

  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _fcmInit();
    await _defaultInit();
    await _hiveInit();
  }

  _defaultInit() async {
    await initializeDateFormatting('ko_KR', null);
    // 가로모드 방지
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    await EasyLocalization.ensureInitialized();
  }


  _hiveInit() async {
    // Hive 초기화 전에 기존 데이터 삭제
    // await _clearHiveData();
    await Hive.initFlutter(); // NoSQL init

    Hive.registerAdapter(EventAdapter());
    Hive.registerAdapter(EventQueueItemAdapter());

    Hive.registerAdapter(AddEventTypeAdapter());
    Hive.registerAdapter(EventVisibilityAdapter());
    Hive.registerAdapter(EventTargetAdapter());
    Hive.registerAdapter(EventColorAdapter());
    Hive.registerAdapter(EventSyncAdapter());

    Hive.registerAdapter(QueueOperationAdapter());
    Hive.registerAdapter(QueueStatusAdapter());

    await Hive.openBox<Event>('events');
    await Hive.openBox<EventQueueItem>('event_queue');
  }
  _clearHiveData() async {
    // 모든 박스 닫기
    await Hive.close();

    // Hive 디렉토리 가져오기
    final directory = await path_provider.getApplicationDocumentsDirectory();
    final path = directory.path;

    // Hive 파일들 삭제
    Directory(path).listSync().forEach((file) {
      if (file.path.contains('.hive')) {
        file.deleteSync();
      }
    });
  }

  _fcmInit() async {
    print('_fcmInit');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    // 적절한 위치에 선언
    final req = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (req.authorizationStatus == AuthorizationStatus.authorized && fcmToken != null) {
      print('FCM Token: $fcmToken');
    } else {
      print('FCM Token: null');
    }

  }

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }


  serviceInit() async {
    final apiService = ApiService();
    final eventService = EventService().init(apiService: apiService);
    final userService = UserService().init(apiService: apiService);

    await EventQueueService().init(
        Hive.box<EventQueueItem>('event_queue'),
        Hive.box<Event>('events')
    );
    await EventCalendarService().init(
        Hive.box<Event>('events')
    );
    await SyncService().init(
        queueService: EventQueueService(),
        eventService: EventService(),
        networkService: NetworkService(),
        eventCalendarService: EventCalendarService()
    );

    // 푸시 알림 서비스 초기화
    // await PushNotificationService().init(syncService: SyncService());

    // 백그라운드 작업 초기화
    // initBackgroundSync();

  }

  /// RiverPod 상태 관리 초기화
  stateInit(WidgetRef ref) async {
    await ref.read(userProvider.notifier).init();
  }

}