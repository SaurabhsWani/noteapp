import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

var fsc = FirebaseFirestore.instance;

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes"),
        elevation: .1,
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("User")
            .where("status", isEqualTo: 0)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<String> y = [], z = [], id = [];
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
              print(x!.docs);
              for (var d in x.docs) {
                id.add(d.id);
                y.add(d.get("Title"));
                z.add(d.get("Note").toString());
              }
              return ListView.builder(
                itemCount: y.length,
                itemBuilder: (context, index) {
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
                      );
                    },
                    // onClosed: (_) => print('Closed'),
                  );
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        selectedItemColor: Colors.orange,
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
            // myget();
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

class DetailScreen extends StatefulWidget {
  final String title;
  final String note;
  final String id;
  const DetailScreen({
    Key? key,
    required this.title,
    required this.note,
    required this.id,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _largePhoto = false;

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
