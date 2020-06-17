import 'package:aksara/src/blocs/content_detail_bloc.dart';
import 'package:flutter/material.dart';
export 'package:aksara/src/blocs/content_detail_bloc.dart';

class ContentDetailBlocProvider extends InheritedWidget {
  final ContentDetailBloc bloc;

  ContentDetailBlocProvider({Key key, Widget child})
      : bloc = ContentDetailBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static ContentDetailBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ContentDetailBlocProvider)
            as ContentDetailBlocProvider)
        .bloc;
  }
}
