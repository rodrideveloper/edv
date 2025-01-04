import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();

  factory ConnectivityService() {
    return _instance;
  }

  bool get hasConnection => _subject.valueOrNull ?? false;

  final BehaviorSubject<bool> _subject = BehaviorSubject<bool>();

  Stream<bool> get onConnectivityChanged => _subject.stream;

  ConnectivityService._internal() {
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final hasConnection = !result.contains(ConnectivityResult.none);
    _subject.add(hasConnection);
  }

  void dispose() {
    _subject.close();
  }
}
