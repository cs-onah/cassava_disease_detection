import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_detection/services/image_classification_service.dart';
import 'package:plant_disease_detection/services/image_utility.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imageClassificationHelper = ImageClassificationService();

  @override
  void initState() {
    imageClassificationHelper.init();
    ImageUtil.requestImagePermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plant Disease Detection"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: startDetection,
          child: Text("Start Detection"),
        ),
      ),
    );
  }

  Future startDetection() async {
    // pick image
    File? file = await ImageUtil.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final image = await ImageUtil.convertFileToImageData(file);
    if (image == null) return;
    final classification = await imageClassificationHelper.processImage(image);
    log(classification.toJson().toString() ?? '');
  }

  @override
  void dispose() {
    imageClassificationHelper.close();
    super.dispose();
  }
}
