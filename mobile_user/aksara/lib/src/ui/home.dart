import 'dart:async';

import 'package:aksara/src/blocs/document_list_bloc_provider.dart';
import 'package:aksara/src/blocs/home_bloc_provider.dart';
import 'package:aksara/src/blocs/leaderboard_bloc_provider.dart';
import 'package:aksara/src/blocs/profile_bloc_provider.dart';
import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/models/achievement_model.dart';
import 'package:aksara/src/models/user_model.dart';
import 'package:aksara/src/ui/about.dart';
import 'package:aksara/src/ui/document_list.dart';
import 'package:aksara/src/ui/leaderboard.dart';
import 'package:aksara/src/ui/profile.dart';
import 'package:aksara/src/ui/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_introduction_tooltip/flutter_introduction_tooltip.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  AchievementModel achievementModel = AchievementModel.init();
  HomeBloc bloc;

  GlobalKey pointKey = GlobalKey();
  bool pointIsShowing = false;
  GlobalKey rangkingKey = GlobalKey();
  bool rangkingIsShowing = false;
  GlobalKey levelKey = GlobalKey();
  bool levelIsShowing = false;
  GlobalKey missionKey = GlobalKey();
  bool missionIsShowing = false;
  GlobalKey aboutKey = GlobalKey();
  bool aboutIsShowing = false;
  GlobalKey profileKey = GlobalKey();
  bool profileIsShowing = false;
  GlobalKey leaderboardKey = GlobalKey();
  bool leaderboardIsShowing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    bloc = HomeBlocProvider.of(context);
    bloc.fetchUser(context);
    bloc.getAchievement(context);
    bloc.setStateFromStorage();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBarCustom(
          title: 'Aksara',
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: StreamBuilder<UserModel>(
        stream: bloc.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data.data;
            return StreamBuilder<bool>(
              stream: bloc.state,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (!snapshot.data) pointTutorial(context);
                }
                return SingleChildScrollView(
                  child: homeUI(data),
                );
              },
            );
          }
          return Center(
            child: SpinKitHourGlass(
              color: GlobalData.TEXT_COLOR,
              size: 36.0,
            ),
          );
        },
      ),
    );
  }

  Widget homeUI(User user) {
    String callName;
    if (user.name == null)
      callName = user.email.toString();
    else
      callName = user.name.toString();
    if (callName.length > 5) callName = '${callName.substring(0, 5)}...';
    double iWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          sectionOne(iWidth),
          sectionThree(
            iWidth,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DocumentBlocProvider(
                  child: DocumentList(),
                ),
              ),
            ),
          ),
          sectionTwo(
            iWidth,
            callName,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => About()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              sectionFour(
                iWidth,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileBlocProvider(
                      child: Profile(
                        user: user,
                        achievement: achievementModel,
                      ),
                    ),
                  ),
                ),
              ),
              sectionFive(
                iWidth,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeaderboardBlocProvider(
                      child: Leaderboard(),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget sectionOne(iWidth) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      width: iWidth - 40,
      decoration: BoxDecoration(
        color: GlobalData.PRIMARY_COLOR,
      ),
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        bottom: 20.0,
        top: 20.0,
      ),
      child: StreamBuilder<AchievementModel>(
        stream: bloc.achievement,
        builder: (context, snapshot) {
          if (snapshot.hasData) achievementModel = snapshot.data;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: achievement(
                  iWidth,
                  FontAwesomeIcons.solidStar,
                  'Poin',
                  achievementModel.content.point,
                ),
                key: pointKey,
              ),
              Container(
                child: achievement(
                  iWidth,
                  FontAwesomeIcons.trophy,
                  'Rangking',
                  achievementModel.content.rank,
                ),
                key: rangkingKey,
              ),
              Container(
                child: achievement(
                  iWidth,
                  FontAwesomeIcons.fortAwesome,
                  'Level',
                  achievementModel.content.level,
                ),
                key: levelKey,
              )
            ],
          );
        },
      ),
    );
  }

  Widget achievement(iWidth, icon, title, value) {
    Widget elem;
    if (value != null)
      elem = Text(
        '$value',
        style: TextStyle(
          color: GlobalData.ACCENT_COLOR,
          fontWeight: FontWeight.w800,
          fontSize: iWidth * 0.05,
        ),
      );
    else
      elem = SpinKitThreeBounce(
        color: GlobalData.ACCENT_COLOR,
        size: 28.0,
      );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: GlobalData.BACKGROUND_COLOR,
          size: iWidth * 0.09,
        ),
        Container(
          margin: EdgeInsets.only(
            top: iWidth * 0.043,
            bottom: iWidth * 0.01,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: GlobalData.BACKGROUND_COLOR,
              fontWeight: FontWeight.w800,
              fontSize: iWidth * 0.043,
            ),
          ),
        ),
        elem,
      ],
    );
  }

  Widget sectionTwo(iWidth, callName, onPressed) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      width: iWidth - 40,
      decoration: BoxDecoration(color: GlobalData.GREY_LIGHT_COLOR, boxShadow: [
        BoxShadow(
          color: GlobalData.TEXT_COLOR,
          offset: Offset(4.0, 4.0),
          blurRadius: 0.0,
        ),
      ]),
      key: aboutKey,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10.0),
                width: (iWidth - 40) * 0.3,
                child: Image.asset(
                  'assets/images/happy.png',
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Halo, $callName',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: GlobalData.PRIMARY_COLOR,
                          fontSize: iWidth * 0.037,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Mau tau apa itu Aksara?',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: GlobalData.TEXT_COLOR,
                          fontSize: iWidth * 0.043,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Klik dong !!',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: GlobalData.PRIMARY_COLOR,
                          fontSize: iWidth * 0.037,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionThree(iWidth, onPressed) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      width: iWidth - 40,
      decoration: BoxDecoration(color: GlobalData.ACCENT_COLOR, boxShadow: [
        BoxShadow(
          color: GlobalData.PRIMARY_COLOR,
          offset: Offset(4.0, 4.0),
          blurRadius: 0.0,
        ),
      ]),
      key: missionKey,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Mau naik level?',
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.043,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  'Dapat poin?',
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.043,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  'Rangking meningkat?',
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.043,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  'Klik disini untuk menyelesaikan misi sekarang juga',
                  style: TextStyle(
                    color: GlobalData.PRIMARY_COLOR,
                    fontWeight: FontWeight.w700,
                    fontSize: iWidth * 0.037,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionFour(iWidth, onPressed) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: ((iWidth - 40) * 0.5) - 10,
      decoration: BoxDecoration(color: GlobalData.GREY_LIGHT_COLOR, boxShadow: [
        BoxShadow(
          color: GlobalData.TEXT_COLOR,
          offset: Offset(4.0, 4.0),
          blurRadius: 0.0,
        ),
      ]),
      key: profileKey,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.userAstronaut,
                  color: GlobalData.TEXT_COLOR,
                  size: iWidth * 0.15,
                ),
                Container(
                  margin: EdgeInsets.all(6.0),
                ),
                Text(
                  'Profil',
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.043,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionFive(iWidth, onPressed) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      width: ((iWidth - 40) * 0.5) - 10,
      decoration: BoxDecoration(color: GlobalData.GREY_LIGHT_COLOR, boxShadow: [
        BoxShadow(
          color: GlobalData.TEXT_COLOR,
          offset: Offset(4.0, 4.0),
          blurRadius: 0.0,
        ),
      ]),
      key: leaderboardKey,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.chess,
                  color: GlobalData.TEXT_COLOR,
                  size: iWidth * 0.15,
                ),
                Container(
                  margin: EdgeInsets.all(6.0),
                ),
                Text(
                  'Leaderboard',
                  style: TextStyle(
                      color: GlobalData.TEXT_COLOR,
                      fontSize: iWidth * 0.043,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pointTutorial(BuildContext context) async {
    if (!pointIsShowing) {
      new Timer(Duration(milliseconds: 100), () async {
        try {
          FlutterIntroductionTooltip.showBottomTutorialOnWidget(
            context,
            pointKey,
            GlobalData.PRIMARY_COLOR,
            () {
              Navigator.pop(context);
              rangkingTutorial(context);
            },
            "Poin",
            "Poin adalah skor kamu yang didapatkan ketika kamu berhasil mengerjakan kuis di misi.",
            "Lanjut",
          );
          setState(() {
            pointIsShowing = true;
          });
          bloc.setState();
        } catch (e) {
          print("ERROR $e");
        }
      });
    }
  }

  void rangkingTutorial(BuildContext context) async {
    if (!rangkingIsShowing) {
      new Timer(Duration(milliseconds: 100), () async {
        try {
          FlutterIntroductionTooltip.showBottomTutorialOnWidget(
            context,
            rangkingKey,
            GlobalData.PRIMARY_COLOR,
            () {
              Navigator.pop(context);
              levelTutorial(context);
            },
            "Rangking",
            "Rangking adalah letak peringkat kamu dari semua pengguna aksara. Semangat merebut peringkat satu diaksara dan menjadi yang terbaik.",
            "Lanjut",
          );
          setState(() {
            rangkingIsShowing = true;
          });
        } catch (e) {
          print("ERROR $e");
        }
      });
    }
  }

  void levelTutorial(BuildContext context) async {
    if (!levelIsShowing) {
      new Timer(Duration(milliseconds: 100), () async {
        try {
          FlutterIntroductionTooltip.showBottomTutorialOnWidget(
            context,
            levelKey,
            GlobalData.PRIMARY_COLOR,
            () {
              Navigator.pop(context);
              missionTutorial(context);
            },
            "Level",
            "Level menggambarkan tingkat kemampuan kamu dalam memahami konten aksara.",
            "Lanjut",
          );
          setState(() {
            levelIsShowing = true;
          });
        } catch (e) {
          print("ERROR $e");
        }
      });
    }
  }

  void missionTutorial(BuildContext context) async {
    if (!missionIsShowing) {
      new Timer(Duration(milliseconds: 100), () async {
        try {
          FlutterIntroductionTooltip.showBottomTutorialOnWidget(
            context,
            missionKey,
            GlobalData.PRIMARY_COLOR,
            () {
              Navigator.pop(context);
              aboutTutorial(context);
            },
            "Misi",
            "Bagian ini akan disediakan berbagai macam misi dan materi yang dapat kamu pelajari untuk mendapat poin dan menaikkan level.",
            "Lanjut",
          );
          setState(() {
            missionIsShowing = true;
          });
        } catch (e) {
          print("ERROR $e");
        }
      });
    }
  }

  void aboutTutorial(BuildContext context) async {
    if (!aboutIsShowing) {
      new Timer(Duration(milliseconds: 100), () async {
        try {
          FlutterIntroductionTooltip.showTopTutorialOnWidget(
            context,
            aboutKey,
            GlobalData.PRIMARY_COLOR,
            () {
              Navigator.pop(context);
              profileTutorial(context);
            },
            "Tentang aksara",
            "Kamu bingung apa itu aksara? kunjungi bagian ini.",
            "Lanjut",
          );
          setState(() {
            aboutIsShowing = true;
          });
        } catch (e) {
          print("ERROR $e");
        }
      });
    }
  }

  void profileTutorial(BuildContext context) async {
    if (!profileIsShowing) {
      new Timer(Duration(milliseconds: 100), () async {
        try {
          FlutterIntroductionTooltip.showTopTutorialOnWidget(
            context,
            profileKey,
            GlobalData.PRIMARY_COLOR,
            () {
              Navigator.pop(context);
              leaderboardTutorial(context);
            },
            "Profil",
            "Bagian ini akan ditampilkan semua informasi tentang dirimu.",
            "Lanjut",
          );
          setState(() {
            profileIsShowing = true;
          });
        } catch (e) {
          print("ERROR $e");
        }
      });
    }
  }

  void leaderboardTutorial(BuildContext context) async {
    if (!leaderboardIsShowing) {
      new Timer(Duration(milliseconds: 100), () async {
        try {
          FlutterIntroductionTooltip.showTopTutorialOnWidget(
            context,
            leaderboardKey,
            GlobalData.PRIMARY_COLOR,
            () {
              Navigator.pop(context);
            },
            "Leaderboard",
            "Bagian ini berisi posisi peringkat kamu dengan pengguna lain di aksara.",
            "Lanjut",
          );
          setState(() {
            leaderboardIsShowing = true;
          });
        } catch (e) {
          print("ERROR $e");
        }
      });
    }
  }
}
