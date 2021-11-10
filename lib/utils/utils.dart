import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  Utils._();

  static showSnackBar(title, message) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      padding: const EdgeInsets.all(10.0),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black38,
    );
  }
}
