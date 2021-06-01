import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/logic/cubit/internet_cubit.dart';
import 'package:noteapp/presentation/router/BottmnavigationBar_screen.dart';
import 'package:noteapp/logic/DatabaseOnline/Online_data_fetch.dart';
import 'package:noteapp/presentation/screens/notepage_screen.dart';

class Home extends StatefulWidget {
  final ip;

  const Home({Key key, this.ip}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, RestorationMixin {
  @override
  String get restorationId => 'tab_scrollable_demo';
  TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);
  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  Map<String, dynamic> map = {};
  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes"),
        elevation: .1,
        backgroundColor: Colors.orange,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Online',
            ),
            Tab(
              text: 'Offline',
            )
          ],
        ),
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
          return TabBarView(controller: _tabController, children: [
            onileFetch(0, widget.ip),
            NotesPage(
              qu: 0,
            )
          ]);
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
            Navigator.pop(context);
            Navigator.pushNamed(context, "/");
          }
          if (index == 1) {
            Navigator.of(context).pushNamedAndRemoveUntil("/Add", (_) => false);
          }
          if (index == 2) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/trash", (_) => false);
          }
        },
      ),
    );
  }
}
