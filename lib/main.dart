import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/logic/cubit/addnote_cubit.dart';
import 'package:noteapp/logic/cubit/internet_cubit.dart';

import 'package:noteapp/presentation/router/app_router.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   static final String title = 'Notes SQLite';

//   @override
//   Widget build(BuildContext context) => MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: title,
//         themeMode: ThemeMode.dark,
//         theme: ThemeData(
//           primaryColor: Colors.black,
//           scaffoldBackgroundColor: Colors.blueGrey.shade900,
//           appBarTheme: AppBarTheme(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//           ),
//         ),
//         home: NotesPage(),
//       );
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(
    appRouter: AppRouter(),
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
