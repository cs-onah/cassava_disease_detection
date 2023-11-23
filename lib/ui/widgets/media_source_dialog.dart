import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_detection/helpers/context_extension.dart';

class MediaSourceDialog extends StatelessWidget {
  const MediaSourceDialog({super.key});

  static Future<ImageSource?> pickSource(BuildContext context) => showDialog(
        context: context,
        builder: (_) => MediaSourceDialog(),
      );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Text("Select Image Source", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => context.pop(ImageSource.camera),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("From Camera")
                    ],
                  ),
                  VerticalDivider(thickness: 1),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => context.pop(ImageSource.gallery),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Icon(Icons.photo_library_outlined),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("From Gallery")
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
