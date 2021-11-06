import 'package:bottom_sheet_picker/models/file_model.dart';
import 'package:flutter/material.dart';

class GalleryPicker extends StatefulWidget {
  const GalleryPicker({
    Key? key,
    required this.files,
    required this.pickSingleFile,
    required this.pickMultiFile,
    required this.child,
  }) : super(key: key);

  final List<FileModel> files;
  final Function(FileModel file) pickSingleFile;
  final Function(List<FileModel> files) pickMultiFile;
  final Widget Function(BuildContext context, int index) child;

  @override
  State<GalleryPicker> createState() => _GalleryPickerState();
}

class _GalleryPickerState extends State<GalleryPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  bool multiSelection = false;
  int selectedIndexFile = -1;
  List<bool> multiSelectedList = [];
  List<FileModel> fileList = [];

  @override
  void initState() {
    multiSelectedList = List.generate(widget.files.length, (index) => false);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GalleryPicker oldWidget) {
    if (oldWidget.files.length != widget.files.length) {
      multiSelectedList = List.generate(widget.files.length, (index) => false);
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  void onTap(index) {
    if (multiSelection) {
      multiSelectFile(index);
    } else {
      singleSelectFile(index);
    }
  }

  void removedFile(int index) {
    int removeIndex =
        fileList.indexWhere((e) => e.path == widget.files[index].path);
    if (removeIndex != -1) {
      fileList.removeAt(removeIndex);
    }
  }

  void onLongPress(index) {
    multiSelection = true;
    setState(() {});
    onTap(index);
  }

  void singleSelectFile(index) async {
    if (controller.isCompleted) {
      controller.reset();
      removedFile(index);
      multiSelectedList[selectedIndexFile] = false;
    }
    if (selectedIndexFile == index) {
      selectedIndexFile = -1;
      setState(() {});
    } else {
      fileList.add(widget.files[index]);
      selectedIndexFile = index;
      multiSelectedList[index] = true;
      await controller.forward();
      widget.pickSingleFile.call(widget.files[index]);
    }
  }

  void multiSelectFile(index) {
    if (controller.isCompleted) {
      controller.reset();
    }
    if (multiSelectedList[index]) {
      multiSelectedList[index] = false;
      selectedIndexFile = -1;
      removedFile(index);
      setState(() {});
    } else {
      selectedIndexFile = index;
      multiSelectedList[index] = true;
      fileList.add(widget.files[index]);
      controller.forward();
    }
    widget.pickMultiFile.call(fileList);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(5.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemCount: widget.files.length,
          itemBuilder: itemBuilder,
        ),
      );
    });
  }

  Widget itemBuilder(context, index) {
    return GestureDetector(
      onTap: () {
        /// Todo
        /// To detail screen.
      },
      onLongPress: () {
        /// Todo
        /// Multi selection enable.[true].
        onLongPress(index);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              buildChild(context, index),
              buildSelectionBox(index),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChild(context, index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(
              selectedIndexFile == index
                  ? .9
                  : multiSelectedList[index]
                      ? .9
                      : 1.0,
              selectedIndexFile == index
                  ? .9
                  : multiSelectedList[index]
                      ? .9
                      : 1.0,
            ),
          child: child,
        );
      },
      child: widget.child(context, index),
    );
  }

  Widget buildSelectionBox(index) {
    return Positioned(
      top: 5.0,
      right: 5.0,
      child: GestureDetector(
        onTap: () => onTap(index),
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
            !multiSelection
                ? buildSingleSelectedBox(index)
                : buildMultiSelectedBox(index),
          ],
        ),
      ),
    );
  }

  Widget buildSingleSelectedBox(index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(
              selectedIndexFile == index ? controller.value : 0.0,
              selectedIndexFile == index ? controller.value : 0.0,
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
                  : multiSelectedList[index]
                      ? 1.0
                      : 0.0,
              selectedIndexFile == index
                  ? controller.value
                  : multiSelectedList[index]
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
