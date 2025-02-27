import 'package:flutter/material.dart';
import 'package:plant_disease_detection/ui/screens/onboarding_page.dart';
import 'package:plant_disease_detection/ui/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingPage(),
      theme: appTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
