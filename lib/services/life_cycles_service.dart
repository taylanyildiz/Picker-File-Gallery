import 'dart:developer';
import '../controllers/home_screen_controller.dart';
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
        break;
      case AppLifecycleState.inactive:
        log('Inactive');
        break;
      case AppLifecycleState.paused:
        log('Paused');
        await _disposeCamera();
        break;
      case AppLifecycleState.detached:
        log('Detached');
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _disposeCamera() async {
    final homeScreenController = Get.find<HomeScreenController>();

    if (homeScreenController.cameraController != null) {
      if (homeScreenController.cameraController!.value.isInitialized) {
        await homeScreenController.cameraController!.dispose();
      }
    }
  }
}
