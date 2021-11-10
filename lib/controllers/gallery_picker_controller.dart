import 'dart:io';
import '/models/file_model.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPickerController {
  GalleryPickerController._();

  static Future<List<FileModel>> getFileFromGallery(
      List<FileModel> list) async {
    List<AssetEntity> assetList = await _getAssetList(RequestType.all, list);
    List<FileModel> allFiles = await _getModelList(assetList);
    list.addAll(allFiles);
    return list;
  }

  /// Get type [image] files.
  static Future<List<FileModel>> getImageFiles(List<FileModel> list) async {
    List<AssetEntity> assetList = await _getAssetList(
      RequestType.image,
      list,
    );
    List<FileModel> fileList = await _getModelList(assetList);
    list.addAll(fileList);
    return list;
  }

  /// Get type [video] type.
  static Future<List<FileModel>> getVideoFiles(List<FileModel> list) async {
    List<AssetEntity> assetList = await _getAssetList(
      RequestType.video,
      list,
    );
    List<FileModel> fileList = await _getModelList(assetList);
    list.addAll(fileList);
    return list;
  }

  static Future<List<AssetEntity>> _getAssetList(
      RequestType type, List list) async {
    List<AssetEntity> assetList = [];
    List<AssetPathEntity> _list = await PhotoManager.getAssetPathList(
      type: type,
      onlyAll: true,
      hasAll: true,
    );
    for (AssetPathEntity path in _list) {
      assetList.addAll(await path.getAssetListRange(
        start: list.length,
        end: list.length + 20,
      ));
    }
    return assetList;
  }

  static Future<List<FileModel>> _getModelList(List<AssetEntity> entity) async {
    List<FileModel> modelList = [];
    if (entity.isNotEmpty) {
      for (var file in entity) {
        final assetFile = await file.originFile;
        final size = file.size;
        if (assetFile != null) {
          final fileModel = FileModel(
            file: assetFile,
            path: assetFile.path,
            extention: file.mimeType!.split('/')[1],
            type: file.type,
            duration: file.videoDuration,
            size: size,
          );
          modelList.add(fileModel);
        }
      }
    }
    return modelList;
  }
}
