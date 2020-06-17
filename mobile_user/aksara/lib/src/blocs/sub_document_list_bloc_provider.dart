import 'package:aksara/src/blocs/sub_document_list_bloc.dart';
import 'package:flutter/material.dart';
export 'package:aksara/src/blocs/sub_document_list_bloc.dart';

class SubDocumentBlocProvider extends InheritedWidget {
  final SubDocumentListBloc bloc;

  SubDocumentBlocProvider({Key key, Widget child})
      : bloc = SubDocumentListBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static SubDocumentListBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(SubDocumentBlocProvider)
            as SubDocumentBlocProvider)
        .bloc;
  }
}
