import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/presentation/screens/Detail_sereen.dart';

StreamBuilder onileFetch(int condition) {
  var fsc = FirebaseFirestore.instance;
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection("User")
        .where("status", isEqualTo: condition)
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            itemCount: y.length,
            itemBuilder: (context, index) {
              if (condition == 0) {
                return OpenContainer(
                  transitionType: ContainerTransitionType.fadeThrough,
                  closedBuilder: (BuildContext _, VoidCallback openContainer) {
                    return Card(
                      // color: Colors.yellow.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(Icons.note_rounded),
                        trailing: Icon(Icons.open_in_new_rounded),
                        title: Text(y[index]),
                        onTap: openContainer,
                        subtitle: Text(
                            "${z[index].substring(0, (z[index].length * (1 / 50)).toInt())}........"),
                      ),
                    );
                  },
                  openBuilder: (BuildContext _, VoidCallback __) {
                    return DetailScreen(
                      title: y[index],
                      note: z[index],
                      id: id[index],
                      videolink: vl[index] == '_' ? "_" : vl[index],
                    );
                  },
                  // onClosed: (_) => print('Closed'),
                );
              } else if (condition == 1) {
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
              }
              return Text("data");
            },
          );
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
  );
}
