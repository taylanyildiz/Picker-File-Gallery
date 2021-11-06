import 'dart:io';
import '/models/file_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PickImageBox extends StatefulWidget {
  const PickImageBox({
    Key? key,
    required this.scrollController,
    required this.cameraController,
    required this.onCamera,
    required this.onFile,
    required this.files,
    required this.scale,
    this.pickFile,
    this.pickMultiFile,
    this.multiSelectionEnable = false,
  })  : assert(
          pickFile == null || pickMultiFile == null,
          'Function cannot be null pickFile and pickMultiFile',
        ),
        assert(
          multiSelectionEnable == true || pickFile != null,
          'If want a pick file use pickFile function',
        ),
        assert(
          multiSelectionEnable == false || pickMultiFile != null,
          'If want multi file selection use pickMultiFile function',
        ),
        super(key: key);
  final ScrollController scrollController;
  final CameraController cameraController;
  final Function() onCamera;
  final Function(File file) onFile;
  final Function(File file)? pickFile;
  final Function(List<File> files)? pickMultiFile;
  final List<FileModel> files;
  final double scale;
  final bool multiSelectionEnable;

  @override
  State<PickImageBox> createState() => _PickImageBoxState();
}

class _PickImageBoxState extends State<PickImageBox>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  bool multiSelection = false;
  List<bool> multiSelectedIndexList = [];
  int selectedFileIndex = -1;
  List<File> multiSelectedFile = [];

  @override
  void initState() {
    multiSelection = widget.multiSelectionEnable;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PickImageBox oldWidget) {
    if (oldWidget.multiSelectionEnable != widget.multiSelectionEnable) {
      multiSelection = widget.multiSelectionEnable;
      setState(() {});
    }
    if (oldWidget.files.length != widget.files.length) {
      multiSelectedIndexList =
          List.generate(widget.files.length, (index) => false);
    }
    selectedFileIndex = -1;
    super.didUpdateWidget(oldWidget);
  }

  void removedFile(int index) {
    final removeIndex = multiSelectedFile
        .indexWhere((element) => element.path == widget.files[index].path);
    if (removeIndex != -1) {
      multiSelectedFile.removeAt(removeIndex);
    }
  }

  void selectSingleImage(int index) async {
    if (controller.isCompleted) {
      controller.reset();
      removedFile(index);
    }
    if (index == selectedFileIndex) {
      selectedFileIndex = -1;
      setState(() {});
    } else {
      selectedFileIndex = index;
      await controller.forward();
      multiSelectedFile.add(widget.files[index].file!);
      widget.pickFile!.call(widget.files[index].file!);
    }
  }

  void selectMultiImage(int index) async {
    if (controller.isCompleted) {
      controller.reset();
    }
    if (multiSelectedIndexList[index]) {
      multiSelectedIndexList[index] = false;
      selectedFileIndex = -1;
      removedFile(index);
      controller.reset();
    } else {
      selectedFileIndex = index;
      multiSelectedIndexList[index] = !multiSelectedIndexList[index];
      multiSelectedFile.add(widget.files[index].file!);
      await controller.forward();
    }
    widget.pickMultiFile!.call(multiSelectedFile);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: widget.files.length + 1,
      itemBuilder: (context, index) {
        return Hero(
          tag: '$index-camera',
          child: Container(
            color: Colors.transparent,
            margin: const EdgeInsets.only(left: 10.0),
            height: double.infinity,
            width: 150.0,
            child: (() {
              if (index == 0) {
                return camera(context);
              } else {
                return images(widget.files[index - 1], index - 1);
              }
            }()),
          ),
        );
      },
    );
  }

  Widget camera(context) {
    return GestureDetector(
      onTap: widget.onCamera,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.transparent,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(),
              Transform.scale(
                scale: widget.scale,
                child: CameraPreview(widget.cameraController),
              ),
              const Icon(
                FontAwesomeIcons.camera,
                color: Colors.grey,
                size: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget images(FileModel file, index) {
    return GestureDetector(
      onTap: () => widget.onFile.call(file.file!),
      onLongPress: () {
        /// Todo
        /// ** Multi Selection enable true.
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              Image.file(
                file.file!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              // buildSelectedFilter(index),
              buildSelectBox(index),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildSelectedFilter(index) {
  //   if (multiSelection && multiSelectedIndexList[index]) {
  //     return Center(
  //       child: ClipRect(
  //         child: BackdropFilter(
  //           filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
  //           child: Container(
  //             color: Colors.black.withOpacity(.4),
  //             child: Center(
  //               child: Text(
  //                 (multiSelectedIndexList.indexWhere((element) => element) + 1)
  //                     .toString(),
  //                 style: const TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 15.0,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     return const SizedBox.shrink();
  //   }
  // }

  Positioned buildSelectBox(index) {
    return Positioned(
      top: 10.0,
      right: 10.0,
      child: widget.multiSelectionEnable
          ? buildMultiSelectionBox(index)
          : singleSelectionBox(index),
    );
  }

  Widget buildMultiSelectionBox(index) {
    return GestureDetector(
      onTap: () => selectMultiImage(index),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 1.0,
                color: Colors.white,
              ),
            ),
          ),
          buildMultiSelectedBox(index),
        ],
      ),
    );
  }

  Widget singleSelectionBox(index) {
    return GestureDetector(
      onTap: () => selectSingleImage(index),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 1.0,
                color: Colors.white,
              ),
              color: Colors.transparent,
            ),
          ),
          buildSingleSelectedBox(index)
        ],
      ),
    );
  }

  Widget buildSingleSelectedBox(int index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(
              index == selectedFileIndex ? controller.value : 0.0,
              index == selectedFileIndex ? controller.value : 0.0,
            ),
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 1.0,
                color: Colors.blue,
              ),
              color: Colors.blue,
            ),
            child: const Center(
              child: Icon(
                Icons.done,
                color: Colors.white,
                size: 15.0,
              ),
            ),
          ),
        );
      },
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
              selectedFileIndex == index
                  ? controller.value
                  : multiSelectedIndexList[index]
                      ? 1.0
                      : 0.0,
              selectedFileIndex == index
                  ? controller.value
                  : multiSelectedIndexList[index]
                      ? 1.0
                      : 0.0,
            ),
          child: child,
        );
      },
      child: Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 1.0,
            color: Colors.blue,
          ),
          color: Colors.blue,
        ),
        child: const Center(
          child: Icon(
            Icons.done,
            color: Colors.white,
            size: 15.0,
          ),
        ),
      ),
    );
  }
}
