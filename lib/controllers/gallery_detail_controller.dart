import 'dart:async';
import 'dart:developer';
import 'package:bottom_sheet_picker/dialogs/circular_process_dialog.dart';

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

const ffmegCommand =
    '-vf "fps=10,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0';

class GalleryDetailController extends GetxController {
  /// All Image files
  List<FileModel> fileModels = [];

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
  PageController? pageFileController;

  /// Bottom file list view controller.
  PageController? pageThumbController;

  /// Image detail mode.
  EFileDetailMode fileDetailMode = EFileDetailMode.gesture;

  /// Selected file index.
  int selectIndex = 0;

  @override
  void onInit() {
    getArguments();
    initializePageControllers();
    setNormalScreen();
    super.onInit();
  }

  Future<bool> onWillPop() async {
    if (isCamera) {
      setFullScreen();
    } else {
      await setNormalScreen();
    }
    return true;
  }

  void onBack() async {
    if (isCamera) {
      setFullScreen();
    } else {
      await setNormalScreen();
    }
    Get.back();
  }

  Future<void> getArguments() async {
    isCamera = Get.arguments['isCamera'] ?? false;
    fileModel = Get.arguments['file_model'];
    fileModels = Get.arguments['file_models'] ?? [fileModel];
    selectIndex = fileModels.indexWhere((e) => e.id == fileModel.id);
    selectedFileModel = fileModel;
    if (!isCamera && selectIndex == fileModels.length - 1) {
      await getFiles();
    }
  }

  void initializePageControllers() {
    pageThumbController = PageController(
      initialPage: selectIndex,
      viewportFraction: .15,
      keepPage: false,
    );
    pageFileController = PageController(
      initialPage: selectIndex,
      keepPage: false,
    )..addListener(_listenPageController);
    update();
  }

  void _listenPageController() async {
    if (!isCamera) {
      if (pageFileController!.position.atEdge) {
        if (pageFileController!.position.pixels == 0) {
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
    pageThumbController!.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  void onPageChangeThumb(int index) {
    changePage(index);
    pageFileController!.jumpToPage(index);
  }

  void changePage(int page) {
    selectIndex = page;
    selectedFileModel = fileModels[page];
  }

  void selectThumbFile(int index) {
    selectedFileModel = fileModels[index];
    pageFileController!.jumpToPage(index);
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

  Future<void> cropImage(GlobalKey<CropState> cropKey) async {
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

  Future<void> trimVideo(Trimmer trimmer, double start, double end) async {
    Get.dialog(const CircularProcessDialog(), barrierDismissible: false);
    final path = await trimmer.saveTrimmedVideo(
      applyVideoEncoding: true,
      startValue: start,
      endValue: end,
      ffmpegCommand: ffmegCommand,
      customVideoFormat: '.mp4',
    );
    Get.back();
    Get.to(() => VideoDetailScreen(path: path));
  }
}
