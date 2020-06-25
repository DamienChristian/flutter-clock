import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Color color;
  final double height;
  final double width;
  final TextStyle textStyle;
  final Function onTap;

  const AppButton({
    Key key,
    this.text,
    this.color,
    this.height,
    this.width,
    this.textStyle,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: FlatButton(
        child: Text(
          text,
          style: textStyle,
        ),
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height / 2)),
        onPressed: onTap,
      ),
    );
  }
}
