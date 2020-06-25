import 'package:clock/bottom_navbar.dart';
import 'package:flutter/material.dart';

class AlarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm'),
      ),
      bottomNavigationBar: BottomNavbar(
        index: 0,
      ),
      backgroundColor: Theme.of(context).cardColor,
      body: Text('Alarm'),
    );
  }
}
