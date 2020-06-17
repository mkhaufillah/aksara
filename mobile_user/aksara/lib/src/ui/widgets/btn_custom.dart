import 'package:aksara/src/global_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BtnCustom extends StatelessWidget {
  BtnCustom({
    @required this.name,
    @required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.shadowColor,
    this.margin,
  });

  final String name;
  final GestureTapCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color shadowColor;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all((margin != null) ? margin : 12.0),
      height: 50.0,
      decoration: BoxDecoration(
        color: (backgroundColor != null)
            ? backgroundColor
            : GlobalData.PRIMARY_COLOR,
        boxShadow: [
          BoxShadow(
            color:
                (shadowColor != null) ? shadowColor : GlobalData.ACCENT_COLOR,
            offset: Offset(4.0, 4.0),
            blurRadius: 0.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: (textColor != null)
                      ? textColor
                      : GlobalData.BACKGROUND_COLOR,
                ),
              ),
            )),
      ),
    );
  }
}
