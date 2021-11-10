import 'package:flutter/services.dart';

import '/bindings/home_binding.dart';
import 'routers/app_routers.dart';
import 'routers/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;

void setFullScreen() {
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );
}

Future<void> setNormalScreen() async {
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom,
    SystemUiOverlay.top,
  ]);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Bottom Sheet Picker Demot',
      theme: ThemeData(primarySwatch: Colors.blue),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.home,
      initialBinding: HomeBinding(),
    );
  }
}
