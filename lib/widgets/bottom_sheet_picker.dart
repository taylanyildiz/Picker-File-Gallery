import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    required this.sheetBody,
    required this.onSheetMoved,
    required this.onSnapCompleted,
    required this.onBottomNavigation,
    this.title,
    this.leading,
    this.actions,
    this.grabbingHeight = 20.0,
  }) : super(key: key);

  final BottomSheetController controller;
  final Widget body;
  final Function(double data) onSnapCompleted;
  final Function(double data) onSheetMoved;
  final Function(int index) onBottomNavigation;
  final Widget sheetBody;
  final double grabbingHeight;
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;

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
      _displayFullScreen,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BottomSheetPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void onSheetMoved(double data) async {
    if (isSheetFullScreen) {
      if (data >= 0.85 && data <= 0.93) {
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

  void _displayFullScreen() {
    if (!controller.isCompleted) {
      sheetController.snapToPosition(_full);
    }
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

  void onNovigation(index) {
    widget.onBottomNavigation.call(index);
  }

  Widget get buildAppBar {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: IgnorePointer(
        ignoring: !controller.isCompleted,
        child: Opacity(
          opacity: barAnim.value.clamp(0.0, 1.0),
          child: SizedBox(
            height: 50.0,
            width: double.infinity,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xff1e2b34),
              ),
              child: Row(
                children: [
                  widget.leading ??
                      IconButton(
                        onPressed: onBack,
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                        color: Colors.white,
                      ),
                  const SizedBox(width: 10.0),
                  widget.title ?? const SizedBox(width: 10.0),
                  const Spacer(),
                  Row(
                    children: widget.actions ?? [],
                  ),
                ],
              ),
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
        if (data.relativeToSheetHeight < 0.8) {
          controller.reset();
          isSheetFullScreen = true;
        }
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
                  ..scale(1.0 + 1.5 * headerAnim.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  decoration: const BoxDecoration(
                    color: Color(0xff1e2b34),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 1 - headerAnim.value,
                child: Container(
                  width: 100.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: Colors.white24,
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
              child: buildBottomNavigation,
            )
          ],
        ),
        draggable: true,
      ),
      snappingPositions: [_lower, _half, _full],
    );
  }

  Widget get buildBottomNavigation {
    return Container(
      color: const Color(0xff1e2b34),
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () => onNovigation(0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Icon(
                    FontAwesomeIcons.image,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              const Text(
                'Gallery',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13.0,
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () => onNovigation(1),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Icon(
                    Icons.file_copy,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  'Files',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13.0,
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onNovigation(2),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Icon(
                    Icons.location_pin,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  'Location',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13.0,
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onNovigation(3),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade600,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Icon(
                    Icons.person,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  'Contacts',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13.0,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheetController {
  late Function() _show;
  late Function() _close;
  late Function() _displayFullScreen;
  void _addListener(
    Function() _show,
    Function() _close,
    Function() _displayFullScreen,
  ) {
    this._show = _show;
    this._close = _close;
    this._displayFullScreen = _displayFullScreen;
  }

  void close() => _close();
  void show() => _show();
  void displayFullScreen() => _displayFullScreen();
}
