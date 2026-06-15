package com.example.app_template

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val mapsConfigChannelName = "app_template/maps_platform_config"
    private val googleMapsPlaceholderPrefix = "YOUR_"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            mapsConfigChannelName,
        ).setMethodCallHandler { call, result ->
            if (call.method == "isGoogleMapsConfigured") {
                result.success(isGoogleMapsConfigured())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun isGoogleMapsConfigured(): Boolean {
        val applicationInfo = packageManager.getApplicationInfo(
            packageName,
            android.content.pm.PackageManager.GET_META_DATA,
        )
        val apiKey = applicationInfo.metaData?.getString("com.google.android.geo.API_KEY")
            ?.trim()
            ?.uppercase()
            .orEmpty()

        return apiKey.isNotEmpty() && !apiKey.startsWith(googleMapsPlaceholderPrefix)
    }
}
