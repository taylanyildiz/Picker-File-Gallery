import '/widgets/widgets.dart';
import '/widgets/bottom_sheet_picker.dart';
import '/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: bottomSheet,
      ),
    );
  }

  Widget get bottomSheet {
    return GetBuilder<HomeScreenController>(
      builder: (_) => BottomSheetPicker(
        controller: controller.sheetController,
        body: body,
        sheetBody: sheetBody,
        onBottomNavigation: controller.onBottomNavigation,
        onSheetMoved: (data) {},
        onSnapCompleted: controller.onSnapCompleted,
        leading: buildBarLeadingButton(),
        title: buildBarTitle(),
        actions: buildActions,
      ),
    );
  }

  IconButton buildBarLeadingButton() {
    return IconButton(
      onPressed: () {
        if (controller.selectedImages.isEmpty) {
          controller.sheetController.close();
        } else {
          controller.pickerController.clear();
        }
      },
      icon: Icon(
        controller.selectedImages.isEmpty ? Icons.arrow_back : Icons.close,
      ),
      color: Colors.white,
    );
  }

  Text buildBarTitle() {
    return Text(
      controller.selectedImages.isEmpty
          ? 'Images'
          : '${controller.selectedImages.length} Selected File',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  List<Widget> get buildActions {
    return [
      Visibility(
        visible: controller.selectedImages.isNotEmpty,
        child: IconButton(
          color: Colors.white,
          onPressed: controller.selectFiles,
          icon: const Icon(Icons.done),
        ),
      )
    ];
  }

  Widget get sheetBody {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff1e2b34),
      ),
      child: GalleryPickerWithCamera(
        pickerController: controller.pickerController,
        isCameraDispose: controller.isCameraDispose,
        cameraController: controller.cameraController,
        cameraScale: controller.middleScreenCameraScale,
        files: controller.fileModels,
        scrollController: controller.scrollController,
        physics: controller.gridViewPhysics,
        onNotification: controller.onNotification,
        onCamera: () {
          controller.openCamera();
        },
        onDetail: controller.onDetail,
        pickFiles: controller.pickFile,
      ),
    );
  }

  Widget get body {
    return Container(
      color: const Color(0xff0f171a),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            child: const Text(
              'Show Bottom Sheet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            color: Colors.red,
            onPressed: () {
              // Get.toNamed(AppRoutes.galleryPicker);
              controller.sheetController.show();
            },
          ),
        ],
      ),
    );
  }
}
