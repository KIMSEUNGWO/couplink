import 'package:couplink_app/InitManager.dart';
import 'package:couplink_app/app.dart';
import 'package:couplink_app/provider_init.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initManager = InitManager();
  await initManager.init();
  await initManager.serviceInit();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ko', 'KR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ko', 'KR'),
      child: const ProviderScope(child: MyApp())
  ));
}

_workManagerInit() async {
  print('_workManagerInit');
  // Workmanager 초기화
//   await Workmanager().initialize(callbackDispatcher);
//
// // Android에서만 주기적 작업 등록
//   if (Platform.isAndroid) {
//     await Workmanager().registerPeriodicTask(
//       'event-sync',
//       'eventSync',
//       frequency: const Duration(minutes: 15),
//       constraints: Constraints(
//         networkType: NetworkType.connected,
//       ),
//     );
//   } else if (Platform.isIOS) {
//     // iOS에서는 OneTimeTask만 지원됨
//     await Workmanager().registerOneOffTask(
//       'event-sync',
//       'eventSync',
//       constraints: Constraints(
//         networkType: NetworkType.connected,
//       ),
//     );
//   }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoupLink',
      theme: _themeData(),
      home: const ProviderInit(child: App()),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

ThemeData _themeData() {
  return ThemeData(
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: const Color(0xFFF7F7FB),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: Color(0xFFF7F7FB),
      titleTextStyle: TextStyle(
        color: Color(0xFF2A2E43),
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
    ),

    colorScheme: const ColorScheme.light(

      onPrimary: Color(0xFF7373C9), // 메인 컬러 1
      onSecondary: Color(0xFFFF9900), // 메인 컬러 2

      primary: Color(0xFF2A2E43), // 폰트 컬러 1
      secondary: Color(0xFF45495E), // 폰트 컬러 2
      tertiary: Color(0xFF777984), // 폰트 컬러 3

      error: Color(0xFFE85959),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 20,
        color: Color(0xFF2A2E43),
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      displayMedium: TextStyle(
        fontSize: 18,
        color: Color(0xFF2A2E43),
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      displaySmall: TextStyle(
        fontSize: 16,
        color: Color(0xFF45495E),
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        color: Color(0xFF45495E),
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      bodyMedium: TextStyle(
        fontSize: 12,
        color: Color(0xFF777984),
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        fontSize: 10,
        color: Color(0xFF777984),
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
    ),

  );
}