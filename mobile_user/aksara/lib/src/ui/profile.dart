import 'package:aksara/src/blocs/profile_bloc_provider.dart';
import 'package:aksara/src/blocs/update_bio_bloc_provider.dart';
import 'package:aksara/src/models/achievement_model.dart';
import 'package:aksara/src/models/history_model.dart';
import 'package:aksara/src/models/user_model.dart';
import 'package:aksara/src/ui/update_bio.dart';
import 'package:aksara/src/ui/widgets/app_bar_custom.dart';
import 'package:aksara/src/ui/widgets/btn_custom.dart';
import 'package:aksara/src/global_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

class Profile extends StatefulWidget {
  final User user;
  final AchievementModel achievement;

  Profile({
    this.user,
    this.achievement,
  });

  @override
  State<StatefulWidget> createState() {
    return ProfileState(
      user: user,
      achievement: achievement,
    );
  }
}

class ProfileState extends State<Profile> {
  final User user;
  final AchievementModel achievement;

  ProfileBloc bloc;

  ProfileState({
    this.user,
    this.achievement,
  });

  @override
  void didChangeDependencies() {
    bloc = ProfileBlocProvider.of(context);
    bloc.getHistory(context);
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
          title: 'Profil',
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: StreamBuilder<HistoryModel>(
        stream: bloc.history,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return ListView.separated(
              padding: const EdgeInsets.all(20.0),
              itemCount: snapshot.data.histories.length,
              itemBuilder: (BuildContext context, int index) {
                Widget elem;
                if (snapshot.data.histories[index] != null) {
                  DateTime date = DateTime.parse(
                    snapshot.data.histories[index].createdAt.toString(),
                  );
                  elem = Container(
                    height: 50,
                    color: GlobalData.GREY_LIGHT_COLOR,
                    child: Center(
                      child: Text(
                          'Tambahan poin ${snapshot.data.histories[index].point} pada ${date.day}/${date.month}/${date.year}'),
                    ),
                  );
                } else
                  elem = Container();
                if (index == 0)
                  return Column(
                    children: <Widget>[
                      Container(
                        child: profileUI(),
                      ),
                      elem,
                    ],
                  );
                return elem;
              },
              separatorBuilder: (BuildContext context, int index) => Container(
                height: 1,
                color: GlobalData.GREY_COLOR,
              ),
            );
          return SpinKitThreeBounce(
            color: GlobalData.TEXT_COLOR,
            size: 28.0,
          );
        },
      ),
    );
  }

  Widget profileUI() {
    String callName;
    String faculty;
    String studyProgram;
    String generation;
    if (user.name == null)
      callName = user.email.toString();
    else
      callName = user.name.toString();
    if (callName.length > 10) callName = '${callName.substring(0, 10)}...';

    if (user.faculty == null)
      faculty = 'Fakultas kosong';
    else
      faculty = user.faculty.toString();
    if (faculty.length > 25) faculty = '${faculty.substring(0, 25)}...';

    if (user.studyProgram == null)
      studyProgram = 'Jurusan kosong';
    else
      studyProgram = user.studyProgram.toString();
    if (studyProgram.length > 20)
      studyProgram = '${studyProgram.substring(0, 20)}...';

    if (user.generation == null)
      generation = '0000';
    else
      generation = user.generation.toString();

    double iWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: Center(
            child: Text(
              callName,
              style: TextStyle(
                color: GlobalData.PRIMARY_COLOR,
                fontWeight: FontWeight.w900,
                fontSize: iWidth * 0.07,
              ),
            ),
          ),
        ),
        Container(
          child: Center(
            child: Text(
              faculty,
              style: TextStyle(
                color: GlobalData.TEXT_COLOR,
                fontWeight: FontWeight.w900,
                fontSize: iWidth * 0.05,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 30.0),
          child: Center(
            child: Text(
              '$studyProgram / $generation',
              style: TextStyle(
                color: GlobalData.TEXT_COLOR,
                fontWeight: FontWeight.w900,
                fontSize: iWidth * 0.05,
              ),
            ),
          ),
        ),
        badge(iWidth),
        BtnCustom(
          name: 'Edit Profile',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateBioBlocProvider(
                child: UpdateBio(),
              ),
            ),
          ),
          margin: 0.0,
        ),
        Container(height: 20),
        BtnCustom(
          name: 'Share Sosial Media',
          onPressed: () {
            Share.share(
                "hallo, saya sudah bergabung di Aksara UB. Cek infonya melalui https://aksara.ub.ac.id/show?email=${user.email}");
          },
          margin: 0.0,
        ),
        Container(height: 20),
        BtnCustom(
          name: 'Logout',
          onPressed: () => showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Kamu yakin?'),
              content: new Text('Apakah kamu ingin logout?'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text(
                    'No',
                    style: TextStyle(color: GlobalData.TEXT_COLOR),
                  ),
                ),
                new FlatButton(
                  onPressed: () => bloc.logout(context),
                  child: new Text(
                    'Yes',
                    style: TextStyle(color: GlobalData.PRIMARY_COLOR),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: GlobalData.ERROR_COLOR,
          margin: 0.0,
        ),
        Container(height: 20),
      ],
    );
  }

  Widget badge(iWidth) {
    IconData level;
    if (achievement.content.rank == 1)
      level = FontAwesomeIcons.chessKing;
    else if (achievement.content.rank == 2)
      level = FontAwesomeIcons.chessQueen;
    else if (achievement.content.rank == 3)
      level = FontAwesomeIcons.chessRook;
    else if (achievement.content.rank == 4)
      level = FontAwesomeIcons.chessBishop;
    else if (achievement.content.rank == 5)
      level = FontAwesomeIcons.chessKnight;
    else
      level = FontAwesomeIcons.chessPawn;
    return Container(
      decoration: BoxDecoration(color: GlobalData.ACCENT_COLOR),
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: <Widget>[
          Icon(
            level,
            size: 48,
            color: GlobalData.TEXT_COLOR,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  'Rangking ${achievement.content.rank}',
                  style: TextStyle(
                    color: GlobalData.TEXT_COLOR,
                    fontWeight: FontWeight.w800,
                    fontSize: iWidth * 0.05,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  'Level ${achievement.content.level}',
                  style: TextStyle(
                    color: GlobalData.PRIMARY_COLOR,
                    fontWeight: FontWeight.w900,
                    fontSize: iWidth * 0.06,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
