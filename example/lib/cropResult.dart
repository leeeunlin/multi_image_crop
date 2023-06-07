import 'package:example/imageCropController.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_crop/multi_image_crop.dart';

class CropResult extends StatelessWidget {
  //example result UI
  const CropResult(this.cropImageResult, {Key? key});
  final List<String> cropImageResult;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Result')),
        body: Container(
          child: Text('${cropImageResult}'),
        ));
  }
}
