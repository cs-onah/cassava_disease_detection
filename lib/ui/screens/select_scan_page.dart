import 'package:flutter/material.dart';
import 'package:plant_disease_detection/helpers/context_extension.dart';
import 'package:plant_disease_detection/services/deprecated/django_service.dart';
import 'package:plant_disease_detection/services/deprecated/image_classification_service_trial.dart';
import 'package:plant_disease_detection/services/image_classification_service.dart';
import 'package:plant_disease_detection/services/image_utility.dart';
import 'package:plant_disease_detection/ui/screens/result_page.dart';
import 'package:plant_disease_detection/ui/theme/colors.dart';
import 'package:plant_disease_detection/ui/widgets/credits_widget.dart';
import 'package:plant_disease_detection/ui/widgets/media_source_dialog.dart';

class SelectScanPage extends StatefulWidget {
  const SelectScanPage({super.key});
  @override
  State<SelectScanPage> createState() => _SelectScanPageState();
}

class _SelectScanPageState extends State<SelectScanPage> {
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    BackButton(color: Colors.white, onPressed: context.pop),
                    const SizedBox(width: 8),
                    Text("Select Scan", style: context.textTheme.displayMedium),
                  ],
                ),
                Spacer(),
                Card(
                  elevation: 0,
                  color: AppColors.transparentWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Scan type",
                          style: context.textTheme.displayLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "The selected scan type determines the type of result presented",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 18),
                        ScanOptionCard(
                          title: "Identify disease",
                          description: "This option uses the model to predict "
                              "the most likely disease identified in the image of the cassava leave",
                          icon: Icon(Icons.science_outlined),
                          onTap: () => processImage(true),
                        ),
                        const SizedBox(height: 16),
                        ScanOptionCard(
                          title: "Run scan",
                          description:
                              "This option uses the model to predict the"
                              " likelihood that the cassava leaf has any of the different diseases",
                          icon: Icon(Icons.compare),
                          onTap: () => processImage(false),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                CreditsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future processImage(bool isSingleResult) async {
    // select image source
    final source = await MediaSourceDialog.pickSource(context);
    if (source == null) return null;
    // pick file
    final file = await ImageUtil.pickImage(source: source);
    if (file == null) return;
    context.showLoading();
    try {
      final result = await ImageClassificationService.processImage(file);
      await Future.delayed(Duration(seconds: 1)); // Simulate delay
      if (result.invalidResult) {
        context.pop();
        showRejectImageDialog();
        return;
      }
      context.pop();
      context.push(
        ResultPage(image: file, result: result, isSingleResult: isSingleResult),
      );
    } catch (error) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(Icons.cancel, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "$error",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  showRejectImageDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.orange, size: 100),
                SizedBox(height: 10),
                Text(
                  "Image Rejected",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "The selected file does not seem to be an image of a leaf."
                  "\nPlease re-take the photo.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text("Dismiss"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ScanOptionCard extends StatelessWidget {
  final String? title;
  final String? description;
  final VoidCallback? onTap;
  final Icon? icon;
  const ScanOptionCard({
    super.key,
    this.title,
    this.description,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: icon,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? "--",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description ?? "--",
                    style: TextStyle(color: Colors.white.withOpacity(.8)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
