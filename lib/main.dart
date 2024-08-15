import 'dart:math';

import 'package:flutter/material.dart';
import 'package:learn_flutter_webrtc/core/services/signalling_service.dart';
import 'package:learn_flutter_webrtc/presentations/features/join/view/join_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // signalling server url
  final String websocketUrl = "http://192.168.137.1:3000";

  // generate callerID of local user
  final String selfCallerID =
      Random().nextInt(999999).toString().padLeft(6, '0');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // init signalling service
    SignallingService.instance.init(
      websocketUrl: websocketUrl,
      selfCallerID: selfCallerID,
    );
    return MaterialApp(
      darkTheme: ThemeData.dark()
          .copyWith(colorScheme: const ColorScheme.dark(), useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: JoinView(selfCallerId: selfCallerID),
    );
  }
}
