import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Trash extends StatefulWidget {
  @override
  _TrashState createState() => _TrashState();
}

var fsc = FirebaseFirestore.instance;

class _TrashState extends State<Trash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Trash"),
        elevation: .1,
        backgroundColor: Colors.purpleAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("User")
            .where("status", isEqualTo: 1)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<String> y = [], z = [], id = [];
          try {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: const CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.data != null) {
              var x = snapshot.data;
              print(x!.docs);
              for (var d in x.docs) {
                id.add(d.id);
                y.add(d.get("Title"));
                z.add(d.get("Note").toString());
              }
              return ListView.builder(
                  itemCount: y.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.pink.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: Icon(Icons.note_rounded),
                        trailing: Icon(Icons.restore),
                        title: Text(y[index]),
                        onTap: () async {
                          Map<String, dynamic> data = <String, dynamic>{
                            "status": 0,
                          };
                          await fsc
                              .collection("User")
                              .doc(id[index])
                              .update(data)
                              .then((value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                          ('${y[index].toUpperCase()} Is Restored Successfully')),
                                    ),
                                  ))
                              .catchError((error) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          ('${y[index].toUpperCase()} Could Not Restored Try Again!')),
                                    ),
                                  ));
                        },
                        subtitle: Text(
                            "${z[index].substring(0, (z[index].length * (1 / 50)).toInt())}....."),
                      ),
                    );
                  });
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: const CircularProgressIndicator(),
                ),
              );
            }
          } on Exception catch (e) {
            print(e);
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: const CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        selectedItemColor: Colors.red,
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
          if (index == 1) {
            Navigator.pushNamedAndRemoveUntil(context, "/add", (_) => false);
          }
          if (index == 2) {
            Navigator.pushNamedAndRemoveUntil(context, "/trash", (_) => false);
          }
        },
      ),
    );
  }
}
