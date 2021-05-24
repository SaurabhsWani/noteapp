import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/logic/DatabaseOffline/Notedatbase.dart';
import 'package:noteapp/presentation/screens/Detail_sereen.dart';

class NotesPage extends StatefulWidget {
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

    this.notes = await NoteDB.instance.readallNote();

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
                      return OpenContainer(
                        transitionType: ContainerTransitionType.fadeThrough,
                        closedBuilder:
                            (BuildContext _, VoidCallback openContainer) {
                          return Card(
                            // color: Colors.yellow.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 2,
                            child: ListTile(
                              leading: Icon(Icons.note_rounded),
                              trailing: Icon(Icons.open_in_new_rounded),
                              title: Text(note.title),
                              onTap: openContainer,
                              subtitle: Text(
                                  "${note.discription.substring(0, (note.discription.length * (1 / 50)).toInt())}........"),
                            ),
                          );
                        },
                        openBuilder: (BuildContext _, VoidCallback __) {
                          return DetailScreen(
                            title: note.title,
                            note: note.discription,
                            id: note.id.toString(),
                            videolink:
                                note.videoLink == '_' ? "_" : note.videoLink,
                          );
                        },
                        // onClosed: (_) => print('Closed'),
                      );
                    },
                  ),
      );
}
