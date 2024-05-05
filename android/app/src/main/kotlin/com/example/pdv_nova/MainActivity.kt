package com.example.pdv_mobile

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val eventChannel = EventChannel(flutterEngine?.dartExecutor?.binaryMessenger, "internet_connection")
        val internetConnectionStreamHandler = InternetConnectionStreamHandler(this)
        eventChannel.setStreamHandler(internetConnectionStreamHandler)
    }
}