import 'package:aksara/src/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
export 'package:aksara/src/blocs/auth_bloc.dart';

class AuthBlocProvider extends InheritedWidget {
  final AuthBloc bloc;

  AuthBlocProvider({Key key, Widget child})
      : bloc = AuthBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static AuthBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AuthBlocProvider)
            as AuthBlocProvider)
        .bloc;
  }
}
