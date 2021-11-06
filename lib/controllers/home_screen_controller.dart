import 'dart:async';
import 'dart:io';
import 'package:bottom_sheet_picker/routers/app_routers.dart';

import '/controllers/controllers.dart';
import 'package:bottom_sheet_picker/main.dart';
import '/models/file_model.dart';
import '/screens/screens.dart';
import 'package:camera/camera.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class HomeScreenController extends GetxController {
  /// Bottom sheet controller
  final bottomSheetController = SnappingSheetController();

  /// Camera controller.
  CameraController? cameraController;

  /// Screen pixel.
  double pixels = 0.0;

  /// Video timer.
  Timer? timer;

  /// Image files
  List<FileModel> imageFiles = [];

  /// Controller of list.
  late ScrollController scrollController;

  @override
  void onInit() async {
    cameraController = CameraController(cameras![0], ResolutionPreset.max);
    scrollController = ScrollController(initialScrollOffset: 0.0);
    update();
    super.onInit();
  }

  @override
  void dispose() {
    cameraController!.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void initializedCamera({int lens = 0}) {
    cameraController = CameraController(cameras![lens], ResolutionPreset.max)
      ..initialize().then((value) {
        update();
        return;
      });
  }

  Future<bool> onWillPop() async {
    Get.back();
    setScreenNormal();
    return true;
  }

  /// Position of bottom sheet.
  SnappingPosition lower = const SnappingPosition.factor(
    positionFactor: .0,
    snappingCurve: Curves.easeOutExpo,
    snappingDuration: Duration(milliseconds: 400),
    grabbingContentOffset: GrabbingContentOffset.top,
  );

  SnappingPosition half = const SnappingPosition.factor(
    positionFactor: .5,
    snappingCurve: Curves.easeOutExpo,
    snappingDuration: Duration(milliseconds: 400),
    grabbingContentOffset: GrabbingContentOffset.top,
  );

  void onSnapCompleted(data, position) async {
    scrollController.animateTo(
      0.0,
      duration: const Duration(microseconds: 1),
      curve: Curves.bounceOut,
    );
    if (data.pixels != 0) {
      if (pixels == 0) {
        pixels = data.pixels;
        imageFiles = await GalleryPickerController.getImageFiles();
        update();
        initializedCamera();
      }
    } else {
      pixels = 0.0;
      await cameraController!.dispose();
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

  double get middleScreenCameraScale {
    if (cameraController != null) {
      double aspectRatio = 1.0;
      if (cameraController!.value.previewSize != null) {
        aspectRatio = cameraController!.value.aspectRatio;
      }
      return 1 / (aspectRatio * .3);
    } else {
      return 1.0;
    }
  }

  Future<void> setScreenNormal() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom,
      SystemUiOverlay.top,
    ]);
  }

  void setScreenFull() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  void openCamera() {
    Get.to(() => const CameraScreen());
    setScreenFull();
  }

  void pickImageFile(File file) {}

  void openImageFile(File file) async {
    Get.toNamed(AppRoutes.sendImage, arguments: file);
  }

  void backFromCamera() async {
    await setScreenNormal();
    Get.back();
  }

  void setCameraLens() async {
    int lens = cameraController!.description.lensDirection.index;
    if (cameraController != null) {
      await cameraController!.dispose();
    }
    initializedCamera(lens: lens);
  }

  Future<void> takePhoto() async {
    if (!cameraController!.value.isRecordingVideo) {
      File file = File((await cameraController!.takePicture()).path);
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

  Future<void> getFileFromGallery() async {
    List<FileModel> file = await GalleryPickerController.getFileFromGallery();
    Get.toNamed(AppRoutes.galleryPicker, arguments: file);
  }
}
