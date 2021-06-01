import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:noteapp/logic/DatabaseOffline/Notedatbase.dart';
import 'package:noteapp/presentation/screens/Detail_sereen.dart';

class NotesPage extends StatefulWidget {
  final qu;
  const NotesPage({
    Key key,
    this.qu,
  }) : super(key: key);
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  // @override
  // void dispose() {
  //   NoteDB.instance.close();

  //   super.dispose();
  // }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NoteDB.instance.readallNote(widget.qu);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Center(
        child: isLoading
            ? CircularProgressIndicator()
            : notes.isEmpty
                ? Text(
                    'No Notes',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      if (widget.qu == 0) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            OpenContainer(
                              closedElevation: 2,
                              transitionType:
                                  ContainerTransitionType.fadeThrough,
                              closedBuilder:
                                  (BuildContext _, VoidCallback openContainer) {
                                return ListTile(
                                  tileColor: Colors.transparent,
                                  leading: Icon(Icons.note_rounded),
                                  trailing: Icon(Icons.open_in_new_rounded),
                                  title: Text(note.title),
                                  onTap: openContainer,
                                  subtitle: Text(
                                      "${note.discription.substring(0, (note.discription.length * (1 / 50)).toInt())}........"),
                                );
                              },
                              openBuilder: (BuildContext _, VoidCallback __) {
                                return DetailScreen(
                                  title: note.title,
                                  note: note.discription,
                                  id: note.id,
                                  videolink: note.videoLink == '_'
                                      ? "_"
                                      : note.videoLink,
                                );
                              },
                              // onClosed: (_) => print('Closed'),
                            ),
                          ],
                        );
                      } else if (widget.qu == 1) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: Icon(Icons.note_rounded),
                            trailing: Icon(Icons.restore),
                            title: Text(note.title),
                            onTap: () async {
                              await NoteDB.instance
                                  .update(
                                      note: Note(
                                        id: note.id,
                                      ),
                                      sta: 0)
                                  .then(
                                    (value) => {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                              ('${note.title.toUpperCase()} Is Deleted')),
                                        ),
                                      ),
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, "/", (_) => false),
                                    },
                                  )
                                  .catchError((error) => {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                ('${note.title.toUpperCase()} Could Not Deleted Try Again!')),
                                          ),
                                        )
                                      });
                            },
                            subtitle: Text(
                                "${note.discription.substring(0, (note.discription.length * (1 / 50)).toInt())}....."),
                          ),
                        );
                      }
                      return Text("ads");
                    },
                  ),
      );
}