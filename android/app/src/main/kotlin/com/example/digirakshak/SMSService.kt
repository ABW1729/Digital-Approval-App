package com.example.digirakshak

import android.service.carrier.CarrierMessagingService
import android.service.carrier.CarrierMessagingService.ResultCallback
import android.util.Log
import android.service.carrier.MessagePdu

class SMSService : CarrierMessagingService() {
    companion object {
        const val RESULT_HANDLED = 0
    }

    override fun onReceiveTextSms(
        pdu: MessagePdu,
        format: String,
        destPort: Int,
        subscriberId: Int,
        callback: CarrierMessagingService.ResultCallback<Int>
    )  {
        Log.d("SMSService", "SMS received")
        callback.onReceiveResult(RESULT_HANDLED)
    }
}
