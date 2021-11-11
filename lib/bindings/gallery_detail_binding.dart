import '/controllers/controllers.dart';
import 'package:get/get.dart';

class GalleryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GalleryDetailController());
  }
}
