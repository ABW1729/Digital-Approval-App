package com.example.digirakshak

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.telephony.SmsMessage
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache


class SMSReciever : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == "android.provider.Telephony.SMS_RECEIVED") {
            val bundle: Bundle? = intent.extras
            val pdus = bundle?.get("pdus") as? Array<*>

            pdus?.forEach { pdu ->
                val sms = SmsMessage.createFromPdu(pdu as ByteArray)
                val sender = sms.originatingAddress ?: ""
                val body = sms.messageBody

                Log.d("SMSReceiver", "📩 SMS from $sender: $body")

                // Push to Flutter
                val flutterEngine = FlutterEngineCache.getInstance().get("main_engine")
                flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                    MethodChannel(messenger, "digirakshak/sms").invokeMethod(
                        "newSms",
                        mapOf("sender" to sender, "body" to body)
                    )
                }
            }
        }
    }
}


