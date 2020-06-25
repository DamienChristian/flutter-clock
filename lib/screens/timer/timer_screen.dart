import 'package:clock/bottom_navbar.dart';
import 'package:clock/button.dart';
import 'package:clock/screens/timer/timer_data.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;
import './number_picker.dart';
import './preset_timer_list_element.dart';

enum TimerMode {
  Running,
  Paused,
  Stationary,
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  int hr = 0;
  int min = 0;
  int sec = 0;

  int diff = 1000;

  TextEditingController hrController;
  TextEditingController minController;
  TextEditingController secController;
  TextEditingController nameController;

  ScrollController hrScrollController;
  ScrollController minScrollController;
  ScrollController secScrollController;

  NumberPicker npH;
  NumberPicker npM;
  NumberPicker npS;

  TimerMode mode = TimerMode.Stationary;
  Duration timerDur;

  AnimationController controller;

  List<Map<String, String>> timerList = timerData.mainData;

  void changeValues(int hourD, int minuteD, int secondD) {
    setState(() {
      hr = hourD;
      npH.animateInt(hr);
      min = minuteD;
      npM.animateInt(min);
      sec = secondD;
      npS.animateInt(sec);
    });
  }

  String getTimerString() {
    Duration newDur = timerDur * controller.value;
    if (newDur < Duration(microseconds: 1)) {
      controller.stop();
      return '00 : 00 : 00';
    }
    return '${(newDur.inHours).toString().padLeft(2, '0')} : ${(newDur.inMinutes % 60).toString().padLeft(2, '0')} : ${((newDur.inSeconds + 1) % 60).toString().padLeft(2, '0')}';
  }

  NumberPicker numberPicker(String mode) {
    return NumberPicker(
      minValue: 0,
      maxValue: (mode == 'Hours') ? 99 : 59,
      itemExtent: 70,
      controller: (mode == 'Hours')
          ? hrScrollController
          : (mode == 'Minutes') ? minScrollController : secScrollController,
      selectedIntValue:
          (mode == 'Hours') ? hr : (mode == 'Minutes') ? min : sec,
      listViewWidth: (MediaQuery.of(context).size.width - 120) / 3,
      zeroPad: true,
      labelText: mode,
      selectedTextStyle: TextStyle(
        fontSize: 50,
      ),
      labelTextStyle: TextStyle(
        fontSize: 17,
      ),
      unselectedTextStyle: TextStyle(
        fontSize: 50,
        color: Colors.grey,
      ),
      onChanged: (num n) {
        setState(() {
          (mode == 'Hours') ? hr = n : (mode == 'Minutes') ? min = n : sec = n;
        });
      },
    );
  }

  Widget getDots(double height) {
    return Container(
      height: height * 2,
      alignment: Alignment.center,
      child: Text(
        ':',
        style: TextStyle(fontSize: 50),
      ),
    );
  }

  void modalSheet() {
    hrController = TextEditingController(text: hr.toString().padLeft(2, '0'));
    minController = TextEditingController(text: min.toString().padLeft(2, '0'));
    secController = TextEditingController(text: sec.toString().padLeft(2, '0'));
    nameController = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: 230,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(30),
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).viewInsets.vertical + 15),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Wrap(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Add preset timer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 45,
                          child: TextField(
                            controller: hrController,
                            showCursor: false,
                            decoration: null,
                            textAlign: TextAlign.center,
                            enableInteractiveSelection: false,
                            onChanged: (val) {},
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 35,
                            ),
                          ),
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 35,
                          ),
                        ),
                        Container(
                          width: 45,
                          child: TextField(
                            controller: minController,
                            showCursor: false,
                            decoration: null,
                            textAlign: TextAlign.center,
                            enableInteractiveSelection: false,
                            onChanged: (val) {},
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 35,
                            ),
                          ),
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 35,
                          ),
                        ),
                        Container(
                          width: 45,
                          child: TextField(
                            controller: secController,
                            showCursor: false,
                            decoration: null,
                            textAlign: TextAlign.center,
                            enableInteractiveSelection: false,
                            onChanged: (val) {},
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: 'Preset timer name', isDense: true),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 150,
                            child: FlatButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.grey[200],
                            indent: 15,
                            endIndent: 15,
                            thickness: 2,
                            width: 2,
                          ),
                          Container(
                            width: 150,
                            child: FlatButton(
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                timerData.mainData.add({
                                  hrController.text +
                                      ' : ' +
                                      minController.text +
                                      ' : ' +
                                      secController.text: nameController.text
                                });
                                setState(() {
                                  timerList.add({
                                    hrController.text +
                                        ' : ' +
                                        minController.text +
                                        ' : ' +
                                        secController.text: nameController.text
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget timerAppBar() {
    return AppBar(
      title: Text('Timer'),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            modalSheet();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            size: 30,
          ),
          onPressed: () {},
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    hrScrollController = ScrollController();
    minScrollController = ScrollController();
    secScrollController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    npH = numberPicker('Hours');
    npM = numberPicker('Minutes');
    npS = numberPicker('Seconds');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: timerAppBar(),
      backgroundColor: Theme.of(context).cardColor,
      bottomNavigationBar: BottomNavbar(
        index: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (mode == TimerMode.Stationary)
              Container(
                height: MediaQuery.of(context).size.height / 2 - 50,
                padding: EdgeInsets.symmetric(vertical: 30),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    numberPicker('Hours'),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: getDots(65),
                    ),
                    numberPicker('Minutes'),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: getDots(65),
                    ),
                    numberPicker('Seconds'),
                  ],
                ),
              )
            else
              Container(
                height: (MediaQuery.of(context).size.height / 2 - 72) +
                    (MediaQuery.of(context).size.height / 5 + 20),
                width: double.infinity,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: AnimatedBuilder(
                        animation: controller,
                        builder: (context, wid) {
                          return Text(
                            getTimerString(),
                            style: TextStyle(
                              fontSize: 50,
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: AnimatedBuilder(
                        animation: controller,
                        builder: (context, wid) {
                          return CustomPaint(
                            painter: TimerPainter(
                              arcRadian: controller.value * math.pi * 2,
                              animation: controller,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (mode == TimerMode.Stationary)
              PresetTimer(
                timerList: timerList,
                changeData: changeValues,
              ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              alignment: Alignment.center,
              child: (mode == TimerMode.Stationary)
                  ? AppButton(
                      text: 'Start',
                      color: Theme.of(context).primaryColor,
                      onTap: () {
                        timerDur = Duration(
                          hours: hr,
                          minutes: min,
                          seconds: sec,
                        );
                        setState(() {
                          controller = AnimationController(
                            vsync: this,
                            duration: timerDur,
                          );
                          controller.addStatusListener((status) {
                            if (status == AnimationStatus.dismissed) {
                              setState(() {
                                mode = TimerMode.Stationary;
                              });
                            }
                          });
                          controller.reverse(from: 1);
                          mode = TimerMode.Running;
                        });
                      },
                      height: 50,
                      width: 120,
                      textStyle: TextStyle(fontSize: 20),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        AppButton(
                          text:
                              (mode == TimerMode.Running) ? 'Pause' : 'Resume',
                          color: (mode == TimerMode.Running)
                              ? Colors.pinkAccent
                              : Theme.of(context).primaryColor,
                          onTap: () {
                            setState(() {
                              if (mode == TimerMode.Running) {
                                controller.stop(canceled: true);
                                mode = TimerMode.Paused;
                              } else {
                                controller.reverse(from: controller.value);
                                mode = TimerMode.Running;
                              }
                            });
                          },
                          height: 50,
                          width: 120,
                          textStyle: TextStyle(fontSize: 20),
                        ),
                        AppButton(
                          text: 'Cancel',
                          color: Colors.grey,
                          onTap: () {
                            setState(() {
                              controller.stop(canceled: true);
                              mode = TimerMode.Stationary;
                            });
                          },
                          height: 50,
                          width: 120,
                          textStyle: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final arcRadian;
  final animation;

  TimerPainter({
    this.arcRadian,
    this.animation,
  }) : super(repaint: animation);

  Paint _paint = Paint()
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 6
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = Colors.blueGrey[50];
    canvas.drawCircle(Offset.zero, 150, _paint);
    _paint.color = Colors.tealAccent[400];
    canvas.drawArc(Rect.fromCircle(center: Offset.zero, radius: 150),
        3 * math.pi / 2, arcRadian, false, _paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value;
  }
}
