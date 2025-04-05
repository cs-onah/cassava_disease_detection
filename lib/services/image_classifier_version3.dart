import 'dart:io';
import 'dart:typed_data';

import 'package:plant_disease_detection/models/model_result.dart';
import 'package:plant_disease_detection/services/image_classifier.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ImageClassifierVersion3 extends ImageClassifier {
  /// Instance of Interpreter
  late Interpreter _interpreter;

  static const String modelFile =
      "assets/models/plant_disease_detection_v3.tflite";

  /// Loads interpreter from asset
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        modelFile,
        options: InterpreterOptions()..threads = 4,
      );
      _interpreter.allocateTensors();
    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }

  /// Maps disease name to disease probability
  ModelResult _parseOutput(List<double> probs) {
    final result = <String, double>{};
    for (var i = 0; i < probs.length; i++) {
      result.addAll(
        {classesDict[i]!: double.parse((probs[i] * 100).toStringAsFixed(2))},
      );
    }
    return ModelResult.fromJson(result);
  }

  /// Gets the interpreter instance
  Interpreter get interpreter => _interpreter;

  @override
  Future<ModelResult> processImage(File file) async {
    await _loadModel();
    final image = img.decodeImage(file.readAsBytesSync())!;
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    // Convert the resized image to a 1D Float32List.
    Float32List inputBytes = Float32List(1 * 224 * 224 * 3);
    int pixelIndex = 0;
    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        final pixel = resizedImage.getPixel(x, y);
        inputBytes[pixelIndex++] = pixel.r / 127.5 - 1.0;
        inputBytes[pixelIndex++] = pixel.g / 127.5 - 1.0;
        inputBytes[pixelIndex++] = pixel.b / 127.5 - 1.0;
      }
    }

    // Reshape to input format specific for model. 1 item in list with pixels 150x150 and 3 layers for RGB
    final input = inputBytes.reshape([1, 224, 224, 3]);

    // Output container
    final output = Float32List(1 * 4).reshape([1, 4]);

    // Run data through model
    interpreter.run(input, output);

    // Get index of maxumum value from outout data. Remember that models output means:
    // Index 0 - rock, 1 - paper, 2 - scissor, 3 - nothing.
    final predictionResult = output[0] as List<double>;
    return _parseOutput(predictionResult);
  }
}
