package com.example.digirakshak

import android.content.Intent
import android.os.Bundle
import android.provider.Telephony
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngineCache
import android.util.Log // <-- make sure this import is at the top

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "digirakshak/sms"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Optionally still prompt on first boot
        if (Telephony.Sms.getDefaultSmsPackage(this) != packageName) {
            val intent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
            intent.putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME, packageName)
            startActivity(intent)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        FlutterEngineCache.getInstance().put("main_engine", flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "requestDefaultSms" -> {
                    Log.d("MethodChannel", "🔔 requestDefaultSms called from Flutter")
                    val intent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
                    intent.putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME, packageName)
                    startActivity(intent)
                    result.success(true)
                }
                "isDefaultSms" -> {
                    val isDefault = Telephony.Sms.getDefaultSmsPackage(this) == packageName
                    Log.d("SMS_CHECK", "Is default SMS app: $isDefault")

                    if (!isDefault) {
                        val intent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
                        intent.putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME, packageName)
                        startActivity(intent)
                    } else {
                        Log.d("SMS_CHECK", "Already default SMS app")
                    }
                }
                else -> {
                    Log.d("MethodChannel", "❌ Unknown method: ${call.method}")
                    result.notImplemented()
                }
            }
        }

    }
}
