import 'package:flutter/material.dart';

class CameraButton extends StatefulWidget {
  const CameraButton({
    Key? key,
    required this.onTakePicture,
    required this.onStartRecordingVideo,
    required this.onSaveVideo,
    this.bottom,
  }) : super(key: key);
  final Function() onTakePicture;
  final Function() onStartRecordingVideo;
  final Function() onSaveVideo;
  final double? bottom;

  @override
  State<CameraButton> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    animation = Tween<double>(begin: 2.0, end: 2.5).animate(controller);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: widget.bottom ?? 40.0,
      child: GestureDetector(
        onTap: () {
          widget.onTakePicture.call();
        },
        onLongPress: () {
          controller.repeat();
          widget.onStartRecordingVideo.call();
        },
        onLongPressEnd: (_) {
          controller.reset();
          widget.onSaveVideo.call();
        },
        child: Stack(
          children: [
            buildPictureButton(),
            buildVideoButton(),
          ],
        ),
      ),
    );
  }

  Container buildPictureButton() {
    return Container(
      height: 90.0,
      width: 90.0,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.5),
        shape: BoxShape.circle,
      ),
    );
  }

  AnimatedBuilder buildVideoButton() {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Visibility(
            visible: controller.isAnimating && !controller.isDismissed,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(animation.value, animation.value),
              child: Container(
                height: 90.0,
                width: 90.0,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        });
  }
}
