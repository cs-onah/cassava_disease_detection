import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsWidget extends StatelessWidget {
  final Color? textColor;
  const CreditsWidget({super.key, this.textColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> launchUrl(Uri.parse("https://www.csonah.com/")),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: RichText(
          text: TextSpan(
            text: "Developed by ",
            style: TextStyle(fontSize: 10, color: textColor),
            children: const [
              TextSpan(
                text: "csonah © 2025",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
