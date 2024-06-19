import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({super.key, required this.videoUrl});

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool _isPlaying = true;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        _isPlaying = true;
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
        // videoPlayerController.pause();
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  videoCtrl() {
    if (_isPlaying) {
      setState(() {
        _isPlaying = false;
        videoPlayerController.pause();
      });
    } else {
      setState(() {
        _isPlaying = true;
        videoPlayerController.play();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: InkWell(
        onTap: () => {videoCtrl()},
        child: Stack(
          children: [
            VideoPlayer(videoPlayerController),
            _isPlaying
                ? const Text('')
                : const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white54,
                size: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}