import 'package:aksara/src/global_data.dart';
import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget {
  AppBarCustom({this.title}) : super();

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: GlobalData.PRIMARY_COLOR,
          offset: Offset(0, 9.0),
          blurRadius: 0.0,
        )
      ]),
      child: AppBar(
        title: Text(
          (this.title == null) ? 'AppBarCustom' : this.title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      margin: EdgeInsets.only(bottom: 10.0),
    );
  }
}
