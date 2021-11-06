import '/controllers/controllers.dart';
import 'package:get/get.dart';

class SendImageScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SendImageScreenController());
  }
}
