import 'package:aksara/src/blocs/document_list_bloc.dart';
import 'package:flutter/material.dart';
export 'package:aksara/src/blocs/document_list_bloc.dart';

class DocumentBlocProvider extends InheritedWidget {
  final DocumentListBloc bloc;

  DocumentBlocProvider({Key key, Widget child})
      : bloc = DocumentListBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static DocumentListBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(DocumentBlocProvider)
            as DocumentBlocProvider)
        .bloc;
  }
}
