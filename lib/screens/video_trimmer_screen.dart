import 'dart:async';
import 'package:video_player/video_player.dart';
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

  /// Video player.
  late VideoPlayerController playerController;
  double startValue = 0.0;
  double endValue = 0.0;
  bool isPlay = false;
  bool isShowPlayButton = true;
  Timer? timer;
  final galleryScreenController = Get.find<GalleryDetailController>();

  @override
  void initState() {
    trimmer.loadVideo(videoFile: widget.fileModel.file!);
    playerController = trimmer.videoPlayerController!;
    playerController.addListener(() {
      isPlay = playerController.value.isPlaying;
      if (playerController.value.duration == playerController.value.position) {
        isPlay = false;
        isShowPlayButton = true;
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    trimmer.dispose();
    super.dispose();
  }

  void onPlay() {
    if (timer != null) {
      timer!.cancel();
    }
    isPlay = !isPlay;
    setState(() {});
    if (playerController.value.isPlaying) {
      playerController.pause();
    } else {
      playerController.play();
    }
    if (isPlay) {
      timer = Timer(const Duration(seconds: 1), () {
        isShowPlayButton = false;
        setState(() {});
      });
    }
  }

  void onTapVideo() {
    isShowPlayButton = true;
    setState(() {});
    if (isPlay) {
      timer = Timer(const Duration(milliseconds: 500), () {
        isShowPlayButton = false;
        setState(() {});
      });
    }
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
          buildVideProgressIndicator,
          buildPlayProgressButton,
        ],
      ),
    );
  }

  Widget get buildVideoViewer {
    if (playerController.value.isInitialized) {
      return Positioned.fill(
        child: GestureDetector(
          onTap: onTapVideo,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoViewer(trimmer: trimmer),
              buildPlayButton,
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      );
    }
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
        onChangeStart: (value) {
          startValue = value;
        },
        onChangeEnd: (value) {
          endValue = value;
        },
        onChangePlaybackState: (value) {
          isPlay = value;
        },
      ),
    );
  }

  Widget get buildPlayButton {
    return Visibility(
      visible: isShowPlayButton,
      child: GestureDetector(
        onTap: onPlay,
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            !isPlay ? Icons.play_arrow : Icons.pause,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget get buildVideProgressIndicator {
    return Positioned(
      bottom: 20.0,
      width: Get.width,
      child: VideoProgressIndicator(
        playerController,
        padding: const EdgeInsets.only(left: 60.0, right: 10.0),
        allowScrubbing: true,
        colors: const VideoProgressColors(
          playedColor: Colors.red,
        ),
      ),
    );
  }

  Widget get buildPlayProgressButton {
    return Positioned(
      bottom: 10.0,
      left: 10.0,
      child: GestureDetector(
        onTap: onPlay,
        child: Icon(
          !isPlay ? Icons.play_arrow : Icons.pause,
          size: 25,
          color: Colors.white,
        ),
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
          onTap: () async => await galleryScreenController.trimVideo(
            trimmer,
            startValue,
            endValue,
          ),
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
