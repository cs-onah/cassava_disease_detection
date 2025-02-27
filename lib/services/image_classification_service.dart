import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:plant_disease_detection/models/model_result.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassificationService {
  /// Resizes image to 224x224 pixels and returns [Image]
  static Image loadAndResizeImage(File file) {
    final img = decodeImage(file.readAsBytesSync())!;
    return copyResize(img, width: 224, height: 224);
  }

  /// Convert the image to a 3-channel RGB format and normalize pixel values to [-1, 1]
  static List<double> convertImage(Image image) {
    final inputBuffer = Float32List(224 * 224 * 3); // Shape: [224, 224, 3]
    var index = 0;

    for (var y = 0; y < 224; y++) {
      for (var x = 0; x < 224; x++) {
        final pixel = image.getPixel(x, y);

        // Normalize pixel values to [-1, 1]
        inputBuffer[index++] = (pixel.r / 127.5) - 1.0; // Red channel
        inputBuffer[index++] = (pixel.g / 127.5) - 1.0; // Green channel
        inputBuffer[index++] = (pixel.b / 127.5) - 1.0; // Blue channel
      }
    }

    return inputBuffer.toList();
  }

  /// Reshape the image to [1, 224, 224, 3]
  static List<List<List<List<double>>>> reshapeImage(List<double> imageData) {
    final reshapedImage = List.generate(
      1, // Batch size
      (_) => List.generate(
        224, // Height
        (y) => List.generate(
          224, // Width
          (x) => List.generate(
            3, // Channels
            (c) => imageData[(y * 224 * 3) + (x * 3) + c],
          ),
        ),
      ),
    );
    return reshapedImage;
  }

  /// Maps disease name to disease probability
  static ModelResult parseOutput(
    Map<int, String> classesDict,
    List<double> probs,
  ) {
    final result = <String, double>{};
    for (var i = 0; i < probs.length; i++) {
      result.addAll(
        {classesDict[i]!: double.parse((probs[i] * 100).toStringAsFixed(2))},
      );
    }
    return ModelResult.fromJson(result);
  }

  /// Returns result from classification
  static Future<ModelResult> processImage(File uploadedImage) async {
    const modelPath = "assets/models/plant_disease_detection_v2.tflite";
    final classesDict = {
      0: 'Mosaic_N',
      1: 'blight_N',
      2: 'brownstreak_N',
      3: 'greenmite_N'
    };

    final interpreter = await Interpreter.fromAsset(modelPath);

    /// Actual shape: [1, 224, 224, 3]
    /// Uses the NHWC format, typically used to collect images for models
    ///
    /// N: Number of samples (batch size)
    /// H: Height of the image
    /// W: Width of the image
    /// C: Number of channels (e.g., 3 for RGB images, 1 for grayscale)
    ///
    /// NOTE: Some models can require a different format
    final inputTensor = interpreter.getInputTensors().first;

    /// actual shape: [1, 4]
    /// 2-D shape; (batch_size, num_classes)
    final outputTensor = interpreter.getOutputTensors().first;

    log("input shape: ${inputTensor.shape}");
    log("output shape: ${outputTensor.shape}");

    final image = loadAndResizeImage(uploadedImage);
    final preprocessed = convertImage(image);
    final shape = reshapeImage(preprocessed);

    final output = List<double>.filled(classesDict.length, 0)
        .reshape([1, classesDict.length]);

    /// Run classification
    interpreter.run(shape, output);

    final probability = output[0];
    return parseOutput(classesDict, probability);
  }
}
