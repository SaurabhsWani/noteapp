import 'package:flutter/material.dart';
import 'package:noteapp/presentation/screens/video_player.dart';
import 'package:video_player/video_player.dart';

class PlayVideo extends StatefulWidget {
  final String vl;
  PlayVideo({this.vl});
  @override
  _PlayVideoState createState() => _PlayVideoState(this.vl);
}

class _PlayVideoState extends State<PlayVideo> {
  final String vl;
  VideoPlayerController _controller;

  _PlayVideoState(this.vl);
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4')
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _controller.play());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video"),
      ),
      body: VideoPlayerWidget(
        vc: _controller,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (mounted) {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          }
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
