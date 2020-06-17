import 'package:aksara/src/blocs/leaderboard_bloc_provider.dart';
import 'package:aksara/src/models/leaderboard_model.dart';
import 'package:aksara/src/ui/widgets/app_bar_custom.dart';
import 'package:aksara/src/global_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Leaderboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LeaderboardState();
  }
}

class LeaderboardState extends State<Leaderboard> {
  LeaderboardBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = LeaderboardBlocProvider.of(context);
    bloc.getLeaderboard(context);
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
          title: 'Leaderboard',
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: StreamBuilder<LeaderboardModel>(
        stream: bloc.leaderboard,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return ListView.separated(
              itemCount: snapshot.data.users.length,
              itemBuilder: (BuildContext context, int index) {
                IconData level;
                if (index == 0)
                  level = FontAwesomeIcons.chessKing;
                else if (index == 1)
                  level = FontAwesomeIcons.chessQueen;
                else if (index == 2)
                  level = FontAwesomeIcons.chessRook;
                else if (index == 3)
                  level = FontAwesomeIcons.chessBishop;
                else if (index == 4)
                  level = FontAwesomeIcons.chessKnight;
                else
                  level = FontAwesomeIcons.chessPawn;

                String callName;
                if (snapshot.data.users[index].name == null)
                  callName = snapshot.data.users[index].email.toString();
                else
                  callName = snapshot.data.users[index].name.toString();
                if (callName.length > 10)
                  callName = '${callName.substring(0, 10)}...';

                return Container(
                  padding: EdgeInsets.all(8.0),
                  color: GlobalData.GREY_LIGHT_COLOR,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          level,
                          size: 24,
                          color: GlobalData.TEXT_COLOR,
                        ),
                        Text(
                          '$callName',
                          style: TextStyle(
                            color: GlobalData.TEXT_COLOR,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Column(children: <Widget>[
                          Text(
                            'level ${snapshot.data.users[index].level}',
                            style: TextStyle(
                              color: GlobalData.PRIMARY_COLOR,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'poin ${snapshot.data.users[index].point}',
                            style: TextStyle(
                              color: GlobalData.TEXT_COLOR,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ]),
                      ]),
                );
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
}
