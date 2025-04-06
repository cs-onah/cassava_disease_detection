import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUtil {
  static String fileName(String filePath) => filePath.split('/').last;

  static const List<String> allowedExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
  ];

  /// Returns file size in MB
  static Future<double?> getFileSize(File file) async {
    try {
      final fileSizeInBytes = await file.length();
      const mb = 1024 * 1024;
      return fileSizeInBytes / mb;
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<File> compressImage(File file) async {
    CompressFormat? format;
    if (file.absolute.path.endsWith("png")) {
      format = CompressFormat.png;
    }
    if (file.absolute.path.endsWith("heic")) {
      format = CompressFormat.heic;
    }
    if (file.absolute.path.endsWith("jpg") ||
        file.absolute.path.endsWith("jpeg")) {
      format = CompressFormat.jpeg;
    }
    if (format == null)  {
      debugPrint("Compress Image Error-> Unknown Format");
      return file;
    }
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'\.(jpg|png|jpeg)$'));
      final split = filePath.substring(0, (lastIndex));
      final outPath = "${split}_out${filePath.substring(lastIndex)}";
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 20,
        format: format,
      );
      if (result == null)  {
        debugPrint("Compress Image Error-> Compression Failed");
        return file;
      }
      return File(result.path);
    } catch (error) {
      debugPrint("Compress Image Error-> $error");
      return file;
    }
  }

  static Future<Image?> convertFileToImageData(File file) async {
    final imageData = file.readAsBytesSync();
    return decodeImage(imageData);
  }

  static Future<String> localFileToBase64(File file) async {
    Uint8List imageBytes = await file.readAsBytes();
    String base64string = base64.encode(imageBytes);
    return base64string;
  }

  static Future<String> assetFileToBase64(String assetPath) async {
    ByteData bytes = await rootBundle.load(assetPath);
    var buffer = bytes.buffer;
    var base64String = base64.encode(Uint8List.view(buffer));
    return base64String;
  }

  /// Use result with Image.memory widget.
  static Uint8List memoryImageFromBase64(String base64Image) =>
      const Base64Decoder().convert(base64Image);

  /// Throws exception if selected file does not use an allowed file extension
  static Future<File?> pickImage({
    int quality = 50,
    ImageSource source = ImageSource.gallery,
  }) async {
    XFile? file = await ImagePicker().pickImage(
      source: source,
      // imageQuality: quality,
    );

    if (file == null) return null;

    /// Check file uses allowed file extensions
    bool hasAllowedExtension = false;
    for (final extension in allowedExtensions) {
      if (file.path.toLowerCase().endsWith(extension)) {
        hasAllowedExtension = true;
      }
    }

    if (hasAllowedExtension) {
      return File(file.path);
    } else {
      throw "Only ${allowedExtensions.toString().replaceAll("[", "").replaceAll("]", "")} files are allowed";
    }
  }

  static const imgPermissions = [
    Permission.camera,
    Permission.storage,
    Permission.mediaLibrary,
  ];

  /// Requests for file & image permission
  ///
  /// Remember to add the following permissions to android manifest
  ///
  /// * < uses-permission android:name="android.permission.CAMERA" />
  /// * < uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
  /// * < uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="29" />
  ///
  /// * #Required only if your app needs to access images or photos that other apps created.
  /// < uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
  ///
  /// * #Required only if your app needs to access videos that other apps created.
  /// -< uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
  ///
  static Future<bool> requestImagePermissions() async {
    bool success = false;
    try {
      final status = await imgPermissions.request();
      for (final status in status.values) {
        success = status == PermissionStatus.limited ||
            status == PermissionStatus.granted;
      }
    } catch (_) {
      log("Image Utils: Image Permissions Request failed");
    }
    return success;
  }

  /// Generates a matrix of pixels
  ///
  /// illustration:
  /// ---------------------------
  /// | (R,G,B) (R,G,B) (R,G,B) |
  /// | (R,G,B) (R,G,B) (R,G,B) |
  /// ---------------------------
  static List<List<List<int>>> getPixelMatrix(Image image) {
    /// Image.width and Image.height property describes how many pixels
    /// is arranged vertically and horizontally.
    /// Hence width and height can be used as coordinates to access each pixel.
    return List.generate(
      image.height,
      (y) => List.generate(
        image.width,
        (x) {
          final pixel = image.getPixel(x, y);
          return [pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()];
        },
      ),
    );
  }
}
