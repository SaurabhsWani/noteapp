import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

var titl, para;
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
          IconButton(
            icon: Icon(Icons.check_circle),
            onPressed: () async {
              try {
                await fsc
                    .collection("User")
                    .add({'Title': titl, 'Note': para, "status": 0})
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                onChanged: (value) {
                  titl = value;
                  setState(() {
                    titl = value;
                  });
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
                  setState(() {
                    para = value;
                  });
                  para = value;
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'All Note',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mode_edit),
            label: 'Add Note',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete_sharp),
            label: 'Trash Notes',
          )
        ],
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
