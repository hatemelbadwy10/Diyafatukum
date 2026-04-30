package deals.deals

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.bonus.app/config"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "setGoogleMapsApiKey" -> result.success(null)
                else -> result.notImplemented()
            }
        }
    }
}
