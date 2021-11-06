import 'package:bottom_sheet_picker/controllers/send_image_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendImageScreen extends GetView<SendImageScreenController> {
  const SendImageScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
        child: Stack(
          children: [
            Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            buildImage,
          ],
        ),
      ),
    );
  }

  Widget get buildImage {
    return Center(
      child: Image.file(controller.file),
    );
  }
}
