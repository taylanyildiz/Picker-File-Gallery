import 'dart:developer' as console;
import 'package:bottom_sheet_picker/controllers/controllers.dart';
import 'package:bottom_sheet_picker/models/file_model.dart';
import 'package:bottom_sheet_picker/routers/app_routers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPickerScreenController extends GetxController {
  /// Scroll Controller.
  final scrollController = ScrollController();

  List<FileModel> files = [];

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

  void onDetail(FileModel fileModel) {
    if (fileModel.type == AssetType.image) {
      final imageFiles = files.where((e) => e.type == AssetType.image).toList();
      Get.toNamed(AppRoutes.imageDetail, arguments: {
        'file_model': fileModel,
        'file_models': imageFiles,
      });
    } else if (fileModel.type == AssetType.video) {
      final videoFiles = files.where((e) => e.type == AssetType.video).toList();
    } else {
      // TODO: AUDIO handler
    }
  }
}
