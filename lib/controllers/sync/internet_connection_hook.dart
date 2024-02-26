import 'dart:async';
import 'package:flutter/services.dart';

class InternetConnectionHook {
  final EventChannel _eventChannel = const EventChannel('internet_connection');
  StreamSubscription<bool>? _subscription;
  StreamController<bool> _streamController = StreamController<bool>();

  Stream<bool> get isConnected => _streamController.stream;

  void startListening() {
    _subscription = _eventChannel.receiveBroadcastStream().cast<bool>().listen((isConnected) {
      _streamController.add(isConnected);
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _streamController.close();
  }
}