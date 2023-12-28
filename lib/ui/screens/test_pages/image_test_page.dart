import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_detection/services/image_utility.dart';
import 'package:image/image.dart' as im;

class ImageTestPage extends StatefulWidget {
  const ImageTestPage({super.key});

  @override
  State<ImageTestPage> createState() => _ImageTestPageState();
}

class _ImageTestPageState extends State<ImageTestPage> {
  Uint8List? uint8List;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Resize test")),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(30),
          children: [
            if (uint8List != null) Image.memory(uint8List!),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: selectImage, child: Text("Process")),
          ],
        ),
      ),
    );
  }

  selectImage() async {
    final img =
        await ImageUtil.pickImage(source: ImageSource.gallery, quality: 50);
    if (img == null) return;
    // resize image and display.

    final image = await ImageUtil.convertFileToImageData(img);
    if (image == null) return;

    // resize original image
    final imageInput = im.copyResize(
      image,
      width: 244,
      height: 244,
    );

    print(imageInput.height);
    print(imageInput.width);

    List<int> pngBytes = im.encodeJpg(imageInput);

    // Convert to Uint8List
    uint8List = Uint8List.fromList(pngBytes);

    setState(() {});
  }
}
