import '/models/file_model.dart';
import 'package:flutter/material.dart';

class ImageDetailScreen extends StatelessWidget {
  const ImageDetailScreen({
    Key? key,
    required this.fileModel,
  }) : super(key: key);
  final FileModel? fileModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f171a),
      body: InteractiveViewer(
        child: Image.file(
          fileModel!.file!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
