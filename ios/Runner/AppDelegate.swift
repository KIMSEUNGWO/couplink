import Flutter
import UIKit
import workmanager
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//     // Workmanager 코드 추가
//     WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "task-identifier")
//
//     // iOS 13 이상에서 주기적 작업 등록 (20분마다 실행)
//     if #available(iOS 13.0, *) {
//       WorkmanagerPlugin.registerPeriodicTask(
//         withIdentifier: "event-sync",
//         frequency: NSNumber(value: 15 * 60) // 15분마다 (초 단위로 입력)
//       )
//     }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
