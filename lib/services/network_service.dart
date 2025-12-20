import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Service to check network connectivity status
@lazySingleton
class NetworkService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get onConnectivityChanged => _connectivity.onConnectivityChanged;

  /// Check current connectivity status
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result);
  }

  /// Check if device has internet connection
  /// Returns true if connected via WiFi, Mobile, or Ethernet
  Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result);
  }

  /// Get current connectivity type
  Future<List<ConnectivityResult>> getConnectivityType() async {
    return await _connectivity.checkConnectivity();
  }

  /// Check if connected via WiFi
  Future<bool> get isWifiConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.wifi);
  }

  /// Check if connected via Mobile data
  Future<bool> get isMobileConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile);
  }

  /// Check if connected via Ethernet
  Future<bool> get isEthernetConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.ethernet);
  }

  /// Listen to connectivity changes
  /// [onConnectionChanged] callback when connectivity changes
  void listenConnectivity({
    required Function(bool isConnected) onConnectionChanged,
  }) {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      onConnectionChanged(_isConnected(result));
    });
  }

  /// Stop listening to connectivity changes
  void dispose() {
    _subscription?.cancel();
  }

  /// Helper method to check if connected
  bool _isConnected(List<ConnectivityResult> result) {
    return result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.ethernet);
  }
}
