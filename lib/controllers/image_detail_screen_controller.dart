import 'dart:developer';
import 'dart:io';
import 'package:bottom_sheet_picker/controllers/controllers.dart';
import 'package:bottom_sheet_picker/models/file_model.dart';
import 'package:photo_manager/photo_manager.dart';

import '/enums/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_crop/image_crop.dart';
import '/main.dart';

class ImageDetailScreenController extends GetxController {
  /// All Image files
  late List<FileModel> fileModels;

  /// Image detail file.
  late FileModel fileModel;

  late FileModel selectedFileModel;

  /// Initialized from camera.
  /// default [false]
  late bool isCamera;

  // Crop key.
  final cropKey = GlobalKey<CropState>();

  /// Page controller for gesture files.
  late PageController imageFileController;

  /// Bottom file list view controller.
  late PageController imageThumController;

  /// Image detail mode.
  EImageDetailMode imageMode = EImageDetailMode.gesture;

  /// Selected file index.
  int selectIndex = 0;

  @override
  void onInit() async {
    getArguments();
    initializePageControllers();
    await setNormalScreen();
    super.onInit();
  }

  void getArguments() {
    isCamera = Get.arguments['isCamera'] ?? false;
    fileModel = Get.arguments['file_model'];
    fileModels = Get.arguments['file_models'] ?? [fileModel];
    selectIndex = fileModels.indexWhere((e) => e.id == fileModel.id);
    selectedFileModel = fileModel;
  }

  void initializePageControllers() {
    imageThumController = PageController(
      initialPage: selectIndex,
      viewportFraction: .15,
      keepPage: false,
    );
    imageFileController = PageController(initialPage: selectIndex)
      ..addListener(_listenPageController);
  }

  void _listenPageController() async {
    if (!isCamera) {
      if (imageFileController.position.atEdge) {
        if (imageFileController.position.pixels == 0) {
          // top
          log('start');
        } else {
          await getImageFiles();
          log('end');
        }
      }
    }
  }

  Future<void> getImageFiles() async {
    final _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.isAuth) {
      fileModels = await GalleryPickerController.getImageFiles(fileModels);
      update();
    } else {
      await getImageFiles();
    }
  }

  void setCropEnable() {
    if (imageMode != EImageDetailMode.edit) {
      imageMode = EImageDetailMode.edit;
      update();
    }
  }

  Future<void> setScreen() async {
    if (isCamera) {
      setFullScreen();
      return;
    }
    await setNormalScreen();
  }

  Future<bool> onWillPop() async {
    await setScreen();
    Get.back();
    return true;
  }

  void onPageChangeFile(int index) {
    changePage(index);
    imageThumController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  void onPageChangeThumb(int index) {
    changePage(index);
    imageFileController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  void changePage(int page) {
    selectIndex = page;
    selectedFileModel = fileModels[page];
  }

  void selectImage(int index) {
    selectedFileModel = fileModels[index];
    imageFileController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
    update();
  }

  void onCancelOrBack() async {
    if (imageMode == EImageDetailMode.gesture) {
      await setScreen();
      Get.back();
      return;
    }
    imageMode = EImageDetailMode.gesture;
    changePage(selectIndex);
    update();
  }

  Future<void> cropOrSelectImage() async {
    if (imageMode == EImageDetailMode.edit) {
      // TODO: Select image file
      return;
    }
    await cropImage();
  }

  Future<void> cropImage() async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) return null;

    final sample = await ImageCrop.sampleImage(
      file: selectedFileModel.file!,
      preferredSize: (2000 / scale).round(),
    );

    final cropFile = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );
  }
}
