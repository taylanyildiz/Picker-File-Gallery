import 'package:image_crop/image_crop.dart';
import '/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageDetailScreen extends GetView<ImageDetailScreenController> {
  const ImageDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar,
      body: GetBuilder<ImageDetailScreenController>(
        builder: (_) {
          return Stack(
            children: [
              buildCropper,
            ],
          );
        },
      ),
    );
  }

  Widget get buildCropper {
    return Crop.file(
      controller.file!,
      key: controller.cropKey,
      alwaysShowGrid: false,
      scale: 1.001,
    );
  }

  AppBar get buildAppBar {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: controller.onBack,
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: 30.0,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            controller.setCropEnable();
          },
          icon: const Icon(
            Icons.crop,
            color: Colors.black,
            size: 30.0,
          ),
        ),
        IconButton(
          onPressed: () async {
            await controller.cropImage();
          },
          icon: const Icon(
            Icons.done,
            color: Colors.black,
            size: 30.0,
          ),
        )
      ],
    );
  }
}
