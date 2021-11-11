import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:photo_manager/photo_manager.dart';

class FileModel {
  FileModel({
    required this.id,
    required this.file,
    required this.path,
    required this.thumbData,
    required this.extention,
    required this.type,
    required this.duration,
    this.isSelected = false,
    this.size,
  });
  String id;
  String? path;
  File? file;
  Uint8List? thumbData;
  String? extention;
  AssetType? type;
  Duration? duration;
  bool isSelected;
  Size? size;
}
