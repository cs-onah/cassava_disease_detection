import 'package:flutter/material.dart';
import 'package:plant_disease_detection/helpers/context_extension.dart';
import 'package:plant_disease_detection/ui/screens/select_scan_page.dart';
import 'package:plant_disease_detection/ui/theme/colors.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/onboarding_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Spacer(),
                Row(
                  children: [
                    Text("CP-Scan", style: context.textTheme.displayLarge?.copyWith(fontSize: 36)),
                    const SizedBox(width: 8),
                    Image.asset("assets/images/logo.png", height: 60),
                  ],
                ),
                Spacer(),
                Text(
                  "Detect select diseases in Cassava plants",
                  style: context.textTheme.displayLarge,
                ),
                const SizedBox(height: 20),
                Text(
                  "This app is built on an machine learning model to detect select diseases in cassava plants using the images of the leaves.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: ()=> context.push(SelectScanPage()),
                  child: Text("Start Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.transparentWhite,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}