import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/models/achievement_add_model.dart';
import 'package:aksara/src/resources/repository.dart';
import 'package:aksara/src/ui/result_quiz.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class QuizBloc {
  final _repository = Repository();
  final _contentIdController = BehaviorSubject<int>();
  final _quizResultController = BehaviorSubject<int>();
  final _timeStartController = BehaviorSubject<int>();
  final _timeEndController = BehaviorSubject<int>();
  final _stopwatchController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<int>();
  final _isLoadingController = BehaviorSubject<bool>();

  Function(int) get updateContentId => _contentIdController.sink.add;
  Function(int) get updateQuizResult => _quizResultController.sink.add;
  Function(int) get updateTimeStart => _timeStartController.sink.add;
  Function(int) get updateTimeEnd => _timeEndController.sink.add;
  Function(int) get updateState => _stateController.sink.add;
  Function(String) get updateStopwatch => _stopwatchController.sink.add;

  Stream<int> get contentId => _contentIdController.stream;
  Stream<int> get quizResult => _quizResultController.stream;
  Stream<int> get timeStart => _timeStartController.stream;
  Stream<int> get timeEnd => _timeEndController.stream;
  Stream<String> get stopwatch => _stopwatchController.stream;
  Stream<int> get state => _stateController.stream;
  Stream<bool> get isLoading => _isLoadingController.stream;

  nextQuiz(context, checker, answer) async {
    _sendAnswer(answer);
    if (_stateController.value < checker - 1) {
      int newState = _stateController.value + 1;
      _stateController.sink.add(newState);
    } else {
      sendAchievement(context);
    }
  }

  sendAchievement(context) async {
    _isLoadingController.sink.add(true);
    try {
      if (await _hasToken()) {
        AchievementAddModel achievementAddModel =
            await _repository.sendAchievement(
          context,
          contentId: _contentIdController.value,
          quizResult: _quizResultController.value,
          timeStart: _timeStartController.value,
          timeEnd: _timeEndController.value,
        );
        _redirectToResultQuiz(context, achievementAddModel);
      } else {
        throw Exception('Silahkan login terlebih dahulu');
      }
    } catch (e) {
      Flushbar(
        margin: EdgeInsets.all(8),
        title: 'Opps...',
        message: (e.message == '' || e.message == null)
            ? 'Error jaringan'
            : '${e.message}',
        backgroundColor: GlobalData.ERROR_COLOR,
        isDismissible: false,
        duration: Duration(seconds: 6),
      )..show(context);
      _redirectToResultQuiz(context, null);
    }
    _isLoadingController.sink.add(false);
  }

  _sendAnswer(value) async {
    int temp = _quizResultController.value;
    if (value) temp = temp + 1;
    _quizResultController.sink.add(temp);
  }

  _hasToken() async {
    bool isLogin = await _repository.hasToken();
    if (isLogin) GlobalData.authorization = await _repository.getToken();
    return isLogin;
  }

  _redirectToResultQuiz(context, achievementAddModel) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ResultQuiz(
          achievementAddModel: achievementAddModel,
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  dispose() {
    _contentIdController.close();
    _quizResultController.close();
    _timeStartController.close();
    _timeEndController.close();
    _stopwatchController.close();
    _stateController.close();
    _isLoadingController.close();
  }
}

final bloc = QuizBloc();
