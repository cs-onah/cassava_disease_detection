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

    // Get tensor input shape [1, 224, 224, 3]
    inputTensor = interpreter.getInputTensors().first;
    // Get tensor output shape [1, 1001]
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
    var outputs = {0: 0, 1: 1};
    await isolateInterpreter.run(image, outputs);
    print(outputs);
    return outputs;
  }

  Future<void> close() async {
    interpreter.close();
    isolateInterpreter.close();
  }
}
