import '/controllers/controllers.dart';
import '../controllers/gallery_picker_screen_controller.dart';
import '/models/file_model.dart';
import '/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/material.dart';

class GalleryPickerScreen extends GetView<GalleryPickerScreenController> {
  const GalleryPickerScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GalleryPickerScreenController>(
        builder: (galleryPickerController) {
      return Scaffold(
        backgroundColor: const Color(0xff0f171a),
        appBar: buildAppBar,
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GalleryPicker(
            scrollController: controller.scrollController,
            pickFiles: controller.pickFiles,
            onDetail: controller.onDetail,
            files: controller.files,
            child: (context, index) {
              switch (galleryPickerController.files[index].type!) {
                case AssetType.image:
                  return _ImagePicker(
                      fileModel: galleryPickerController.files[index]);
                case AssetType.video:
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.memory(
                        galleryPickerController.files[index].thumbData!,
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
                  return Container();
                case AssetType.other:
                  return Container();
              }
            },
          ),
        ),
      );
    });
  }

  AppBar get buildAppBar {
    return AppBar(
      elevation: 0.0,
      backgroundColor: const Color(0xff1e2b34),
      leading: IconButton(
        color: Colors.white,
        iconSize: 25.0,
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Get.back(),
      ),
      title: Text(
        controller.selectedFile.isEmpty
            ? 'Gallery'
            : '${controller.selectedFile.length} Selected',
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      actions: [
        Visibility(
          visible: controller.selectedFile.isNotEmpty,
          child: IconButton(
            onPressed: controller.selectFiles,
            icon: const Icon(Icons.done),
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class _ImagePicker extends StatelessWidget {
  const _ImagePicker({
    Key? key,
    required this.fileModel,
  }) : super(key: key);
  final FileModel fileModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.transparent,
          child: const Center(
            child: Icon(
              Icons.image,
              color: Colors.black,
            ),
          ),
        ),
        Image.file(
          fileModel.file!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
