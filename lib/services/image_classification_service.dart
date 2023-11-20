import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'isolate_inference.dart';

class ImageClassificationService {
  static const modelPath = 'assets/models/plant_disease_detection.tflite';
  static const labelsPath = 'assets/models/labels.txt';

  late final Interpreter interpreter;
  late final IsolateInterpreter isolateInterpreter;
  late Tensor inputTensor;
  late Tensor outputTensor;
  List<String> labels = [];

  // Load model
  Future<void> _loadModel() async {
    InterpreterOptions options = InterpreterOptions();

    // Use XNNPACK Delegate
    if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    }

    // Use GPU Delegate
    // doesn't work on emulator
    // if (Platform.isAndroid) {
    //   options.addDelegate(GpuDelegateV2());
    // }

    // Use Metal Delegate
    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }

    // Load model from assets
    // interpreter = await Interpreter.fromAsset(modelPath, options: options);
    interpreter = await Interpreter.fromAsset(modelPath);
    isolateInterpreter =
        await IsolateInterpreter.create(address: interpreter.address);

    // actual shape: [1, 224, 224, 3]
    inputTensor = interpreter.getInputTensors().first;

    // actual shape: [1, 4]
    outputTensor = interpreter.getOutputTensors().first;

    print(inputTensor);
    print(outputTensor);

    log('Interpreter loaded successfully');
  }

  // Load labels from assets
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Future<void> initHelper() async {
    await _loadModel();
    await _loadLabels();
  }

  Future processImage(Image image) async {
    // resize original image to match model shape.
    Image imageInput = copyResize(
      image,
      width: inputTensor.shape[1],
      height: inputTensor.shape[2],
    );

    // if (Platform.isAndroid && isolateModel.isCameraFrame()) {
    //   imageInput = image_lib.copyRotate(imageInput, angle: 90);
    // }

    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()];
        },
      ),
    );

    // Set tensor input [1, 224, 224, 3]
    final input = [imageMatrix];
    // Set tensor output [1, 1001]
    final output = [List<int>.filled(outputTensor.shape[1], 0)];

    // // Run inference
    await isolateInterpreter.run(input, output);
    // Get first output tensor
    final result = output.first;
    int maxScore = result.reduce((a, b) => a + b);

    print(result);

    // Set classification map {label: points}
    // var classification = <String, double>{};
    // for (var i = 0; i < result.length; i++) {
    //   if (result[i] != 0) {
    //     // Set label: points
    //     classification[labels[i]] = result[i].toDouble() / maxScore.toDouble();
    //   }
    // }
  }

  Future<void> close() async {
    interpreter.close();
    isolateInterpreter.close();
  }
}
