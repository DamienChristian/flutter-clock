import 'package:flutter/material.dart';

class PresetTimer extends StatefulWidget {
  final List<Map<String, String>> timerList;
  final Function changeData;

  const PresetTimer({
    Key key,
    this.timerList,
    this.changeData,
  }) : super(key: key);

  @override
  _PresetTimerState createState() => _PresetTimerState();
}

class _PresetTimerState extends State<PresetTimer> {
  List<Map<String, String>> items;
  List<Map<String, String>> selected = [];
  Map<String, String> selectedItem;

  String mode = 'none';

  Widget itemContainer(String key, String value, bool toShow, bool isSelected) {
    return Stack(
      children: <Widget>[
        Container(
          height: 100,
          width: 100,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: (isSelected) ? null : Colors.grey[300],
            border: (isSelected)
                ? Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (value != '')
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: (isSelected) ? Theme.of(context).primaryColor : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              SizedBox(
                height: 3,
              ),
              Text(
                key,
                style: TextStyle(
                  fontSize: 16,
                  color: (isSelected) ? Theme.of(context).primaryColor : null,
                ),
              ),
            ],
          ),
        ),
        if (mode == 'select')
          Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: (toShow) ? Theme.of(context).primaryColor : null,
              borderRadius: BorderRadius.circular(12.5),
              border: Border.all(color: Colors.black26),
            ),
          )
      ],
    );
  }

  @override
  void initState() {
    items = widget.timerList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.timerList
              .map(
                (e) => GestureDetector(
                  onLongPress: () {
                    setState(() {
                      mode = 'select';
                      selected.add(e);
                    });
                  },
                  onTap: () {
                    setState(() {
                      if (mode == 'select') {
                        if (selected.contains(e)) {
                          selected.remove(e);
                        } else {
                          selected.add(e);
                        }
                      } else if (mode == 'none') {
                        setState(() {
                          selectedItem = e;
                          String time = e.keys.toList()[0];
                          List timeList = time
                              .split(' : ')
                              .map((e) => int.parse(e))
                              .toList();
                          if (timeList.length == 2) {
                            timeList.insert(0, 00);
                          }
                          widget.changeData(
                            timeList[0],
                            timeList[1],
                            timeList[2],
                          );
                        });
                      }
                    });
                  },
                  child: itemContainer(
                      e.keys.toList()[0],
                      e[e.keys.toList()[0]],
                      selected.contains(e),
                      selectedItem == e),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
