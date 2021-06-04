import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:video_player/video_player.dart';

import 'package:noteapp/logic/DatabaseOffline/Notedatbase.dart';
import 'package:noteapp/logic/cubit/internet_cubit.dart';
import 'package:noteapp/presentation/screens/video_player.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final ip;
  final String note;
  final int id;
  final String ido;
  final String videolink;
  const DetailScreen({
    Key key,
    this.title,
    this.note,
    this.id,
    this.ip,
    this.ido,
    this.videolink,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  VideoPlayerController _controller;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    _controller = VideoPlayerController.network(widget.videolink.toString())
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _largePhoto = false;
  var fsc = FirebaseFirestore.instance;
  ProgressDialog progressDialog;
  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Note'),
          actions: <Widget>[
            BlocBuilder<InternetCubit, InternetState>(
              builder: (context, state) {
                return IconButton(
                    icon: Icon(Icons.delete), // The "-" icon
                    onPressed: () async {
                      progressDialog.style(
                        message: 'Moving To Trash',
                      );
                      if (state is InternetConnected) {
                        Map<String, dynamic> data = <String, dynamic>{
                          "status": 1,
                        };
                        progressDialog.show();
                        fsc
                            .collection("User")
                            .doc(widget.ip)
                            .collection('Note')
                            .doc(widget.ido.toString())
                            .update(data)
                            .then(
                              (value) => {
                                progressDialog.hide(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        ('${widget.title.toUpperCase()} Is Deleted')),
                                  ),
                                ),
                                Navigator.pushNamedAndRemoveUntil(
                                    context, "/", (_) => false),
                              },
                            )
                            .catchError((error) => {
                                  progressDialog.hide(),
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          ('${widget.title.toUpperCase()} Could Not Deleted Try Again!')),
                                    ),
                                  )
                                });
                      }
                      if (state is InternetDisconnected) {
                        progressDialog.show();
                        await NoteDB.instance
                            .update(sta: 1, note: Note(id: widget.id))
                            .then(
                              (value) => {
                                progressDialog.hide(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        ('${widget.title.toUpperCase()} Is Deleted')),
                                  ),
                                ),
                                Navigator.pushNamedAndRemoveUntil(
                                    context, "/", (_) => false),
                              },
                            )
                            .catchError((error) => {
                                  progressDialog.hide(),
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          ('${widget.title.toUpperCase()} Could Not Deleted Try Again!')),
                                    ),
                                  )
                                });
                      }
                    });
              },
            ),
          ],
        ),
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 500),
          reverse: !_largePhoto,
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Center(
                  child: Card(
                    borderOnForeground: true,
                    elevation: 3.0,
                    margin: new EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: new InkWell(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          verticalDirection: VerticalDirection.down,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: new Text(widget.title,
                                    style: new TextStyle(
                                        fontSize: 25.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(height: 0.0),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Text(widget.note,
                                  style: new TextStyle(
                                      fontSize: 15.0, color: Colors.black)),
                            ),
                            SizedBox(height: 0.0),
                            widget.videolink != "_"
                                ? BlocBuilder<InternetCubit, InternetState>(
                                    builder: (context, state) {
                                    final internetstate =
                                        context.read<InternetCubit>().state;
                                    if (internetstate is InternetConnected) {
                                      return VideoPlayerWidget(
                                        vc: _controller,
                                      );
                                    }
                                    return Container();
                                  })
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: BlocBuilder<InternetCubit, InternetState>(
          builder: (context, state) {
            if (state is InternetConnected && widget.videolink != "_") {
              return FloatingActionButton(
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                      _controller.value.isPlaying
                          ? _animationController.forward()
                          : _animationController.reverse();
                    });
                  }
                },
                child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _animationController),
              );
            }
            return Text('');
          },
        ));
  }
}
