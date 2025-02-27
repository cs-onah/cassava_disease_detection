import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassificationServiceTwo {
  static Future<Uint8List> loadImage(File file) async {
    final img = decodeImage(file.readAsBytesSync())!;
    final resizedImg = copyResize(img, width: 224, height: 224);
    return Uint8List.fromList(resizedImg.getBytes());
  }

  static List<double> preprocessImage(Uint8List imageBytes) {
    final image = Image.fromBytes(
      width: 224,
      height: 224,
      bytes: imageBytes.buffer,
    );
    final inputBuffer = Float32List(224 * 224 * 3);
    var index = 0;
    for (var y = 0; y < 224; y++) {
      for (var x = 0; x < 224; x++) {
        final pixel = image.getPixel(x, y);
        inputBuffer[index++] = (pixel.r / 127.5) - 1.0;
        inputBuffer[index++] = (pixel.g / 127.5) - 1.0;
        inputBuffer[index++] = (pixel.b / 127.5) - 1.0;
      }
    }
    return inputBuffer.toList();
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
    const modelPath = "assets/model/MobilenetV2.tflite";
    final classesDict = {
      0: 'Mosaic_N',
      1: 'blight_N',
      2: 'brownstreak_N',
      3: 'greenmite_N'
    };

    final interpreter = await Interpreter.fromAsset(modelPath);
    final imageBytes = await loadImage(uploadedImage);
    final input = preprocessImage(imageBytes);

    final output = List<double>.filled(classesDict.length, 0)
        .reshape([1, classesDict.length]);
    interpreter.run([input], output);

    final probs = output[0];
    final response = display(classesDict, probs);

    return response;
  }
}
