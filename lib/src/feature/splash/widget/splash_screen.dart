import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_weather_app/main.dart';
import 'package:open_weather_app/src/common/routes/fade_transition.dart';
import 'package:open_weather_app/src/common/theme/theme.dart';

/// SplashScreen widget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        FadePageRoute(builder: (context) => const Main()),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  String _getSlogan(DateTime dateTime) {
    final hour = dateTime.hour;
    if (hour >= 6 && hour < 12) {
      return 'early bird gets the worm';
    } else if (hour >= 12 && hour < 18) {
      return 'enjoy the sunshine';
    } else if (hour >= 18 && hour < 22) {
      return 'great time to reflect on the day';
    } else {
      return 'dawn is coming soon';
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final slogan = _getSlogan(now);

    return MaterialApp(
      theme: darkTheme,
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kGradientColor, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: const Center(
            child: Padding(
              padding: EdgeInsets.only(left: 43, bottom: 43),
              child: Text(
                'WEATHER SERVICE',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          persistentFooterAlignment: AlignmentDirectional.center,
          persistentFooterButtons: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Text(
                slogan,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
        // ),
      ),
    );
  }
}
