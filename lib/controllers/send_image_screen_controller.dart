import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendImageScreenController extends GetxController {
  /// Message textController.
  late TextEditingController messageController;

  /// Image file argument.s
  late File file;

  @override
  void onInit() {
    file = Get.arguments;
    messageController = TextEditingController();
    super.onInit();
  }

  void sendImageFile() {}
}
