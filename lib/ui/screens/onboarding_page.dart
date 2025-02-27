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
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            child: Column(
              children: [
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "L-Scan",
                        style: context.textTheme.displayLarge
                            ?.copyWith(fontSize: 36),
                      ),
                      const SizedBox(width: 8),
                      Image.asset("assets/images/logo.png", height: 60),
                    ],
                  ),
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
                  onPressed: () => context.push(SelectScanPage()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.transparentWhite,
                  ),
                  child: Text(
                    "Start Now",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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
