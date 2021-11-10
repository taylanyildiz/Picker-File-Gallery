import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:photo_manager/photo_manager.dart';

import '/controllers/controllers.dart';
import '/widgets/widgets.dart';
import '/routers/app_routers.dart';
import '/main.dart';
import '/models/file_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  /// Camera controller.
  CameraController? cameraController;

  /// Image files
  List<FileModel> imageFiles = [];

  /// Controller of list.
  late ScrollController scrollController;

  /// CameraController is dispose check
  bool isCameraDispose = true;

  ScrollPhysics? gridViewPhysics = const NeverScrollableScrollPhysics();

  BottomSheetController sheetController = BottomSheetController();

  @override
  void onInit() async {
    scrollController = ScrollController(initialScrollOffset: 0.0)
      ..addListener(_scrollListen);
    super.onInit();
  }

  @override
  void dispose() {
    cameraController!.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListen() async {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels == 0) {
        log('Scroll at top');
      } else {
        log('Scroll at bottom');
        try {
          // Get files.
          await getImageFiles();
        } catch (e) {
          log('No more document');
        }
      }
    }
  }

  Future<void> getImageFiles() async {
    imageFiles = await GalleryPickerController.getImageFiles(imageFiles);
    update();
  }

  bool onNotification(scrollState) {
    if (scrollState is ScrollEndNotification) {
      if (scrollState.metrics.pixels == 0.0) {
        gridViewPhysics = const NeverScrollableScrollPhysics();
        update();
      }
    }
    return true;
  }

  void initializedCamera({int lens = 0}) {
    cameraController = CameraController(cameras![lens], ResolutionPreset.max)
      ..initialize().then((value) {
        update();
        return;
      }).onError((error, stackTrace) {
        log('CAMERA ERROR :\n' + error.toString());
      });
  }

  void onSnapCompleted(double data) async {
    if (data <= 0.0) {
      isCameraDispose = true;
      cameraController!.dispose();
      gridViewPhysics = const NeverScrollableScrollPhysics();
    } else if (data > 0.0 && data <= .52) {
      gridViewPhysics = const NeverScrollableScrollPhysics();
      if (isCameraDispose == true) {
        isCameraDispose = false;
        initializedCamera();
        await getImageFiles();
      }
    } else if (data < .93 && data > 0.5) {
      gridViewPhysics = const NeverScrollableScrollPhysics();
    } else if (data >= .93) {
      gridViewPhysics = const AlwaysScrollableScrollPhysics();
    }
    update();
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

  void openCamera() {
    Get.toNamed(AppRoutes.camera, arguments: {'camera': cameraController});
    // sheetController.close();
  }

  void openImageFile(File file) async {
    Get.toNamed(AppRoutes.sendImage, arguments: file);
  }

  void getFileFromGallery() {
    Get.toNamed(AppRoutes.galleryPicker);
  }
}
