import '/controllers/controllers.dart';
import '/models/file_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_trimmer/video_trimmer.dart';

class VideoTrimmerScreen extends StatefulWidget {
  const VideoTrimmerScreen({
    Key? key,
    required this.fileModel,
  }) : super(key: key);
  final FileModel fileModel;

  @override
  State<VideoTrimmerScreen> createState() => _VideoTrimmerScreenState();
}

class _VideoTrimmerScreenState extends State<VideoTrimmerScreen> {
  final trimmer = Trimmer();

  final galleryScreenController = Get.find<GalleryDetailController>();

  @override
  void initState() {
    trimmer.loadVideo(videoFile: widget.fileModel.file!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar,
      body: Stack(
        children: [
          buildVideoViewer,
          buildTrimmer,
        ],
      ),
    );
  }

  Widget get buildVideoViewer {
    return Positioned.fill(child: VideoViewer(trimmer: trimmer));
  }

  Widget get buildTrimmer {
    return Positioned(
      top: 20.0,
      left: 0.0,
      right: 0.0,
      child: TrimEditor(
        trimmer: trimmer,
        viewerHeight: 50.0,
        viewerWidth: MediaQuery.of(context).size.width,
        maxVideoLength: const Duration(seconds: 10),
        onChangeStart: (value) {},
        onChangeEnd: (value) {},
        onChangePlaybackState: (value) {},
      ),
    );
  }

  AppBar get buildAppBar {
    return AppBar(
      elevation: 0.0,
      backgroundColor: const Color(0xff1e2b34),
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => galleryScreenController.trimVideo(trimmer),
          child: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.done,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        ),
      ],
    );
  }
}
