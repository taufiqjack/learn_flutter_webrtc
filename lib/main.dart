import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_flutter_webrtc/core/hive/hive_stuff.dart';
import 'package:learn_flutter_webrtc/core/routes/route_constants.dart';
import 'package:learn_flutter_webrtc/presentations/features/dashboard/dashboard_view.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  runApp(const MyApp());
  await HiveStuff.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // init signalling service
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        FToastBuilder();
        return ResponsiveBreakpoints.builder(child: child!, breakpoints: [
          const Breakpoint(start: 0, end: 420, name: MOBILE),
          const Breakpoint(start: 421, end: 820, name: TABLET),
          const Breakpoint(start: 821, end: 1000, name: DESKTOP),
        ]);
      },
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(),
      ),
      themeMode: ThemeMode.dark,
      navigatorKey: Go.navigatorKey,
      home: const DashboardView(),
    );
  }
}
