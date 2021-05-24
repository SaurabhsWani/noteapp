import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/logic/cubit/internet_cubit.dart';
import 'package:noteapp/presentation/router/BottmnavigationBar_screen.dart';
import 'package:noteapp/logic/DatabaseOnline/Online_data_fetch.dart';

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
      body: BlocConsumer<InternetCubit, InternetState>(
        listener: (context, state) {
          final internetstate = context.read<InternetCubit>().state;
          if (internetstate is InternetConnected) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Back Online"),
              backgroundColor: Colors.green,
            ));
          } else if (internetstate is InternetDisconnected) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("You Are Offline"),
            ));
          }
        },
        builder: (context, state) {
          final internetstate = context.watch<InternetCubit>().state;
          if (internetstate is InternetConnected) {
            return onileFetch(1);
          } else if (internetstate is InternetDisconnected) {
            return Text(
              "Internet: Disconnected",
              style: Theme.of(context).textTheme.headline6,
            );
          }
          return CircularProgressIndicator();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        selectedItemColor: Colors.red,
        items: btnnav,
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
