import 'package:flutter/material.dart';
import 'package:noteapp/presentation/screens/Addnote_screen.dart';
import 'package:noteapp/presentation/screens/home_screen.dart';
import 'package:noteapp/presentation/screens/trash_screen.dart';

class AppRouter {
  Route onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => Home(),
        );
      case "/Add":
        return MaterialPageRoute(
          builder: (_) => Add(),
        );
      case "/trash":
        return MaterialPageRoute(
          builder: (_) => Trash(),
        );
      default:
        return null;
    }
  }
}
