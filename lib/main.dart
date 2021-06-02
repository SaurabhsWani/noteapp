import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/logic/cubit/addnote_cubit.dart';
import 'package:noteapp/logic/cubit/internet_cubit.dart';
import 'package:noteapp/presentation/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var list = await NetworkInterface.list(type: InternetAddressType.IPv4);
  var ip = list[0].addresses[0].address;
  print(list.length);
  if (list.length == 2) {
    ip = list[1].addresses[0].address;
  } else {
    ip = list[0].addresses[0].address;
  }
  print(ip);
  runApp(MyApp(
    appRouter: AppRouter(ip: ip),
    connectivity: Connectivity(),
  ));
}

class MyApp extends StatefulWidget {
  final AppRouter appRouter;
  final Connectivity connectivity;
  const MyApp({
    Key key,
    this.appRouter,
    this.connectivity,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext myAppcontext) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetCubit>(
          create: (internetCubitcontext) => InternetCubit(widget.connectivity),
          lazy: false,
        ),
        BlocProvider<AddnoteCubit>(
          create: (internetCubitcontext) => AddnoteCubit(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "NoteApp",
        onGenerateRoute: widget.appRouter.onGeneratedRoute,
        theme: ThemeData(
            primaryColor: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
      ),
    );
  }
}
