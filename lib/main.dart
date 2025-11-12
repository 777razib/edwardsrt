// lib/main.dart
import 'package:edwardsrt/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

      // --- Localization Setup ---
      translations: AppLocalization(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),

      // Supported languages (including Turkish)
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('hi'),
        Locale('zh'),
        Locale('tr'),
      ],

      // Add these delegates
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}
