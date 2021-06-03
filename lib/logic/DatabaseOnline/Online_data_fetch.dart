import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/presentation/screens/Detail_sereen.dart';
import 'package:progress_dialog/progress_dialog.dart';

StreamBuilder onileFetch(int condition, var ip) {
  var fsc = FirebaseFirestore.instance;

  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection("User")
        .doc(ip)
        .collection('Note')
        .where("status", isEqualTo: condition)
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: false,
      );
      List<String> y = [], z = [], id = [], vl = [];
      try {
        var x = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: const CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.data != null) {
          for (var d in x.docs) {
            id.add(d.id);
            y.add(d.get("Title"));
            vl.add(d.get("Video_link").toString());
            z.add(d.get("Note").toString());
          }
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: y.length,
            itemBuilder: (context, index) {
              if (condition == 0) {
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    OpenContainer(
                      closedElevation: 2,
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedBuilder:
                          (BuildContext _, VoidCallback openContainer) {
                        return ListTile(
                          leading: Icon(Icons.note_rounded),
                          trailing: Icon(Icons.open_in_new_rounded),
                          title: Text(y[index]),
                          onTap: openContainer,
                          subtitle: Text(
                              "${z[index].substring(0, (z[index].length * (1 / 50)).toInt())}........"),
                        );
                      },
                      openBuilder: (BuildContext _, VoidCallback __) {
                        return DetailScreen(
                          ip: ip,
                          title: y[index],
                          note: z[index],
                          ido: id[index],
                          videolink: vl[index] == '_' ? "_" : vl[index],
                        );
                      },
                      // onClosed: (_) => print('Closed'),
                    ),
                  ],
                );
              } else if (condition == 1) {
                return Dismissible(
                  secondaryBackground: Container(
                    color: Colors.green,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.restore,
                        size: 30,
                      ),
                    ),
                  ),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.delete_forever,
                        size: 30,
                      ),
                    ),
                  ),
                  key: UniqueKey(),
                  onDismissed: (DismissDirection direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      progressDialog.style(
                        message: 'Deleting Note Permanently',
                      );
                      progressDialog.show();
                      await fsc
                          .collection("User")
                          .doc(ip)
                          .collection('Note')
                          .doc(id[index])
                          .delete()
                          .then((value) => {
                                progressDialog.hide(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        ('${y[index].toUpperCase()} Is Deleted Successfully')),
                                  ),
                                )
                              })
                          .catchError((error) => {
                                progressDialog.hide(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        ('${y[index].toUpperCase()} Could Not Deleted Try Again!')),
                                  ),
                                )
                              });
                    } else if (direction == DismissDirection.endToStart) {
                      Map<String, dynamic> data = <String, dynamic>{
                        "status": 0,
                      };
                      progressDialog.style(
                        message: 'Restoring Note',
                      );
                      progressDialog.show();
                      await fsc
                          .collection("User")
                          .doc(ip)
                          .collection('Note')
                          .doc(id[index])
                          .update(data)
                          .then((value) => {
                                progressDialog.hide(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        ('${y[index].toUpperCase()} Is Restored Successfully')),
                                  ),
                                )
                              })
                          .catchError((error) => {
                                progressDialog.hide(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        ('${y[index].toUpperCase()} Could Not Restored Try Again!')),
                                  ),
                                )
                              });
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(Icons.note_rounded),
                      trailing: Icon(Icons.restore),
                      title: Text(y[index]),
                      subtitle: Text(
                          "${z[index].substring(0, (z[index].length * (1 / 50)).toInt())}....."),
                    ),
                  ),
                );
              }
              return Text("data");
            },
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                child: Text(
                  'No Notes',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
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
  );
}
