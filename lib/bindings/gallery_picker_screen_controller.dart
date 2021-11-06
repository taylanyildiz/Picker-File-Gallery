import '/controllers/controllers.dart';
import 'package:get/get.dart';

class GalleryPickerScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GalleryPickerScreenController());
  }
}
