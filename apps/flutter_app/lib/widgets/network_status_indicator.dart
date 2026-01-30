import 'package:flutter/material.dart';

import '../di/injection.dart';
import '../services/network_service.dart';

/// Widget to show network connection status
class NetworkStatusIndicator extends StatefulWidget {
  final Widget child;
  final bool showOfflineMessage;

  const NetworkStatusIndicator({
    super.key,
    required this.child,
    this.showOfflineMessage = true,
  });

  @override
  State<NetworkStatusIndicator> createState() => _NetworkStatusIndicatorState();
}

class _NetworkStatusIndicatorState extends State<NetworkStatusIndicator> {
  final _networkService = getIt<NetworkService>();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _listenConnection();
  }

  Future<void> _checkConnection() async {
    final isConnected = await _networkService.hasConnection();
    if (mounted) {
      setState(() {
        _isConnected = isConnected;
      });
    }
  }

  void _listenConnection() {
    _networkService.listenConnectivity(
      onConnectionChanged: (isConnected) {
        if (mounted) {
          setState(() {
            _isConnected = isConnected;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _networkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_isConnected && widget.showOfflineMessage)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.red,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'No Internet Connection',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        Expanded(child: widget.child),
      ],
    );
  }
}
