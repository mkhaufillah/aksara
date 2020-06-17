import 'package:aksara/src/blocs/quiz_bloc.dart';
import 'package:flutter/material.dart';
export 'package:aksara/src/blocs/quiz_bloc.dart';

class QuizBlocProvider extends InheritedWidget {
  final QuizBloc bloc;

  QuizBlocProvider({Key key, Widget child})
      : bloc = QuizBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static QuizBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(QuizBlocProvider)
            as QuizBlocProvider)
        .bloc;
  }
}
