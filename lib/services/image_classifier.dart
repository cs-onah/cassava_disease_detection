import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_disease_detection/models/model_result.dart';
import 'package:plant_disease_detection/services/image_classifier_http.dart';
import 'package:plant_disease_detection/services/image_classifier_version2.dart';
import 'package:plant_disease_detection/services/image_classifier_version3.dart';
import 'package:plant_disease_detection/ui/providers/model_type_provider.dart';

abstract class ImageClassifier {
  final classesDict = {
    0: 'Mosaic_N',
    1: 'blight_N',
    2: 'brownstreak_N',
    3: 'greenmite_N'
  };

  Future<ModelResult> processImage(File file);
}

final imageClassifier = Provider<ImageClassifier>((ref) {
  final type = ref.watch(modelTypeProvider);
  return switch (type) {
    ModelType.http => ImageClassifierHttp(),
    ModelType.version2 => ImageClassifierVersion2(),
    ModelType.version3 => ImageClassifierVersion3(),
  };
});
