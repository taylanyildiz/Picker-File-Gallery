import 'package:bottom_sheet_picker/enums/enums.dart';
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
    return GetBuilder<ImageDetailScreenController>(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: buildAppBar,
        body: Stack(
          children: [
            buildImages,
            buildCropper,
          ],
        ),
      );
    });
  }

  Widget get buildCropper {
    return IgnorePointer(
      ignoring: controller.imageMode != EImageDetailMode.edit,
      child: Opacity(
        opacity: controller.imageMode == EImageDetailMode.edit ? 1.0 : 0.0,
        child: Crop.file(
          controller.selectedFileModel.file!,
          key: controller.cropKey,
          alwaysShowGrid: false,
          scale: 1.001,
        ),
      ),
    );
  }

  Widget get buildImages {
    return IgnorePointer(
      ignoring: controller.imageMode != EImageDetailMode.gesture,
      child: Opacity(
        opacity: controller.imageMode == EImageDetailMode.gesture ? 1.0 : 0.0,
        child: Column(
          children: [
            buildImageList(),
            buildImageThumbList(),
          ],
        ),
      ),
    );
  }

  Expanded buildImageList() {
    return Expanded(
      child: PageView.builder(
        controller: controller.imageFileController,
        itemCount: controller.fileModels.length,
        onPageChanged: controller.onPageChangeFile,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Image.file(
              controller.fileModels[index].file!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Container buildImageThumbList() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff1e2b34),
        border: Border.all(width: 1.5, color: Colors.black),
      ),
      height: 80.0,
      child: PageView.builder(
        controller: controller.imageThumController,
        scrollDirection: Axis.horizontal,
        itemCount: controller.fileModels.length,
        onPageChanged: controller.onPageChangeThumb,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: controller.imageThumController,
            builder: (context, child) {
              double value = 1.0;
              if (controller.imageThumController.position.haveDimensions) {
                value = controller.imageThumController.page! - index;
                value = (1 - (value.abs() * .25)).clamp(0.0, 1.0);
              }
              return Center(
                child: SizedBox(
                  width: Curves.easeOut.transform(value) * 150.0,
                  height: Curves.easeOut.transform(value) * 100.0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: controller.selectIndex == index
                          ? Border.all(width: 2.0, color: Colors.blue)
                          : null,
                    ),
                    child: child,
                  ),
                ),
              );
            },
            child: GestureDetector(
              onTap: () => controller.selectImage(index),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.file(
                  controller.fileModels[index].file!,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar get buildAppBar {
    return AppBar(
      elevation: 0.0,
      backgroundColor: const Color(0xff1e2b34),
      leading: IconButton(
        onPressed: controller.onCancelOrBack,
        icon: Icon(
          controller.imageMode == EImageDetailMode.gesture
              ? Icons.arrow_back
              : Icons.close,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      actions: [
        Center(
            child: MaterialButton(
          onPressed: () {
            controller.setCropEnable();
          },
          child: Row(
            children: const [
              Text(
                'Crop Image',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              Icon(
                Icons.crop,
                color: Colors.white,
                size: 30.0,
              ),
            ],
          ),
        )),
        IconButton(
          onPressed: () async {
            await controller.cropOrSelectImage();
          },
          icon: const Icon(
            Icons.done,
            color: Colors.white,
            size: 30.0,
          ),
        )
      ],
    );
  }
}
