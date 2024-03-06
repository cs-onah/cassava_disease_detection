import 'package:flutter/material.dart';
import 'package:plant_disease_detection/ui/screens/onboarding_page.dart';
import 'package:plant_disease_detection/ui/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // App Expires 15th december
  bool get isExpired => DateTime.now().isAfter(DateTime(2024, 5, 1));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isExpired ? ErrorPage() : OnboardingPage(),
      theme: appTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "404",
              style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text("An Unknown error occured"),
          ],
        ),
      ),
    );
  }
}
