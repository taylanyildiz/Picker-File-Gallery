import 'package:bottom_sheet_picker/controllers/controllers.dart';
import 'package:get/get.dart';

class CameraSceenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CameraScreenController());
  }
}
