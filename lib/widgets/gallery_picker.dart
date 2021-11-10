import 'package:bottom_sheet_picker/models/file_model.dart';
import 'package:flutter/material.dart';

class GalleryPicker extends StatefulWidget {
  const GalleryPicker({
    Key? key,
    required this.files,
    required this.pickFiles,
    required this.scrollController,
    required this.onDetail,
    required this.child,
    this.maxSelect = 5,
  }) : super(key: key);

  final List<FileModel> files;
  final Function(List<FileModel> files) pickFiles;
  final Function(FileModel file) onDetail;
  final Widget Function(BuildContext context, int index) child;
  final ScrollController scrollController;
  final int maxSelect;

  @override
  State<GalleryPicker> createState() => _GalleryPickerState();
}

class _GalleryPickerState extends State<GalleryPicker>
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
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GalleryPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void removedFile(int index) {
    int removeIndex =
        fileList.indexWhere((e) => e.path == widget.files[index].path);
    if (removeIndex != -1) {
      fileList.removeAt(removeIndex);
    }
  }

  void onTap(index) {
    if (multiSelection) {
      multiSelectFile(index);
    }
  }

  void onLongPress(index) {
    if (selectedCount == 0) {
      multiSelection = true;
      setState(() {});
      onTap(index);
    }
  }

  void multiSelectFile(index) {
    if (controller.isCompleted) {
      controller.reset();
    }
    if (widget.files[index].isSelected) {
      selectedCount--;
      widget.files[index].isSelected = false;
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
      }
    }

    widget.pickFiles.call(fileList);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: GridView.builder(
          shrinkWrap: true,
          controller: widget.scrollController,
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 10.0),
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
        if (multiSelection && selectedCount != 0) {
          multiSelectFile(index);
        } else {
          widget.onDetail.call(widget.files[index]);
        }
      },
      onLongPress: () {
        onLongPress(index);
      },
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(5.0),
        child: Container(
          decoration: const BoxDecoration(
              // borderRadius: BorderRadius.circular(5.0),
              ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              buildChild(context, index),
              selectedCount != 0 ? buildSelectionBox(index) : const SizedBox(),
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
                  : widget.files[index].isSelected
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
            buildMultiSelectedBox(index),
          ],
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
                  : widget.files[index].isSelected
                      ? 1.0
                      : 0.0,
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
