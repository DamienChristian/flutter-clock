import 'package:clock/screens/alarm/alarm_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.tealAccent[400],
        accentColor: Colors.tealAccent[700],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.transparent,
      ),
      home: AlarmPage(),
    );
  }
}
