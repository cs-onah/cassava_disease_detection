import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';
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
      imageQuality: quality,
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
