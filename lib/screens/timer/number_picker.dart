import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NumberPicker extends StatelessWidget {
  static const double kDefaultItemExtent = 50.0;
  static const double kDefaultListViewCrossAxisSize = 100.0;

  NumberPicker({
    Key key,
    @required this.selectedIntValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    this.itemExtent = kDefaultItemExtent,
    this.listViewWidth = kDefaultListViewCrossAxisSize,
    this.zeroPad = false,
    this.decoration,
    this.labelText,
    this.labelTextStyle,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.controller,
  })  : assert(selectedIntValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        assert(selectedIntValue >= minValue && selectedIntValue <= maxValue),
        intScrollController = controller,
        listViewHeight = 3 * itemExtent,
        integerItemCount = (maxValue - minValue) + 1,
        super(key: key);

  final ValueChanged<num> onChanged;
  final int minValue;
  final int maxValue;
  final double itemExtent;
  final double listViewHeight;
  final double listViewWidth;
  final ScrollController intScrollController;
  final int selectedIntValue;
  final Decoration decoration;
  final bool zeroPad;
  final int integerItemCount;
  final ScrollController controller;

  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;
  final TextStyle labelTextStyle;
  final String labelText;

  int _intValueFromIndex(int index) {
    index--;
    index %= integerItemCount;
    return minValue + index * 1;
  }

  void animateInt(int valueToSelect) {
    int diff = valueToSelect - minValue;
    int index = diff ~/ 1;
    animateIntToIndex(index);
  }

  void animateIntToIndex(int index) {
    intScrollController.animateTo(index * itemExtent,
        duration: new Duration(seconds: 1), curve: new ElasticOutCurve());
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return _integerListView(themeData);
  }

  Widget _integerListView(ThemeData themeData) {
    TextStyle defaultStyle = (unselectedTextStyle != null)
        ? unselectedTextStyle
        : themeData.textTheme.bodyText2;
    TextStyle selectedStyle = (selectedTextStyle != null)
        ? selectedTextStyle
        : themeData.textTheme.headline5.copyWith(color: themeData.accentColor);
    var listItemCount = integerItemCount + 2;

    return Listener(
      onPointerUp: (ev) {
        if (intScrollController.position.activity is HoldScrollActivity) {
          animateInt(selectedIntValue);
        }
      },
      child: new NotificationListener(
        child: Column(
          children: <Widget>[
            if (labelText != null)
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  labelText,
                  style:
                      (labelTextStyle != null) ? labelTextStyle : defaultStyle,
                ),
              ),
            new Container(
              height: listViewHeight,
              width: listViewWidth,
              child: new ListView.builder(
                controller: intScrollController,
                itemExtent: itemExtent,
                itemCount: listItemCount,
                cacheExtent: _calculateCacheExtent(listItemCount),
                itemBuilder: (BuildContext context, int index) {
                  final int value = _intValueFromIndex(index);
                  final TextStyle itemStyle =
                      value == selectedIntValue ? selectedStyle : defaultStyle;
                  return index == 0 || index == listItemCount - 1
                      ? new Container()
                      : new Center(
                          child: new Text(
                            getDisplayedValue(value),
                            style: itemStyle,
                          ),
                        );
                },
              ),
            ),
          ],
        ),
        onNotification: _onIntegerNotification,
      ),
    );
  }

  String getDisplayedValue(int value) {
    final text = zeroPad
        ? value.toString().padLeft(maxValue.toString().length, '0')
        : value.toString();
    return text;
  }

  bool _onIntegerNotification(Notification notification) {
    if (notification is ScrollNotification) {
      int intIndexOfMiddleElement =
          (notification.metrics.pixels / itemExtent).round();
      intIndexOfMiddleElement =
          intIndexOfMiddleElement.clamp(0, integerItemCount - 1);
      int intValueInTheMiddle = _intValueFromIndex(intIndexOfMiddleElement + 1);
      intValueInTheMiddle =
          _normalizeMiddleValue(intValueInTheMiddle, minValue, maxValue);
      if (notification is UserScrollNotification &&
          notification.direction == ScrollDirection.idle &&
          intScrollController.position.activity is! HoldScrollActivity) {
        animateIntToIndex(intIndexOfMiddleElement);
      }
      if (intValueInTheMiddle != selectedIntValue) {
        num newValue;
        newValue = (intValueInTheMiddle);
        onChanged(newValue);
      }
    }
    return true;
  }

  double _calculateCacheExtent(int itemCount) {
    double cacheExtent = 250.0; //default cache extent
    if ((itemCount - 2) * kDefaultItemExtent <= cacheExtent) {
      cacheExtent = ((itemCount - 3) * kDefaultItemExtent);
    }
    return cacheExtent;
  }

  int _normalizeMiddleValue(int valueInTheMiddle, int min, int max) {
    return math.max(math.min(valueInTheMiddle, max), min);
  }
}
