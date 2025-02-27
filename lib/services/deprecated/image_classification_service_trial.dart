import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:plant_disease_detection/models/model_result.dart';
import 'package:plant_disease_detection/services/image_utility.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Process image using model and provides classification output
///
/// initialize using [init]
/// process image using [processImage]
/// dispose using [close]
@Deprecated("Returns wrong output. Use ImageClassificationService instead")
class ImageClassificationServiceTrial {
  static const modelPath = 'assets/models/plant_disease_detection_v2.tflite';
  static const labelsPath = 'assets/models/labels.txt';

  late final IsolateInterpreter isolateInterpreter;
  late Tensor inputTensor;
  late Tensor outputTensor;
  List<String> labels = [];

  Future<void> init() async {
    await _loadModel();
    await _loadLabels();
  }

  Future<void> _loadModel() async {
    final interpreter = await Interpreter.fromAsset(modelPath);
    isolateInterpreter = await IsolateInterpreter.create(
      address: interpreter.address,
    );

    /// Actual shape: [1, 224, 224, 3]
    /// Uses the NHWC format, typically used to collect images for models
    ///
    /// N: Number of samples (batch size)
    /// H: Height of the image
    /// W: Width of the image
    /// C: Number of channels (e.g., 3 for RGB images, 1 for grayscale)
    ///
    /// NOTE: Some models can require a different format
    inputTensor = interpreter.getInputTensors().first;

    /// actual shape: [1, 4]
    /// 2-D shape; (batch_size, num_classes)
    outputTensor = interpreter.getOutputTensors().first;

    log("input shape: ${inputTensor.shape}");
    log("output shape: ${outputTensor.shape}");
    log('Model loaded successfully');
  }

  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Future<ModelResult> processImage(Image image) async {
    // resize original image to match model required input shape.
    Image imageInput = copyResize(
      image,
      width: inputTensor.shape[1],
      height: inputTensor.shape[2],
    );

    final imageMatrix = ImageUtil.getPixelMatrix(imageInput);

    // Set tensor input [1, 224, 224, 3]
    final input = [imageMatrix];
    // Set tensor output [1, 4]
    final output = [List<double>.filled(outputTensor.shape[1], 0)];

    await isolateInterpreter.run(input, output);
    // Get first output tensor
    final result = output.first;
    double maxScore = result.reduce((a, b) => a + b);

    var classification = <String, double>{};
    for (var i = 0; i < result.length; i++) {
      if (result[i] != 0) {
        classification[labels[i]] = result[i].toDouble() / maxScore;
      }
    }

    return ModelResult.fromJson(classification);
  }

  Future<void> close() async {
    isolateInterpreter.close();
  }
}
