import '/controllers/controllers.dart';
import '../controllers/gallery_picker_screen_controller.dart';
import '/models/file_model.dart';
import '/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
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
        appBar: buildAppBar,
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GalleryPicker(
            scrollController: controller.scrollController,
            pickFiles: (file) {},
            onDetail: (file) {},
            files: controller.files,
            child: (context, index) {
              switch (galleryPickerController.files[index].type!) {
                case AssetType.image:
                  return _ImagePicker(
                      fileModel: galleryPickerController.files[index]);
                case AssetType.video:
                  return _VideoPicker(
                      fileModel: galleryPickerController.files[index]);
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
      backgroundColor: Colors.white,
      leading: IconButton(
        color: Colors.black,
        iconSize: 25.0,
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Select Photo',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
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
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black),
          ),
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
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}

class _VideoPicker extends StatefulWidget {
  const _VideoPicker({
    Key? key,
    required this.fileModel,
  }) : super(key: key);

  final FileModel fileModel;

  @override
  State<_VideoPicker> createState() => _VideoPickerState();
}

class _VideoPickerState extends State<_VideoPicker> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.file(widget.fileModel.file!)
      ..initialize().then((value) {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_controller),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ],
          )
        : Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black),
            ),
            child: const Center(
              child: Icon(
                Icons.image,
                color: Colors.black,
              ),
            ),
          );
  }
}
