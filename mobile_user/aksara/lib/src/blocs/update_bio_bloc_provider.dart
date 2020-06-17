import 'package:aksara/src/blocs/update_bio_bloc.dart';
import 'package:flutter/material.dart';
export 'package:aksara/src/blocs/update_bio_bloc.dart';

class UpdateBioBlocProvider extends InheritedWidget {
  final UpdateBioBloc bloc;

  UpdateBioBlocProvider({Key key, Widget child})
      : bloc = UpdateBioBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static UpdateBioBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(UpdateBioBlocProvider)
            as UpdateBioBlocProvider)
        .bloc;
  }
}
