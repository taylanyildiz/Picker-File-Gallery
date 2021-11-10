import '/routers/app_routers.dart';
import '/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/widgets/bottom_sheet_picker.dart';
import '../controllers/controllers.dart';
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
        sheetHeader: buildHeader,
        bottomNavigation: buildBottomNavigation,
        onSheetMoved: (data) {},
        onSnapCompleted: controller.onSnapCompleted,
        leading: IconButton(
          onPressed: () {
            controller.sheetController.close();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Gallery',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildHeader(Animation<double> anim) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      child: Opacity(
        opacity: 1 - anim.value,
        child: Center(
          child: Container(
            width: 60.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget get sheetBody {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.orange,
      ),
      child: ImagePicker(
        isCameraDispose: controller.isCameraDispose,
        cameraController: controller.cameraController,
        cameraScale: controller.middleScreenCameraScale,
        files: controller.imageFiles,
        scrollController: controller.scrollController,
        physics: controller.gridViewPhysics,
        onNotification: controller.onNotification,
        onCamera: () {
          controller.openCamera();
        },
        onDetail: (file) {
          Get.toNamed(AppRoutes.imageDetail, arguments: {
            'file_model': file,
          });
        },
        pickFiles: (files) {},
      ),
    );
  }

  Widget get buildBottomNavigation {
    return Container(
      height: 50.0,
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(
            FontAwesomeIcons.camera,
            size: 25.0,
          ),
          Icon(
            FontAwesomeIcons.images,
            size: 25.0,
          ),
          Icon(
            FontAwesomeIcons.file,
            size: 25.0,
          ),
        ],
      ),
    );
  }

  Widget get body {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
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
