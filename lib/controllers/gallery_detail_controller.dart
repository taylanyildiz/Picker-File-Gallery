import 'dart:async';
import 'dart:developer';
import '/screens/screens.dart';
import 'package:video_trimmer/video_trimmer.dart';
import '/controllers/controllers.dart';
import '/models/file_model.dart';
import 'package:photo_manager/photo_manager.dart';
import '/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_crop/image_crop.dart';
import '/main.dart';

class GalleryDetailController extends GetxController {
  /// All Image files
  late List<FileModel> fileModels;

  /// Image detail file.
  late FileModel fileModel;

  /// Selected file model
  late FileModel selectedFileModel;

  /// Initialized from camera.
  /// default [false]
  late bool isCamera;

  /// Trimmer video.
  final trimmer = Trimmer();

  /// Page controller for gesture files.
  late PageController pageFileController;

  /// Bottom file list view controller.
  late PageController pageThumbController;

  /// Image detail mode.
  EFileDetailMode fileDetailMode = EFileDetailMode.gesture;

  /// Selected file index.
  int selectIndex = 0;

  @override
  void onInit() async {
    getArguments();
    initializePageControllers();
    await setNormalScreen();
    super.onInit();
  }

  Future<bool> onWillPop() async {
    await setScreen();
    Get.back();
    return true;
  }

  void onCancel() async {
    switch (fileDetailMode) {
      case EFileDetailMode.gesture:
        if (isCamera) {
          setFullScreen();
        } else {
          await setNormalScreen();
        }
        Get.back();
        return;
      default:
        fileDetailMode = EFileDetailMode.gesture;
        update();
        break;
    }
  }

  void getArguments() async {
    isCamera = Get.arguments['isCamera'] ?? false;
    fileModel = Get.arguments['file_model'];
    fileModels = Get.arguments['file_models'] ?? [fileModel];
    selectIndex = fileModels.indexWhere((e) => e.id == fileModel.id);
    selectedFileModel = fileModel;
    if (!isCamera && selectIndex == fileModels.length - 1) {
      getFiles();
    }
    if (selectedFileModel.type == AssetType.video && isCamera) {
      fileDetailMode = EFileDetailMode.videoEdit;
    }
  }

  void initializePageControllers() {
    pageThumbController = PageController(
      initialPage: selectIndex,
      viewportFraction: .15,
      keepPage: false,
    );
    pageFileController = PageController(initialPage: selectIndex)
      ..addListener(_listenPageController);
  }

  void _listenPageController() async {
    if (!isCamera) {
      if (pageFileController.position.atEdge) {
        if (pageFileController.position.pixels == 0) {
          // top
          log('start');
        } else {
          await getFiles();
          log('end');
        }
      }
    }
  }

  Future<void> getFiles() async {
    final _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.isAuth) {
      fileModels = await GalleryPickerController.getFileFromGallery(fileModels);
      update();
    } else {
      await getFiles();
    }
  }

  void editFile() async {
    switch (selectedFileModel.type) {
      case AssetType.image:
        Get.to(() => ImageCropperScreeen(fileModel: selectedFileModel));
        break;
      case AssetType.video:
        Get.to(() => VideoTrimmerScreen(fileModel: selectedFileModel));
        break;
      case AssetType.audio:
        break;
      default:
        break;
    }
  }

  Future<void> setScreen() async {
    if (isCamera) {
      setFullScreen();
      return;
    }
    await setNormalScreen();
  }

  void onPageChangeFile(int index) {
    changePage(index);
    pageThumbController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  void onPageChangeThumb(int index) {
    changePage(index);
    pageFileController.jumpToPage(index);
  }

  void changePage(int page) {
    selectIndex = page;
    selectedFileModel = fileModels[page];
  }

  void selectThumbFile(int index) {
    selectedFileModel = fileModels[index];
    pageFileController.jumpToPage(index);
  }

  void selectFile() {
    switch (selectedFileModel.type) {
      case AssetType.image:
        Get.to(() => ImageScreen(file: fileModel.file!));
        break;
      case AssetType.video:
        break;
      case AssetType.audio:
        break;
      default:
        break;
    }
  }

  Future<void> cropImage(cropKey) async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) return;

    final sample = await ImageCrop.sampleImage(
      file: selectedFileModel.file!,
      preferredSize: (2000 / scale).round(),
    );

    final cropFile = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );
    Get.to(() => ImageScreen(file: cropFile));
  }

  Future<void> trimVideo(trimmer) async {}
}
