import 'package:aksara/src/blocs/profile_bloc.dart';
import 'package:flutter/material.dart';
export 'package:aksara/src/blocs/profile_bloc.dart';

class ProfileBlocProvider extends InheritedWidget {
  final ProfileBloc bloc;

  ProfileBlocProvider({Key key, Widget child})
      : bloc = ProfileBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static ProfileBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ProfileBlocProvider)
            as ProfileBlocProvider)
        .bloc;
  }
}
