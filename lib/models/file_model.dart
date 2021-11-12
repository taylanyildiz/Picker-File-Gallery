import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:photo_manager/photo_manager.dart';

class FileModel {
  FileModel({
    this.id,
    this.file,
    this.path,
    this.thumbData,
    this.extention,
    this.type,
    this.duration,
    this.isSelected = false,
    this.size,
  });
  String? id;
  String? path;
  File? file;
  Uint8List? thumbData;
  String? extention;
  AssetType? type;
  Duration? duration;
  bool isSelected;
  Size? size;
}
