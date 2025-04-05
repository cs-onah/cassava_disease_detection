import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_disease_detection/services/image_classifier.dart';
import 'package:plant_disease_detection/services/image_classifier_http.dart';
import 'package:plant_disease_detection/services/image_classifier_version2.dart';
import 'package:plant_disease_detection/services/image_classifier_version3.dart';
import 'package:plant_disease_detection/ui/providers/model_type_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final modelType = ref.watch(modelTypeProvider);
    final notifier = ref.read(modelTypeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Classifier Settings")),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Text(
            "Select Model",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "Your selection will determine which AI model processes the image",
          ),
          const SizedBox(height: 20),
          ModelTypeTile(
            title: "Server model (HTTP)",
            subtitle: "This option allows your request to be processed "
                "on a django server running the AI model",
            isSelected: modelType == ModelType.http,
            onTap: () => notifier.changeType(ModelType.http),
          ),
          ModelTypeTile(
            title: "Tensorflow Lite Model V2",
            subtitle: "This option allows process your image using "
                "/models/plant_disease_detection_v2.tflite",
            isSelected: modelType == ModelType.version2,
            onTap: () => notifier.changeType(ModelType.version2),
          ),
          ModelTypeTile(
            title: "Tensorflow Lite Model V2",
            subtitle: "This option allows process your image using "
                "/models/plant_disease_detection_v2.tflite",
            isSelected: modelType == ModelType.version3,
            onTap: () => notifier.changeType(ModelType.version3),
          ),
        ],
      ),
    );
  }
}

class ModelTypeTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isSelected;
  const ModelTypeTile({
    super.key,
    this.title,
    this.subtitle,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title ?? "NA"),
      subtitle: subtitle == null ? null : Text(subtitle!),
      onTap: onTap,
      leading: Checkbox(value: isSelected, onChanged: (_) => onTap?.call()),
    );
  }
}
