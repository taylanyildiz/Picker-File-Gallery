import '/screens/screens.dart';
import 'package:photo_manager/photo_manager.dart';
import '/enums/enums.dart';
import '/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryDetailScreen extends GetView<GalleryDetailController> {
  const GalleryDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GalleryDetailController>(
      builder: (_) {
        if (controller.fileModels.isNotEmpty) {
          return Scaffold(
            appBar: buildAppBar,
            body: buildFiles,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
      },
    );
  }

  AppBar get buildAppBar {
    return AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff1e2b34),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30.0,
          ),
        ),
        actions: [
          AnimatedBuilder(
            animation: controller.pageFileController,
            builder: (context, child) {
              switch (controller.selectedFileModel.type) {
                case AssetType.image:
                  return buildImageActions;
                case AssetType.video:
                  return buildVideoActions;
                case AssetType.audio:
                  return const SizedBox();
                default:
                  return const SizedBox();
              }
            },
          )
        ]);
  }

  Widget get buildImageActions {
    return Row(
      children: [
        Visibility(
          visible: controller.fileDetailMode != EFileDetailMode.imageEdit,
          child: Center(
              child: MaterialButton(
            onPressed: () {
              controller.editFile();
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
        ),
        IconButton(
          onPressed: controller.selectFile,
          icon: const Icon(
            Icons.done,
            color: Colors.white,
            size: 30.0,
          ),
        )
      ],
    );
  }

  Widget get buildVideoActions {
    return Row(
      children: [
        Visibility(
          visible: controller.fileDetailMode != EFileDetailMode.videoEdit,
          child: Center(
              child: MaterialButton(
            onPressed: () {
              controller.editFile();
            },
            child: Row(
              children: const [
                Text(
                  'Edit Video',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 30.0,
                ),
              ],
            ),
          )),
        ),
        IconButton(
          onPressed: controller.selectFile,
          icon: const Icon(
            Icons.done,
            color: Colors.white,
            size: 30.0,
          ),
        )
      ],
    );
  }

  Widget get buildFiles {
    return Column(
      children: [
        buildFileList(),
        buildImageThumbList(),
      ],
    );
  }

  Expanded buildFileList() {
    return Expanded(
      child: PageView.builder(
        controller: controller.pageFileController,
        itemCount: controller.fileModels.length,
        onPageChanged: controller.onPageChangeFile,
        itemBuilder: (context, index) {
          switch (controller.fileModels[index].type) {
            case AssetType.image:
              return ImageDetailScreen(fileModel: controller.fileModels[index]);
            case AssetType.video:
              return VideoDetailScreen(fileModel: controller.fileModels[index]);
            case AssetType.audio:
              return const SizedBox();
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  Container buildImageThumbList() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xff1e2b34),
      ),
      height: 80.0,
      child: PageView.builder(
        controller: controller.pageThumbController,
        scrollDirection: Axis.horizontal,
        itemCount: controller.fileModels.length,
        onPageChanged: controller.onPageChangeThumb,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: controller.pageThumbController,
            builder: (context, child) {
              double value = 1.0;
              if (controller.pageThumbController.position.haveDimensions) {
                value = controller.pageThumbController.page! - index;
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
              onTap: () => controller.selectThumbFile(index),
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: (() {
                    switch (controller.fileModels[index].type) {
                      case AssetType.image:
                        return Image.file(
                          controller.fileModels[index].file!,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        );
                      case AssetType.video:
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.memory(
                              controller.fileModels[index].thumbData!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.black,
                              ),
                            )
                          ],
                        );
                      case AssetType.audio:
                        return const SizedBox();
                      default:
                        return const SizedBox();
                    }
                  }())),
            ),
          );
        },
      ),
    );
  }
}
