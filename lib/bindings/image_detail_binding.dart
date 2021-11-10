import '/controllers/controllers.dart';
import 'package:get/get.dart';

class ImageDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ImageDetailScreenController());
  }
}
