import 'dart:developer' as console;
import 'dart:math';
import '/controllers/controllers.dart';
import '/models/file_model.dart';
import '/routers/app_routers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GalleryPickerScreenController extends GetxController {
  /// Scroll Controller.
  final scrollController = ScrollController();

  List<FileModel> files = [];

  List<FileModel> selectedFile = [];

  @override
  void onInit() async {
    await getFiles();
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  void _scrollListener() async {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels == 0) {
        console.log('ListView scroll at top');
      } else {
        console.log('ListView scroll at bottom');
        try {
          await getFiles();
        } catch (e) {
          console.log('No More Document');
        }
      }
    }
  }

  Future<void> getFiles() async {
    files = await GalleryPickerController.getFileFromGallery(files);
    update();
  }

  void pickFiles(List<FileModel> fileModels) {
    selectedFile = fileModels;
    update();
  }

  void selectFiles() {
    log(selectedFile.length);
  }

  void onDetail(FileModel fileModel) {
    Get.toNamed(AppRoutes.galleryDetail, arguments: {
      'file_model': fileModel,
      'file_models': files,
    });
  }
}
