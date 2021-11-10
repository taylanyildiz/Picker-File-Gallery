import 'dart:async';
import 'dart:io';
import 'package:bottom_sheet_picker/controllers/controllers.dart';
import 'package:bottom_sheet_picker/models/file_model.dart';
import 'package:photo_manager/photo_manager.dart';

import '/routers/app_routers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';

class CameraScreenController extends GetxController {
  /// Camera controller.
  CameraController? cameraController;

  /// Video timer.
  Timer? timer;

  final homeController = Get.find<HomeScreenController>();

  @override
  void onInit() {
    cameraController = Get.arguments['camera'];
    if (cameraController == null) {
      initializedCamera();
    }
    setFullScreen();
    super.onInit();
  }

  @override
  void onClose() {
    initializedCamera(lens: 0);
    super.onClose();
  }

  Future<bool> onWillPop() async {
    await setNormalScreen();
    initializedCamera(lens: 0);
    Get.back();
    return true;
  }

  void onBack() async {
    initializedCamera(lens: 0);
    await setNormalScreen();
    Get.back();
  }

  void initializedCamera({int lens = 0}) {
    cameraController = CameraController(cameras![lens], ResolutionPreset.max)
      ..initialize().then((value) {
        update();
        homeController.cameraController = cameraController;
        homeController.update();
        return;
      });
  }

  void setCameraLens() async {
    int lens = cameraController!.description.lensDirection.index;
    if (cameraController != null) {
      await cameraController!.dispose();
    }
    initializedCamera(lens: lens);
  }

  Future<void> takePicture() async {
    File file = File((await cameraController!.takePicture()).path);
    AssetEntity? imageEntity = await PhotoManager.editor.saveImageWithPath(
      file.path,
    );
    if (imageEntity != null) {
      final fileModel = FileModel(
        id: imageEntity.id,
        file: await imageEntity.originFile,
        path: imageEntity.relativePath,
        extention: imageEntity.mimeType!.split('/')[1],
        type: AssetType.image,
        duration: imageEntity.videoDuration,
      );
      Get.toNamed(AppRoutes.imageDetail, arguments: {
        'file_model': fileModel,
        'isCamera': true,
      });
    }
  }

  Future<void> recordVideo() async {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(const Duration(seconds: 1), () async {
      if (timer!.tick == 1) {
        await cameraController!.startVideoRecording();
        update();
      }
      if (timer!.tick != 1) {}
    });
  }

  Future<void> saveVideo() async {
    if (cameraController!.value.isRecordingVideo) {
      timer!.cancel();
      File file = File((await cameraController!.stopVideoRecording()).path);
    }
  }

  double get fullScreenCameraScale {
    double aspectRatio = 1.0;
    double pixelRati = MediaQuery.of(Get.context!).size.aspectRatio;
    if (cameraController!.value.previewSize != null) {
      aspectRatio = cameraController!.value.aspectRatio;
    }
    return 1 / (aspectRatio * pixelRati);
  }
}
