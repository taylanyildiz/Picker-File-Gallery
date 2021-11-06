import 'dart:io';

import 'package:bottom_sheet_picker/models/file_model.dart';
import 'package:get/get.dart';

class GalleryPickerScreenController extends GetxController {
  /// [File] from gallery.
  late List<FileModel> files;

  @override
  void onInit() {
    files = Get.arguments;
    super.onInit();
  }
}
