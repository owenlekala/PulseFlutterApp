import Flutter
import Foundation
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let mapsConfigChannelName = "app_template/maps_platform_config"
  private let googleMapsPlaceholderPrefix = "YOUR_"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let controller = window?.rootViewController as? FlutterViewController {
      let mapsConfigChannel = FlutterMethodChannel(
        name: mapsConfigChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      mapsConfigChannel.setMethodCallHandler { [weak self] call, result in
        guard call.method == "isGoogleMapsConfigured" else {
          result(FlutterMethodNotImplemented)
          return
        }

        result(self?.isGoogleMapsConfigured() ?? false)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func isGoogleMapsConfigured() -> Bool {
    guard
      let apiKey = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String
    else {
      return false
    }

    let normalizedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    return !normalizedKey.isEmpty && !normalizedKey.hasPrefix(googleMapsPlaceholderPrefix)
  }
}
