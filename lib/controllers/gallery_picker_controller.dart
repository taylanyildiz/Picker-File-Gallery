import 'dart:io';
import 'package:bottom_sheet_picker/models/file_model.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPickerController {
  GalleryPickerController._();

  /// Asset list. [AssetEntity].
  static List<AssetEntity> assetList = [];

  /// Gallery file asset list.[File].
  static List<FileModel> allTypeFiles = [];

  /// Gallery file asset image.
  static List<FileModel> imageTypeFiles = [];

  /// Gallery file asset video.
  static List<FileModel> videTypeFiles = [];

  static Future<List<FileModel>> getFileFromGallery() async {
    allTypeFiles.clear();
    assetList.clear();

    await PhotoManager.clearFileCache();
    PhotoManager.notifyingOfChange = true;
    List<AssetPathEntity> list = await PhotoManager.getAssetPathList(
      type: RequestType.all,
      onlyAll: true,
      hasAll: true,
    );
    for (AssetPathEntity path in list) {
      assetList.addAll(await path.getAssetListRange(
        start: 0,
        end: path.assetCount,
      ));
    }
    if (assetList.isNotEmpty) {
      for (var file in assetList) {
        await file.refreshProperties();
        final assetFile = await file.originFile;
        if (assetFile != null) {
          final fileModel = FileModel(
            file: assetFile,
            path: assetFile.path,
            extention: file.mimeType!.split('/')[1],
            type: file.type,
            duration: file.videoDuration,
          );
          allTypeFiles.add(fileModel);
        }
      }
    }
    return allTypeFiles;
  }

  /// Get type [image] files.
  static Future<List<FileModel>> getImageFiles() async {
    await getFileFromGallery();
    Iterable<FileModel> filterImage = allTypeFiles.where((file) {
      return file.type == AssetType.image;
    });
    return filterImage.toList();
  }

  /// Get type [video] type.
  static List<FileModel> getVideoFiles() {
    Iterable<FileModel> filterVideo = allTypeFiles.where((file) {
      return file.type == AssetType.video;
    });
    return filterVideo.toList();
  }
}
