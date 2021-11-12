import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bottom_sheet_picker/enums/enums.dart';
import 'package:bottom_sheet_picker/utils/utils_enum.dart';
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
  List<FileModel> fileModels = [];

  /// Controller of list.
  late ScrollController scrollController;

  /// CameraController is dispose check
  bool isCameraDispose = true;

  ScrollPhysics? gridViewPhysics = const NeverScrollableScrollPhysics();

  /// Bottom sheet image picker controller.
  BottomSheetController sheetController = BottomSheetController();

  /// Image picker controller for clean all
  ImagePickerController pickerController = ImagePickerController();

  /// Selected images
  List selectedImages = <FileModel>[];

  @override
  void onInit() {
    scrollController = ScrollController(initialScrollOffset: 0.0)
      ..addListener(_scrollListen);
    super.onInit();
  }

  @override
  void dispose() async {
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
    final _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.isAuth) {
      fileModels = await GalleryPickerController.getFileFromGallery(fileModels);
      update();
    } else {
      await getImageFiles();
    }
  }

  bool onNotification(scrollState) {
    if (scrollState is ScrollEndNotification) {
      if (scrollState.metrics.pixels == 0.0) {
        gridViewPhysics = const NeverScrollableScrollPhysics();
        update();
      } else {
        gridViewPhysics = const AlwaysScrollableScrollPhysics();
        update();
      }
    }
    return true;
  }

  Future<void> initializedCamera({int lens = 0}) async {
    cameraController = CameraController(cameras![lens], ResolutionPreset.max);
    await cameraController!.initialize();
    update();
  }

  void onBottomNavigation(int index) {
    EBottomNavigationType type = UtilsEnum.indexToBottomNavigationType(index);
    sheetController.close();
    isCameraDispose = true;
    cameraController!.dispose();
    update();
    switch (type) {
      case EBottomNavigationType.gallery:
        Get.toNamed(AppRoutes.galleryPicker);
        break;
      case EBottomNavigationType.files:
        // TODO: Handle this case.
        break;
      case EBottomNavigationType.location:
        // TODO: Handle this case.
        break;
      case EBottomNavigationType.constacts:
        // TODO: Handle this case.
        break;
    }
  }

  void selectFiles() {
    print(selectedImages.length);
  }

  void onSnapCompleted(double data) async {
    if (data <= 0.0) {
      isCameraDispose = true;
      if (cameraController != null && cameraController!.value.isInitialized) {
        cameraController!.dispose();
      }
      gridViewPhysics = const NeverScrollableScrollPhysics();
    } else if (data > 0.0 && data <= .52) {
      gridViewPhysics = const NeverScrollableScrollPhysics();
      if (isCameraDispose == true) {
        isCameraDispose = false;
        scrollController.jumpTo(0.0);
        await initializedCamera();
        await getImageFiles();
      }
    } else if (data < .93 && data > 0.5) {
      gridViewPhysics = const NeverScrollableScrollPhysics();
    } else if (data >= .93) {
      gridViewPhysics = const AlwaysScrollableScrollPhysics();
    }
    update();
  }

  void onDetail(FileModel fileModel) {
    Get.toNamed(AppRoutes.galleryDetail, arguments: {
      'file_model': fileModel,
      'file_models': fileModels,
    });
  }

  void pickFile(List<FileModel> list) {
    if (selectedImages.isEmpty) {
      sheetController.displayFullScreen();
    }
    if (list.length != selectedImages.length) {
      selectedImages = list;
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

  void getFileFromGallery() {
    Get.toNamed(AppRoutes.galleryPicker);
  }
}
