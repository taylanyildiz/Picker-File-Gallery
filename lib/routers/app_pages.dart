import '/bindings/bindings.dart';
import '/routers/app_routers.dart';
import '/screens/screens.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
        name: AppRoutes.galleryPicker,
        page: () => const GalleryPickerScreen(),
        binding: GalleryPickerScreenBinding()),
    GetPage(
      name: AppRoutes.galleryDetail,
      page: () => const GalleryDetailScreen(),
      binding: GalleryDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.camera,
      page: () => const CameraScreen(),
      binding: CameraSceenBinding(),
    ),
  ];
}
