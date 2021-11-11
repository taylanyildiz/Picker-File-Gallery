import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    Key? key,
    required this.file,
  }) : super(key: key);
  final File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar,
      body: InteractiveViewer(
        child: Image.file(
          file,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  AppBar get buildAppBar {
    return AppBar(
      elevation: 0.0,
      backgroundColor: const Color(0xff1e2b34),
      title: const Text(
        'Image',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back),
        color: Colors.white,
        iconSize: 25.0,
      ),
    );
  }
}
