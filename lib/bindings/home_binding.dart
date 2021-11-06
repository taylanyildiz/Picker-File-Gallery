import '/controllers/controllers.dart';
import '/services/life_cycles_service.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LifeCycleService());
    Get.put(HomeScreenController());
  }
}
