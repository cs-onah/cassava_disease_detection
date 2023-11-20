// import 'dart:io';
//
// import 'package:tflite/tflite.dart';
//
// class OldImageClassificationService {
//
//   static const modelPath = 'assets/models/plant_disease_detection.tflite';
//   static const labelsPath = 'assets/models/labels.txt';
//
//   Future init() async {
//     final res = await Tflite.loadModel(
//         model: modelPath,
//         labels: labelsPath,
//         numThreads: 1, // defaults to 1
//         isAsset: true, // defaults to true, set to false to load resources outside assets
//         useGpuDelegate: false // defaults to false, set to true to use GPU delegate
//     );
//     print(res);
//   }
//
//   processImage(File file) async {
//     var recognitions = await Tflite.runModelOnImage(
//         path: file.path,   // required
//         imageMean: 0.0,   // defaults to 117.0
//         imageStd: 255.0,  // defaults to 1.0
//         numResults: 2,    // defaults to 5
//         threshold: 0.2,   // defaults to 0.1
//         asynch: true      // defaults to true
//     );
//     print(recognitions);
//     return recognitions;
//   }
//
//   close() async {
//     Tflite.close();
//   }
// }