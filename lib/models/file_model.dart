import 'dart:io';
import 'dart:ui';
import 'package:photo_manager/photo_manager.dart';

class FileModel {
  FileModel({
    required this.id,
    required this.file,
    required this.path,
    required this.extention,
    required this.type,
    required this.duration,
    this.isSelected = false,
    this.size,
  });
  String id;
  String? path;
  File? file;
  String? extention;
  AssetType? type;
  Duration? duration;
  bool isSelected;
  Size? size;
}
