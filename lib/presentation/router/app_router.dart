import 'package:flutter/material.dart';
import 'package:noteapp/presentation/screens/Addnote_screen.dart';
import 'package:noteapp/presentation/screens/home_screen.dart';
import 'package:noteapp/presentation/screens/trash_screen.dart';

class AppRouter {
  final ip;
  const AppRouter({this.ip});
  Route onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => Home(
            ip: ip,
          ),
        );
      case "/Add":
        return MaterialPageRoute(
          builder: (_) => Add(
            ip: ip,
          ),
        );
      case "/trash":
        return MaterialPageRoute(
          builder: (_) => Trash(
            ip: ip,
          ),
        );
      default:
        return null;
    }
  }
}
