import 'dart:developer';
import 'package:bottom_sheet_picker/main.dart';
import 'package:camera/camera.dart';

import '/controllers/home_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LifeCycleService extends GetxService with WidgetsBindingObserver {
  @override
  void onInit() async {
    WidgetsBinding.instance!.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    log('Close App');
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        log('Resumed');
        _initializedCamera();
        break;
      case AppLifecycleState.inactive:
        log('Inactive');
        await _disposeCamera();
        break;
      case AppLifecycleState.paused:
        log('Paused');
        break;
      case AppLifecycleState.detached:
        log('Detached');
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _disposeCamera() async {
    final homeScreenController = Get.find<HomeScreenController>();
    homeScreenController.bottomSheetController.snapToPosition(
      homeScreenController.lower,
    );
    await homeScreenController.cameraController!.dispose();
  }

  void _initializedCamera() {
    final homeScreenController = Get.find<HomeScreenController>();
    homeScreenController.cameraController = CameraController(
      cameras![0],
      ResolutionPreset.max,
    );
  }
}
