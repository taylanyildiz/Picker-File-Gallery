import 'package:bottom_sheet_picker/utils/utils.dart';
import 'package:camera/camera.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/models/file_model.dart';
import 'package:flutter/material.dart';

class ImagePicker extends StatefulWidget {
  const ImagePicker({
    Key? key,
    required this.pickerController,
    required this.cameraController,
    required this.scrollController,
    required this.cameraScale,
    required this.onCamera,
    required this.files,
    required this.onDetail,
    required this.pickFiles,
    this.maxSelect = 4,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.onNotification,
    this.isCameraDispose = false,
  }) : super(key: key);

  final ImagePickerController pickerController;
  final CameraController? cameraController;
  final ScrollController scrollController;
  final List<FileModel> files;
  final Function(FileModel file) onDetail;
  final Function(List<FileModel> files) pickFiles;
  final Function() onCamera;
  final double cameraScale;
  final int maxSelect;
  final ScrollPhysics? physics;
  final bool Function(ScrollNotification notification)? onNotification;
  final bool isCameraDispose;

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  bool multiSelection = false;
  int selectedIndexFile = -1;
  List<FileModel> fileList = [];
  int selectedCount = 0;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {
        setState(() {});
      });

    widget.pickerController._addListener(clear: () {
      selectedCount = 0;
      fileList = [];
      selectedIndexFile = -1;
      multiSelection = false;
      widget.pickFiles.call([]);
      for (var element in widget.files) {
        element.isSelected = false;
      }
      controller.reset();
    });
    super.initState();
  }

  void removedFile(int index) {
    int removeIndex =
        fileList.indexWhere((e) => e.path == widget.files[index].path);
    if (removeIndex != -1) {
      fileList.removeAt(removeIndex);
    }
  }

  void onLongPress(index) {
    if (selectedCount == 0) {
      multiSelection = true;
      setState(() {});
      multiSelectFile(index);
    }
  }

  void multiSelectFile(index) {
    if (controller.isCompleted) {
      controller.reset();
    }
    if (widget.files[index].isSelected) {
      widget.files[index].isSelected = false;
      selectedCount--;
      selectedIndexFile = -1;
      removedFile(index);
      setState(() {});
    } else {
      if (selectedCount < widget.maxSelect) {
        selectedCount++;
        widget.files[index].isSelected = true;
        fileList.add(widget.files[index]);
        controller.forward();
        selectedIndexFile = index;
      } else {
        selectedIndexFile = -1;
        Utils.showSnackBar('Error', 'Only 4 files selection enable.');
      }
    }

    widget.pickFiles.call(fileList);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: widget.onNotification,
      child: GridView.builder(
        controller: widget.scrollController,
        physics: widget.physics,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
        ),
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: 10.0,
          bottom: 10.0,
        ),
        itemCount: widget.files.length + 1,
        itemBuilder: (context, index) {
          return Hero(
            tag: '$index-camera',
            child: ClipRRect(
              // borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: (() {
                  if (index == 0) {
                    return buildCamera;
                  } else {
                    return buildFiles(index - 1);
                  }
                }()),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget get buildCamera {
    return GestureDetector(
      onTap: widget.onCamera,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.cameraController != null && !widget.isCameraDispose
              ? Transform.scale(
                  scale: widget.cameraScale,
                  child: CameraPreview(widget.cameraController!),
                )
              : const SizedBox(),
          const Icon(
            FontAwesomeIcons.camera,
            color: Colors.white,
            size: 30.0,
          ),
        ],
      ),
    );
  }

  Widget buildFiles(index) {
    return GestureDetector(
      onTap: () {
        if (multiSelection && selectedCount != 0) {
          multiSelectFile(index);
        } else {
          widget.onDetail.call(widget.files[index]);
        }
      },
      onLongPress: () {
        onLongPress(index);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.image,
            color: Colors.black,
          ),
          Image.file(
            widget.files[index].file!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          selectedCount != 0 ? buildSelectionBox(index) : const SizedBox(),
        ],
      ),
    );
  }

  Widget buildSelectionBox(index) {
    return Positioned(
      top: 5.0,
      right: 5.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
          ),
          buildMultiSelectedBox(index),
        ],
      ),
    );
  }

  Widget buildMultiSelectedBox(index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(
              selectedIndexFile == index
                  ? controller.value
                  : widget.files[index].isSelected
                      ? 1.0
                      : 0.0,
            ),
          child: child,
        );
      },
      child: Container(
        height: 20.0,
        width: 20.0,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.done,
          color: Colors.white,
          size: 15.0,
        ),
      ),
    );
  }
}

class ImagePickerController {
  late Function() _clear;

  void _addListener({required Function() clear}) {
    _clear = clear;
  }

  void clear() => _clear();
}
