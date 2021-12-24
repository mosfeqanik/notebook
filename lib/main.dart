import 'package:flutter/material.dart';
import 'package:pondits_notebook/views/splash_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'note',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashPage()
      );
  }
}

