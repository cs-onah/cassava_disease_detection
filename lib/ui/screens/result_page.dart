import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plant_disease_detection/helpers/context_extension.dart';
import 'package:plant_disease_detection/models/model_result.dart';

class ResultPage extends StatelessWidget {
  final File image;
  final ModelResult? result;
  final bool isSingleResult;
  const ResultPage({
    super.key,
    required this.image,
    this.result,
    required this.isSingleResult,
  });

  String get likelyDiseaseName {
    final result = this.result;
    if(result == null) return "";
    if(result.mosaic >= result.solution) {
      return "Mosaic";
    }
    if(result.blight >= result.solution) {
      return "Blight";
    }
    if(result.brownStreak >= result.solution) {
      return "Brown Streak";
    }
    if(result.greenMite >= result.solution) {
      return "Green Mite";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurImageBg(
        file: image,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(elevation: 0),
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Spacer(flex: 3),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: context.width * 0.8,
                  width: context.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    border: Border.all(
                      color: Colors.white, width: 2,
                    ),
                    image: DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Spacer(),

                // Result section
                Builder(
                  builder: (_) {
                    if(result == null) return SizedBox.shrink();

                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Image.asset("assets/images/logo.png", height: 60),
                            const SizedBox(width: 16),
                            Expanded(child: Text(likelyDiseaseName,)),
                            const SizedBox(width: 16),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Text("${((result?.solution ?? 0) * 100).toStringAsFixed(1)}%"),
                                CircularProgressIndicator(
                                  value: result?.solution,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BlurImageBg extends StatelessWidget {
  final Widget child;
  final File file;
  const BlurImageBg({super.key, required this.child, required this.file});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(backgroundColor: Colors.transparent,), // stretches background
        ),
        child,
      ],
    );
  }
}
