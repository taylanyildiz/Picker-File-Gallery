import 'dart:async';
import '/models/file_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetailScreen extends StatefulWidget {
  const VideoDetailScreen({
    Key? key,
    required this.fileModel,
  }) : super(key: key);
  final FileModel? fileModel;

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  /// Video player.
  VideoPlayerController? playerController;

  bool isPlay = false;
  bool isShowPlayButton = true;
  Timer? timer;

  @override
  void initState() {
    playerController = VideoPlayerController.file(widget.fileModel!.file!)
      ..initialize().then((value) {})
      ..addListener(() {
        isPlay = playerController!.value.isPlaying;
        if (playerController!.value.duration ==
            playerController!.value.position) {
          isPlay = false;
          isShowPlayButton = true;
        }
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    playerController!.dispose();
    super.dispose();
  }

  void onPlay() {
    if (timer != null) {
      timer!.cancel();
    }
    isPlay = !isPlay;
    setState(() {});
    if (playerController!.value.isPlaying) {
      playerController!.pause();
    } else {
      playerController!.play();
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
    if (playerController!.value.isInitialized) {
      return GestureDetector(
        onTap: onTapVideo,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(playerController!),
            buildPlayButton,
          ],
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(color: Colors.red),
      );
    }
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
}
