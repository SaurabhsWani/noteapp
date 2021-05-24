import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/logic/cubit/internet_cubit.dart';

import 'package:noteapp/presentation/screens/playvideo_screen.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final String note;
  final String id;
  final String videolink;
  const DetailScreen({
    Key key,
    this.title,
    this.note,
    this.id,
    this.videolink,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _largePhoto = false;
  var fsc = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
        actions: <Widget>[
          // First button - decrement
          IconButton(
            icon: Icon(Icons.delete), // The "-" icon
            onPressed: () async {
              Map<String, dynamic> data = <String, dynamic>{
                "status": 1,
              };
              fsc
                  .collection("User")
                  .doc(widget.id)
                  .update(data)
                  .then((value) => {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                                ('${widget.title.toUpperCase()} Is Deleted')),
                          ),
                        ),
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/", (_) => false)
                      })
                  .catchError((error) => {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                                ('${widget.title.toUpperCase()} Could Not Deleted Try Again!')),
                          ),
                        )
                      });
            }, // The `_decrementCounter` function
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
                          widget.videolink != '_'
                              ? OpenContainer(
                                  transitionType:
                                      ContainerTransitionType.fadeThrough,
                                  closedBuilder: (BuildContext _,
                                      VoidCallback openContainer) {
                                    return BlocBuilder<InternetCubit,
                                        InternetState>(
                                      builder: (context, state) {
                                        final internetstate =
                                            context.read<InternetCubit>().state;
                                        if (internetstate
                                            is InternetConnected) {
                                          return ListTile(
                                            trailing: Icon(Icons
                                                .play_circle_outline_outlined),
                                            title: Text("Video"),
                                          );
                                        }
                                        return Container();
                                      },
                                    );
                                  },
                                  openBuilder:
                                      (BuildContext _, VoidCallback __) {
                                    return PlayVideo(
                                      vl: widget.videolink,
                                    );
                                  },
                                  // onClosed: (_) => print('Closed'),
                                )
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
    );
  }
}
