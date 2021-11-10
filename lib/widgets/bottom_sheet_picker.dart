import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

/// Position of bottom sheet.
SnappingPosition _lower = const SnappingPosition.factor(
  positionFactor: -.5,
  snappingCurve: Curves.linear,
  snappingDuration: Duration(milliseconds: 400),
  grabbingContentOffset: GrabbingContentOffset.top,
);

SnappingPosition _half = const SnappingPosition.factor(
  positionFactor: .5,
  snappingCurve: Curves.linear,
  snappingDuration: Duration(milliseconds: 400),
  grabbingContentOffset: GrabbingContentOffset.top,
);

SnappingPosition _full = const SnappingPosition.factor(
  positionFactor: 0.93,
  snappingCurve: Curves.linear,
  snappingDuration: Duration(milliseconds: 400),
);

class BottomSheetPicker extends StatefulWidget {
  const BottomSheetPicker({
    Key? key,
    required this.controller,
    required this.body,
    required this.bottomNavigation,
    required this.sheetBody,
    required this.onSheetMoved,
    required this.onSnapCompleted,
    this.title,
    this.leading,
    this.barDecoration,
    this.grabbingHeight = 20.0,
  }) : super(key: key);

  final BottomSheetController controller;
  final Widget body;
  final Function(double data) onSnapCompleted;
  final Function(double data) onSheetMoved;
  final Widget sheetBody;
  final double grabbingHeight;
  final BoxDecoration? barDecoration;
  final Widget? title;
  final Widget? leading;
  final Widget? bottomNavigation;

  @override
  State<BottomSheetPicker> createState() => _BottomSheetPickerState();
}

class _BottomSheetPickerState extends State<BottomSheetPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> headerAnim;
  late Animation<double> barAnim;
  late SnappingSheetController sheetController;

  bool isSheetFullScreen = true;
  double sheetOldData = 0.0;

  bool isBottomSheetShow = true;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });
    headerAnim = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, .6),
      reverseCurve: const Interval(0.2, 1.0),
    );
    barAnim = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0),
      reverseCurve: const Interval(0.0, 0.5),
    );
    sheetController = SnappingSheetController();

    widget.controller._addListener(
      () {
        sheetController.snapToPosition(_half);
      },
      onBack,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onSheetMoved(double data) async {
    if (isSheetFullScreen) {
      if (data >= 0.85 && data <= 0.93) {
        print(sheetOldData);
        if (data >= sheetOldData) {
          //up
          controller.forward();
        } else {
          // down
          controller.reverse();
        }
        sheetOldData = data;
      }
    }
  }

  void onBack() {
    isSheetFullScreen = false;
    controller.reverse();
    sheetController.snapToPosition(_lower);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildSnapSheet,
        buildAppBar,
      ],
    );
  }

  Widget get buildAppBar {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: Opacity(
        opacity: barAnim.value,
        child: SizedBox(
          height: 60.0,
          width: double.infinity,
          child: Container(
            decoration: widget.barDecoration ??
                const BoxDecoration(
                  color: Colors.orange,
                ),
            child: Row(
              children: [
                widget.leading ??
                    IconButton(
                      onPressed: onBack,
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      color: Colors.black,
                    ),
                const SizedBox(width: 10.0),
                widget.title ?? const SizedBox(width: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get buildSnapSheet {
    return SnappingSheet(
      controller: sheetController,
      onSheetMoved: (data) {
        onSheetMoved(data.relativeToSheetHeight);
        widget.onSheetMoved.call(data.relativeToSheetHeight);
        if (data.relativeToSheetHeight < 0.4) {
          isBottomSheetShow = false;
          isSheetFullScreen = true;
        } else {
          isBottomSheetShow = true;
        }
        setState(() {});
      },
      onSnapCompleted: (data, position) {
        widget.onSnapCompleted.call(data.relativeToSheetHeight);
      },
      onSnapStart: (data, position) {},
      child: GestureDetector(
        onTap: () => sheetController.snapToPosition(_lower),
        child: widget.body,
      ),
      grabbingHeight: widget.grabbingHeight,
      grabbing: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..scale(1.0 + 2.0 * headerAnim.value),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 1-headerAnim.value,
                child: Container(
                  width: 100.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      lockOverflowDrag: true,
      sheetBelow: SnappingSheetContent(
        child: Column(
          children: [
            Expanded(
              child: widget.sheetBody,
            ),
            Visibility(
              visible: isBottomSheetShow,
              child: widget.bottomNavigation!,
            )
          ],
        ),
        draggable: true,
      ),
      snappingPositions: [_lower, _half, _full],
    );
  }
}

class BottomSheetController {
  late Function() _show;
  late Function() _close;
  void _addListener(Function() _show, Function() _close) {
    this._show = _show;
    this._close = _close;
  }

  void close() => _close();
  void show() => _show();
}
