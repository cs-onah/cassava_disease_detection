import 'dart:io';

import 'package:dio/dio.dart';
import 'package:plant_disease_detection/models/model_result.dart';

@Deprecated("Use ImageClassificationService instead")
class DjangoService {
  static const url =
      'https://django-disease-detection-6.onrender.com/analyze-image';

  final dio = Dio();

  Future<ModelResult> runImageAnalysis(File file) async {
    dio.options.connectTimeout = Duration(seconds: 120);
    Map<String, dynamic> formData = {
      "image": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split("/").last,
      ),
    };
    FormData data = FormData.fromMap(formData);
    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"},
          method: 'POST',
        ),
        onSendProgress: (_, __) {},
      );
      return ModelResult.fromJson(response.data);
    } catch (error) {
      throw "Image processing failed.";
    }
  }
}
