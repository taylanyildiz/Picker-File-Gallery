import 'package:bottom_sheet_picker/screens/send_image_screen.dart';
import 'package:bottom_sheet_picker/widgets/pick_image.dart';
import '/controllers/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomSheet,
    );
  }

  Widget get bottomSheet {
    return GetBuilder<HomeScreenController>(
      builder: (_) => SnappingSheet(
        lockOverflowDrag: true,
        controller: controller.bottomSheetController,
        onSnapCompleted: controller.onSnapCompleted,
        grabbingHeight: 0.0,
        child: body,
        sheetBelow: SnappingSheetContent(
          child: sheetBody,
          draggable: true,
        ),
        snappingPositions: [
          controller.lower,
          controller.half,
        ],
      ),
    );
  }

  Widget get sheetBody {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(40.0),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200.0,
                height: 5.0,
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(3.0),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 150.0,
                child: PickImageBox(
                  onCamera: controller.openCamera,
                  cameraController: controller.cameraController!,
                  scale: controller.middleScreenCameraScale,
                  files: controller.imageFiles,
                  scrollController: controller.scrollController,
                  pickFile: controller.pickImageFile,
                  onFile: controller.openImageFile,
                ),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/folder.png',
                        width: 25.0,
                      ),
                      const SizedBox(width: 10.0),
                      const Text(
                        'File',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () async => await controller.getFileFromGallery(),
                child: Container(
                  width: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/replace.png',
                        width: 25.0,
                      ),
                      const SizedBox(width: 10.0),
                      const Text(
                        'Image Video',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get body {
    return GestureDetector(
      onTap: () =>
          controller.bottomSheetController.snapToPosition(controller.lower),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.red,
              onPressed: () => controller.bottomSheetController
                  .snapToPosition(controller.half),
            ),
          ],
        ),
      ),
    );
  }
}
