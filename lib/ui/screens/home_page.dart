import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_detection/services/image_classification_service.dart';
import 'package:plant_disease_detection/services/image_utility.dart';
import 'package:image/image.dart' as img;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imageClassificationHelper = ImageClassificationService();

  @override
  void initState() {
    imageClassificationHelper.initHelper();
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

    // Read image bytes from file
    final imageData = file.readAsBytesSync();

    // Decode image using package:image/image.dart (https://pub.dev/image)
    img.Image? image = img.decodeImage(imageData);
    if (image == null) return;
    final classification = await imageClassificationHelper.processImage(image);
  }

  @override
  void dispose() {
    imageClassificationHelper.close();
    super.dispose();
  }
}
