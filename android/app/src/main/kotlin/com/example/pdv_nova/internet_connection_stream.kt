package com.example.pdv_mobile

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.NetworkInfo
import io.flutter.plugin.common.EventChannel

class InternetConnectionStreamHandler(private val context: Context) : EventChannel.StreamHandler {
    private val connectivityManager: ConnectivityManager =
        context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

    private val internetConnectionReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val networkInfo: NetworkInfo? = connectivityManager.activeNetworkInfo
            val isConnected: Boolean = networkInfo?.isConnectedOrConnecting == true

            // Check if there is an available network connection
            if (networkInfo != null && networkInfo.isConnected) {
                eventSink?.success(true)
            } else {
                eventSink?.success(false)
            }
        }
    }

    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        this.eventSink = eventSink
        val filter = IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION)
        context.registerReceiver(internetConnectionReceiver, filter)
    }

    override fun onCancel(arguments: Any?) {
        context.unregisterReceiver(internetConnectionReceiver)
        eventSink = null
    }
}