import 'package:bottom_sheet_picker/controllers/home_screen_controller.dart';
import 'package:bottom_sheet_picker/widgets/camera_button.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraScreen extends GetView<HomeScreenController> {
  const CameraScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: controller.onWillPop,
        child: GetBuilder<HomeScreenController>(builder: (context) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              buildCamera,
              buildCloseButton,
              buildFlashButton,
              buildGalleryButton,
              buildCameraLensButton,
              buildCameraTakeButton,
              buildExplanation,
            ],
          );
        }),
      ),
    );
  }

  Widget get buildCamera {
    return GetBuilder<HomeScreenController>(builder: (_) {
      return Positioned.fill(
        child: Hero(
          tag: '0-camera',
          child: Transform.scale(
            scale: controller.fullScreenCameraScale,
            child: CameraPreview(controller.cameraController!),
          ),
        ),
      );
    });
  }

  Widget get buildCloseButton {
    return Positioned(
      top: 20.0,
      left: 10.0,
      child: GestureDetector(
        onTap: controller.backFromCamera,
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: 35.0,
        ),
      ),
    );
  }

  Widget get buildFlashButton {
    return Positioned(
      top: 20.0,
      right: 10.0,
      child: GestureDetector(
        onTap: () {},
        child: const Icon(
          Icons.flash_auto,
          color: Colors.white,
          size: 35.0,
        ),
      ),
    );
  }

  Widget get buildGalleryButton {
    return Positioned(
      bottom: 50.0,
      left: 20.0,
      child: GestureDetector(
        onTap: () {},
        child: const Icon(
          Icons.image,
          color: Colors.white,
          size: 45.0,
        ),
      ),
    );
  }

  Widget get buildCameraLensButton {
    return Positioned(
      bottom: 50.0,
      right: 20.0,
      child: GestureDetector(
        onTap: controller.setCameraLens,
        child: const Icon(
          Icons.flip_camera_ios,
          color: Colors.white,
          size: 45.0,
        ),
      ),
    );
  }

  Widget get buildCameraTakeButton {
    return CameraButton(
      onTakePicture: controller.takePhoto,
      onStartRecordingVideo: controller.recordVideo,
      onSaveVideo: controller.saveVideo,
    );
  }

  Widget get buildExplanation {
    return const Positioned(
      bottom: 20.0,
      child: Text(
        'Tap for photo, hold for video',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
