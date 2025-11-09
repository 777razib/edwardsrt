// lib/main.dart
import 'package:edwardsrt/localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'feature/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mind Cleanser',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFFF3),
        primaryColor: const Color(0xFF4A90E2),
        fontFamily: 'Roboto',
      ),

      // Localization Setup
      translations: AppLocalization(),
      locale: const Locale('en'), // Default language
      fallbackLocale: const Locale('en'), // Fallback language
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('hi'),
        Locale('zh'),
        Locale('tr'),
      ],

      // Splash Screen as Home
      home: const Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}
