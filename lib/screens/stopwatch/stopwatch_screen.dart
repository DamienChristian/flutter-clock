import 'dart:async';

import 'package:clock/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:clock/button.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  String mode = 'none';
  Stopwatch stopwatch = Stopwatch();
  Stopwatch secStopwatch = Stopwatch();
  Timer timer;

  String time = '00 : 00 . 00';
  String secondaryTime = '';
  Duration lastTime = Duration(minutes: 0, seconds: 0, milliseconds: 0);

  List lapData = [];

  Widget listElement(
      String lap, String lapTime, String overallTime, bool isHeader) {
    return Row(
      children: <Widget>[
        Container(
          width: 102.7,
          height: (isHeader) ? 40 : 50,
          alignment: Alignment.center,
          child: Text(
            lap,
            style: TextStyle(
              color: (isHeader) ? Colors.grey[600] : Colors.grey,
              fontSize: (isHeader) ? 20 : 18,
            ),
          ),
        ),
        Container(
          width: 130,
          height: (isHeader) ? 40 : 50,
          alignment: Alignment.center,
          child: Text(
            lapTime,
            style: TextStyle(
              color: (isHeader) ? Colors.grey[600] : Colors.grey,
              fontSize: (isHeader) ? 20 : 18,
            ),
          ),
        ),
        Container(
          width: 130,
          height: (isHeader) ? 40 : 50,
          alignment: Alignment.center,
          child: Text(
            overallTime,
            style: TextStyle(
              color: (isHeader) ? Colors.grey[600] : Colors.grey,
              fontSize: (isHeader) ? 20 : 18,
            ),
          ),
        ),
      ],
    );
  }

  void refreshScreen() {
    setState(() {
      time =
          '${stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')} : ${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')} . ${(stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
      secondaryTime =
          '${secStopwatch.elapsed.inMinutes.toString().padLeft(2, '0')} : ${(secStopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')} . ${(secStopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch'),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(
        index: 1,
      ),
      backgroundColor: Theme.of(context).cardColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 45,
                  ),
                ),
                if (lapData.length > 0)
                  SizedBox(
                    height: 10,
                  ),
                if (lapData.length > 0)
                  Text(
                    secondaryTime,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            height: 290,
            child: (lapData.length > 0)
                ? Column(
                    children: <Widget>[
                      listElement('Lap', 'Lap times', ' Overall time', true),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                      ),
                      Container(
                        height: 204,
                        child: ListView.builder(
                            itemCount: lapData.length,
                            itemBuilder: (context, index) {
                              List data = lapData[index];
                              return listElement(
                                data[0].toString(),
                                data[1].toString(),
                                data[2].toString(),
                                false,
                              );
                            }),
                      ),
                    ],
                  )
                : null,
          ),
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.topCenter,
            child: (mode == 'none')
                ? AppButton(
                    text: 'Start',
                    onTap: () {
                      setState(() {
                        mode = 'running';
                        stopwatch.start();
                        secStopwatch.start();
                        timer = Timer.periodic(Duration(milliseconds: 10), (t) {
                          refreshScreen();
                        });
                      });
                    },
                    height: 50,
                    width: 120,
                    color: Theme.of(context).primaryColor,
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      AppButton(
                        text: (mode == 'running') ? 'Stop' : 'Resume',
                        onTap: () {
                          setState(() {
                            if (mode == 'running') {
                              mode = 'paused';
                              stopwatch.stop();
                              secStopwatch.stop();
                            } else if (mode == 'paused') {
                              mode = 'running';
                              stopwatch.start();
                              secStopwatch.start();
                            }
                          });
                        },
                        height: 50,
                        width: 120,
                        color: (mode == 'running')
                            ? Colors.pinkAccent
                            : Theme.of(context).primaryColor,
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppButton(
                        text: (mode == 'running') ? 'Lap' : 'Reset',
                        onTap: () {
                          if (mode == 'paused') {
                            setState(() {
                              mode = 'none';
                              stopwatch.stop();
                              stopwatch.reset();
                              secStopwatch.stop();
                              secStopwatch.reset();
                              timer.cancel();
                              lapData = [];
                              time = '00 : 00 . 00';
                              lastTime = Duration(
                                  minutes: 0, seconds: 0, milliseconds: 0);
                            });
                          } else if (mode == 'running') {
                            secStopwatch.reset();
                            Duration curr = Duration(
                              minutes: int.parse(time.substring(0, 2)),
                              seconds: int.parse(time.substring(5, 7)),
                              milliseconds: int.parse(time.substring(10, 12)),
                            );
                            Duration diff = curr - lastTime;
                            lapData.insert(0, [
                              lapData.length + 1,
                              '${diff.inMinutes.toString().padLeft(2, '0')}:${(diff.inSeconds % 60).toString().padLeft(2, '0')}.${(diff.inMilliseconds % 100).toString().padLeft(2, '0')}',
                              '${curr.inMinutes.toString().padLeft(2, '0')}:${(curr.inSeconds % 60).toString().padLeft(2, '0')}.${(curr.inMilliseconds % 100).toString().padLeft(2, '0')}',
                            ]);
                            lastTime = curr;
                          }
                        },
                        height: 50,
                        width: 120,
                        color: Colors.grey,
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
