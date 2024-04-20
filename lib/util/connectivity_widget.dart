import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityWidget extends StatefulWidget {
  const ConnectivityWidget({super.key});

  @override
  _ConnectivityWidgetState createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    // Subscribe to connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String connectivityStatus;
    switch (_connectivityResult) {
      case ConnectivityResult.wifi:
        connectivityStatus = 'Connected to Wi-Fi';
        break;
      case ConnectivityResult.mobile:
        connectivityStatus = 'Connected to mobile data';
        break;
      case ConnectivityResult.none:
        connectivityStatus = 'No internet connection';
        break;
      default:
        connectivityStatus = 'Unknown';
        break;
    }

    return Text(
      connectivityStatus,
      style: const TextStyle(fontSize: 20),
    );
  }
}
