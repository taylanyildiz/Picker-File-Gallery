import 'dart:io';
import 'package:flutter/material.dart';

class ImageDetailScreen extends StatelessWidget {
  const ImageDetailScreen({
    Key? key,
    required this.file,
  }) : super(key: key);
  final File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InteractiveViewer(
        child: Image.file(
          file,
        ),
      ),
    );
  }
}
