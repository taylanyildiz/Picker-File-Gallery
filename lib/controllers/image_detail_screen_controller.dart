import 'dart:io';
import 'package:bottom_sheet_picker/models/file_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '/main.dart';

class ImageDetailScreenController extends GetxController {
  /// Image file.
  File? file;

  /// File model from gallery.
  FileModel? fileModel;

  /// Initialized from camera.
  /// default [false]
  late bool isCamera;

  // Crop key.
  final cropKey = GlobalKey<CropState>();

  @override
  void onInit() async {
    file = Get.arguments['file'];
    fileModel = Get.arguments['file_model'];
    isCamera = Get.arguments['isCamera'] ?? false;
    file ??= fileModel!.file;
    await setNormalScreen();
    super.onInit();
  }

  void setCropEnable() {
    update();
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

  void onBack() async {
    await setScreen();
    Get.back();
  }

  double? get aspectRatio {
    double scale = 1.0;
    if (fileModel == null) return null;
    scale = fileModel!.size!.aspectRatio;
    return scale;
  }

  Future<void> cropImage() async {}
}
