import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController vc;
  const VideoPlayerWidget({
    Key key,
    this.vc,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  Widget build(BuildContext context) => widget.vc.value.isInitialized
      ? Container(
          alignment: Alignment.topCenter,
          child: buildVideo(),
        )
      : Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ),
        );

  Widget buildVideo() => buildVideoPlayer();

  Widget buildVideoPlayer() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: AspectRatio(
            aspectRatio: widget.vc.value.aspectRatio,
            child: VideoPlayer(widget.vc)),
      );
}
