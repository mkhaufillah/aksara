import 'package:aksara/src/blocs/home_bloc.dart';
import 'package:flutter/material.dart';
export 'package:aksara/src/blocs/home_bloc.dart';

class HomeBlocProvider extends InheritedWidget {
  final HomeBloc bloc;

  HomeBlocProvider({Key key, Widget child})
      : bloc = HomeBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static HomeBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(HomeBlocProvider)
            as HomeBlocProvider)
        .bloc;
  }
}
