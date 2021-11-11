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

  /// Save image file
  static Future<FileModel?> saveImage(File file) async {
    AssetEntity? assetEntity = await PhotoManager.editor.saveImageWithPath(
      file.path,
    );
    if (assetEntity != null) {
      return await _getFileModel(assetEntity);
    }
  }

  /// Save video file
  static Future<FileModel?> saveVideo(File file) async {
    AssetEntity? assetEntity = await PhotoManager.editor.saveVideo(file);
    if (assetEntity != null) {
      return await _getFileModel(assetEntity);
    }
  }

  static Future<FileModel?> _getFileModel(AssetEntity assetEntity) async {
    final id = assetEntity.id;
    final assetFile = await assetEntity.originFile;
    final thumbData = await assetEntity.thumbData;
    final size = assetEntity.size;
    final extention = assetEntity.mimeType?.split('/')[1] ?? '';
    final type = assetEntity.type;
    final videoDuration = assetEntity.videoDuration;
    if (assetFile != null) {
      final fileModel = FileModel(
        id: id,
        file: assetFile,
        path: assetFile.path,
        thumbData: thumbData,
        extention: extention,
        type: type,
        duration: videoDuration,
        size: size,
      );
      return fileModel;
    }
  }

  static Future<List<AssetEntity>> _getAssetList(
      RequestType type, List list) async {
    List<AssetEntity> assetList = [];
    List<AssetPathEntity> _list = await PhotoManager.getAssetPathList(
      type: type,
      hasAll: true,
      onlyAll: true,
      filterOption: FilterOptionGroup(
        orders: [const OrderOption(asc: true)],
      ),
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
        final fileModel = await _getFileModel(file);
        if (fileModel != null) {
          modelList.add(fileModel);
        }
      }
    }
    return modelList;
  }
}
