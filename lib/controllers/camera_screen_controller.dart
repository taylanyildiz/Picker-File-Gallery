import 'dart:async';
import 'dart:io';
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

  @override
  void onInit() {
    cameraController = Get.arguments['camera'];
    if (cameraController == null) {
      initializedCamera();
    }
    setFullScreen();
    super.onInit();
  }

  Future<bool> onWillPop() async {
    await setNormalScreen();
    Get.back();
    return true;
  }

  void onBack() async {
    await setNormalScreen();
    Get.back();
  }

  void initializedCamera({int lens = 0}) {
    cameraController = CameraController(cameras![lens], ResolutionPreset.max)
      ..initialize().then((value) {
        update();
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
    Get.toNamed(AppRoutes.imageDetail, arguments: {
      'file': file,
      'isCamera': true,
    });
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
