import 'package:aksara/src/blocs/leaderboard_bloc.dart';
import 'package:flutter/material.dart';
export 'package:aksara/src/blocs/leaderboard_bloc.dart';

class LeaderboardBlocProvider extends InheritedWidget {
  final LeaderboardBloc bloc;

  LeaderboardBlocProvider({Key key, Widget child})
      : bloc = LeaderboardBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static LeaderboardBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(LeaderboardBlocProvider)
            as LeaderboardBlocProvider)
        .bloc;
  }
}
