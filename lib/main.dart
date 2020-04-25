import 'package:flutter/material.dart';
import 'package:aggie_explore/authentication.dart';
import 'package:aggie_explore/root.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Aggie Explore',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primaryColor: Color.fromRGBO(80, 0, 0, 1.0),
        ),
        home: new RootPage(auth: new Auth()));
  }
}
