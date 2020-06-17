import 'package:aksara/src/blocs/content_bloc.dart';
import 'package:flutter/material.dart';
export 'package:aksara/src/blocs/content_bloc.dart';

class ContentBlocProvider extends InheritedWidget {
  final ContentBloc bloc;

  ContentBlocProvider({Key key, Widget child})
      : bloc = ContentBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static ContentBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ContentBlocProvider)
            as ContentBlocProvider)
        .bloc;
  }
}
