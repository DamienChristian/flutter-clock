import 'package:clock/screens/alarm/alarm_screen.dart';
import 'package:clock/screens/stopwatch/stopwatch_screen.dart';
import 'package:clock/screens/timer/timer_screen.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  final int index;

  const BottomNavbar({Key key, this.index}) : super(key: key);
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _bIndex;

  List _bnbItems = [
    ['Alarm', AlarmPage()],
    ['Stopwatch', StopwatchPage()],
    ['Timer', TimerPage()]
  ];
  @override
  void initState() {
    _bIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      items: _bnbItems
          .map((e) => BottomNavigationBarItem(
                title: Text(e[0]),
                icon: Icon(Icons.ac_unit),
              ))
          .toList(),
      currentIndex: _bIndex,
      onTap: (val) {
        setState(() {
          _bIndex = val;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => _bnbItems[val][1]),
              (route) => false);
        });
      },
    );
  }
}
