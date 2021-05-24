import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/logic/cubit/internet_cubit.dart';
import 'package:noteapp/presentation/router/BottmnavigationBar_screen.dart';
import 'package:noteapp/logic/DatabaseOnline/Online_data_fetch.dart';
import 'package:noteapp/presentation/screens/notepage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes"),
        elevation: .1,
        backgroundColor: Colors.orange,
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
            return onileFetch(0);
          } else if (internetstate is InternetDisconnected) {
            return NotesPage();
          }
          return CircularProgressIndicator();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        selectedItemColor: Colors.orange,
        items: btnnav,
        onTap: (index) {
          if (index == 0) {
            // myget();
          }
          if (index == 1) {
            Navigator.of(context).pushNamed("/Add");
          }
          if (index == 2) {
            Navigator.of(context).pushNamed("/trash");
          }
        },
      ),
    );
  }
}
