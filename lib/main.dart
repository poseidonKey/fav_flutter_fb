import 'package:connectivity/connectivity.dart';
import 'package:fav_flutter_fb/firebase_options.dart';
import 'package:fav_flutter_fb/screen/home_screen.dart';
import 'package:fav_flutter_fb/screen/home_screen_fb.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      // home: HomeScreen(),
      home: Center(
        // 데이터 관리용
        // child: HomeScreen(),
        child: FutureBuilder<ConnectivityResult>(
          future: Connectivity().checkConnectivity(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              switch (snapshot.data) {
                case ConnectivityResult.wifi:
                // connectivityStatus = 'Connected to Wi-Fi';
                case ConnectivityResult.mobile:
                  // connectivityStatus = 'Connected to mobile data';
                  return const HomeScreenFirebase();
                case ConnectivityResult.none:
                  // connectivityStatus = 'No internet connection';
                  return const HomeScreen();
                default:
                  // connectivityStatus = 'Unknown';
                  return Container(
                    child: const Text('Unknown Error... retry'),
                  );
              }
            }
          },
        ),
      ),
    );
  }
}
