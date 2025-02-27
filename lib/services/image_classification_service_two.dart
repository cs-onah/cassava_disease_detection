import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:plant_disease_detection/services/image_utility.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassificationServiceTwo {
  static Future<Uint8List> loadImage(File file) async {
    final img = decodeImage(file.readAsBytesSync())!;
    final resizedImg = copyResize(img, width: 224, height: 224);
    return Uint8List.fromList(resizedImg.getBytes());
  }

  /// Load and resize the image to 224x224 pixels
  static Image loadAndResizeImage(File file) {
    final img = decodeImage(file.readAsBytesSync())!;
    return copyResize(img, width: 224, height: 224);
  }

  /// Convert the image to a 3-channel RGB format and normalize pixel values to [-1, 1]
  static List<double> preprocessImage(Image image) {
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

  static Map<String, double> display(
      Map<int, String> classesDict, List<double> probs) {
    final result = <String, double>{};
    for (var i = 0; i < probs.length; i++) {
      result.addAll(
        {classesDict[i]!: double.parse((probs[i] * 100).toStringAsFixed(2))},
      );
    }
    return result;
  }

  /// Returns resulf from classification
  static Future<Map<String, dynamic>> imageUpload(File uploadedImage) async {
    const modelPath = "assets/models/plant_disease_detection_v2.tflite";
    final classesDict = {
      0: 'Mosaic_N',
      1: 'blight_N',
      2: 'brownstreak_N',
      3: 'greenmite_N'
    };

    final interpreter = await Interpreter.fromAsset(modelPath);
    final image = loadAndResizeImage(uploadedImage);
    final preprocessed = preprocessImage(image);
    final shape = reshapeImage(preprocessed);

    final output = List<double>.filled(classesDict.length, 0)
        .reshape([1, classesDict.length]);
    print(interpreter.getInputTensor(0).shape);
    print(interpreter.getOutputTensor(0).shape);
    interpreter.run(shape, output);

    final probs = output[0];
    final response = display(classesDict, probs);

    return response;
  }
}
