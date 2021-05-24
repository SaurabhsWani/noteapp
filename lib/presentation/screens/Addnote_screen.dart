import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/logic/DatabaseOffline/Notedatbase.dart';
import 'package:noteapp/logic/cubit/addnote_cubit.dart';
import 'package:noteapp/logic/cubit/internet_cubit.dart';
import 'package:noteapp/presentation/router/BottmnavigationBar_screen.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

var titl, para, vidlink;
var fsc = FirebaseFirestore.instance;

class _AddState extends State<Add> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
        elevation: .1,
        backgroundColor: Colors.pinkAccent.shade400,
        actions: <Widget>[
          BlocBuilder<AddnoteCubit, AddNoteState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(Icons.check_circle),
                onPressed: () async {
                  await NoteDB.instance
                      .create(Note(
                        title: state.title,
                        discription: state.discription,
                        status: state.status,
                        videoLink: state.videoLinkcheck == false
                            ? '_'
                            : state.videoLink,
                      ))
                      .then((value) => {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(('Note Added SuccesFully')),
                              ),
                            ),
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/", (_) => false)
                          })
                      .catchError((error) => {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(('Note Add Failed Try Again!')),
                              ),
                            )
                          });
                  try {
                    await fsc
                        .collection("User")
                        .add({
                          'Title': state.title,
                          'Note': state.discription,
                          "Video_link": state.videoLinkcheck == false
                              ? '_'
                              : state.videoLink,
                          "status": 0
                        })
                        .then((value) => {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(('Note Added SuccesFully')),
                                ),
                              ),
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/", (_) => false)
                            })
                        .catchError((error) => {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(('Note Add Failed Try Again!')),
                                ),
                              )
                            });
                  } catch (e) {
                    print(e);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<AddnoteCubit, AddNoteState>(
          listener: (context, state) {
            final notificationSnackBar = SnackBar(
              backgroundColor:
                  state.videoLinkcheck == true ? Colors.green : Colors.black,
              duration: Duration(milliseconds: 700),
              content: Text(
                'Video Link Add ' +
                    state.videoLinkcheck.toString().toUpperCase(),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(notificationSnackBar);
          },
          builder: (context, state) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextField(
                    onChanged: (value) {
                      state.title = value;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                            color: Colors.pinkAccent.shade400,
                          ),
                        ),
                        labelText: 'Title ',
                        prefixIcon: const Icon(
                          Icons.title,
                        ),
                        hintText: 'Enter Title'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextField(
                    onChanged: (value) {
                      state.discription = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Colors.pinkAccent.shade400,
                          ),
                        ),
                        labelText: 'Note',
                        hintText: 'Write Something to Note...'),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      CheckboxListTile(
                        value: state.videoLinkcheck,
                        onChanged: (newValue) {
                          context.read<AddnoteCubit>().toggleVideo(newValue);
                        },
                        title: Text('Add Video Link'),
                      ),
                    ],
                  ),
                ),
                state.videoLinkcheck == true
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        child: TextField(
                          onChanged: (value) {
                            state.videoLink = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(
                                  color: Colors.pinkAccent.shade400,
                                ),
                              ),
                              labelText: 'Video Link ',
                              prefixIcon: const Icon(
                                Icons.video_collection_rounded,
                              ),
                              hintText: 'Paste Video Link Here'),
                        ),
                      )
                    : Text(""),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        selectedItemColor: Colors.green,
        items: btnnav,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
          }
          if (index == 2) {
            Navigator.pushNamedAndRemoveUntil(context, "/trash", (_) => false);
          }
          if (index == 1) {
            // Navigator.pushNamedAndRemoveUntil(context, "/add", (_) => false);
          }
        },
      ),
    );
  }
}