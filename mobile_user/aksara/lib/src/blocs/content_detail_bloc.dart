import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/blocs/auth_bloc_provider.dart' as authProvider;
import 'package:aksara/src/models/quiz_model.dart';
import 'package:aksara/src/ui/auth.dart';
import 'package:aksara/src/resources/repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ContentDetailBloc {
  final _repository = Repository();
  final _quizController = PublishSubject<QuizModel>();
  final _stateController = BehaviorSubject<int>();

  Observable<QuizModel> get quiz => _quizController.stream;
  Stream<int> get state => _stateController.stream;

  incrementState() async {
    int newState = _stateController.value + 1;
    _stateController.sink.add(newState);
  }

  setState(value) async {
    _stateController.sink.add(value);
  }

  getQuiz(context, contentId) async {
    bool isHack = false;
    try {
      QuizModel quizModel;
      if (await _hasToken()) {
        quizModel = await _repository.getQuiz(contentId: contentId);
      } else {
        isHack = true;
        throw Exception('Silahkan login terlebih dahulu');
      }
      _quizController.sink.add(quizModel);
    } catch (e) {
      _quizController.sink.addError((e.message == '' || e.message == null)
          ? 'Error jaringan'
          : '${e.message}');
      if (isHack) logout(context);
    }
  }

  logout(context) async {
    await _deleteToken();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => authProvider.AuthBlocProvider(
          child: Auth(),
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  _hasToken() async {
    bool isLogin = await _repository.hasToken();
    if (isLogin) GlobalData.authorization = await _repository.getToken();
    return isLogin;
  }

  _deleteToken() async {
    GlobalData.authorization = null;
    await _repository.deleteToken();
  }

  dispose() {
    _quizController.close();
    _stateController.close();
  }
}

final bloc = ContentDetailBloc();
