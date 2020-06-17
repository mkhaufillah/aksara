import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/ui/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBarCustom(
          title: 'About',
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: SingleChildScrollView(
        child: homeUI(context),
      ),
    );
  }

  Widget homeUI(context) {
    double iWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: <Widget>[
          sectionOne(iWidth),
          sectionTwo(iWidth),
          sectionThree(iWidth),
          sectionFour(iWidth),
          sectionFive(iWidth),
        ],
      ),
    );
  }

  Widget sectionOne(iWidth) {
    return Container(
      width: iWidth,
      decoration: BoxDecoration(color: GlobalData.GREY_LIGHT_COLOR),
      padding: EdgeInsets.only(
        top: 30,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Text(
        'Aksara Brawijaya',
        style: TextStyle(
          color: GlobalData.TEXT_COLOR,
          fontWeight: FontWeight.w900,
          fontSize: iWidth * 0.1,
        ),
      ),
    );
  }

  Widget sectionTwo(iWidth) {
    return Container(
      decoration: BoxDecoration(color: GlobalData.BACKGROUND_COLOR),
      width: iWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20.0),
            width: iWidth * 0.5,
            child: Image.asset(
              'assets/images/confused.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 10.0,
              right: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Apa itu',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.08,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  'Aksara',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.06,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  'Brawijaya',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.06,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  '?',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.2,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionThree(iWidth) {
    return Container(
      decoration: BoxDecoration(color: GlobalData.GREY_LIGHT_COLOR),
      padding: EdgeInsets.all(20.0),
      width: iWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Aksara Brawijaya',
            style: TextStyle(
                color: GlobalData.TEXT_COLOR,
                fontSize: iWidth * 0.06,
                fontWeight: FontWeight.w900),
          ),
          Text(
            'Aplikasi Etika Komunikasi dan Tindak Korupsi Akademik Brawijaya',
            style: TextStyle(
                color: GlobalData.TEXT_COLOR,
                fontSize: iWidth * 0.043,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget sectionFour(iWidth) {
    return Container(
      decoration: BoxDecoration(color: GlobalData.BACKGROUND_COLOR),
      width: iWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            width: iWidth * 0.5,
            child: Image.asset(
              'assets/images/mission.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 10.0,
              right: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Selesaikan',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.05,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  'misi yang',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.05,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  'diberikan',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.05,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  'dan dapatkan',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.05,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  'point',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.07,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionFive(iWidth) {
    return Container(
      decoration: BoxDecoration(color: GlobalData.GREY_LIGHT_COLOR),
      width: iWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 10.0,
              right: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Dengan',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.PRIMARY_COLOR,
                      fontSize: iWidth * 0.04,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  'menyelesaikan misi,',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.PRIMARY_COLOR,
                      fontSize: iWidth * 0.04,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  'kamu bisa',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.05,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  'mengetahui',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.05,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  'etika komunikasi',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.PRIMARY_COLOR,
                      fontSize: iWidth * 0.04,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  'dan tidak korupsi',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.PRIMARY_COLOR,
                      fontSize: iWidth * 0.04,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  'di lingkungan UB',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.04,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            width: iWidth * 0.4,
            child: Image.asset(
              'assets/images/laugh.png',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
