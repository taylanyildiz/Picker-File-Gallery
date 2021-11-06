import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

class FileModel {
  FileModel({
    required this.file,
    required this.path,
    required this.extention,
    required this.type,
    required this.duration,
  });

  String? path;
  File? file;
  String? extention;
  AssetType? type;
  Duration? duration;
}
