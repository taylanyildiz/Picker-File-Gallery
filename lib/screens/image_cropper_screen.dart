import 'package:bottom_sheet_picker/controllers/controllers.dart';
import 'package:bottom_sheet_picker/models/file_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_crop/image_crop.dart';

class ImageCropperScreeen extends StatefulWidget {
  const ImageCropperScreeen({
    Key? key,
    required this.fileModel,
  }) : super(key: key);
  final FileModel fileModel;

  @override
  State<ImageCropperScreeen> createState() => _ImageCropperScreeenState();
}

class _ImageCropperScreeenState extends State<ImageCropperScreeen> {
  final cropKey = GlobalKey<CropState>();
  final galleryController = Get.find<GalleryDetailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar,
      body: Container(
        color: Colors.black,
        child: Crop.file(
          widget.fileModel.file!,
          key: cropKey,
          alwaysShowGrid: true,
          scale: 1.001,
          aspectRatio: .55,
        ),
      ),
    );
  }

  AppBar get buildAppBar {
    return AppBar(
      elevation: 0.0,
      backgroundColor: const Color(0xff1e2b34),
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => galleryController.cropImage(cropKey),
          child: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.done,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        ),
      ],
    );
  }
}
