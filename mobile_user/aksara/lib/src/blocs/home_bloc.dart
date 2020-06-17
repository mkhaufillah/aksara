import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/blocs/auth_bloc_provider.dart' as authProvider;
import 'package:aksara/src/models/achievement_model.dart';
import 'package:aksara/src/ui/auth.dart';
import 'package:aksara/src/models/user_model.dart';
import 'package:aksara/src/resources/repository.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final _repository = Repository();
  final _userController = BehaviorSubject<UserModel>();
  final _achievementController = BehaviorSubject<AchievementModel>();
  final _stateController = BehaviorSubject<bool>();

  Stream<UserModel> get user => _userController.stream;
  Stream<AchievementModel> get achievement => _achievementController.stream;
  Stream<bool> get state => _stateController.stream;

  setState() async {
    await _repository.persistState('stateTrue');
    _stateController.sink.add(true);
  }

  setStateFromStorage() async {
    bool state = await _repository.hasStateTutorial();
    _stateController.sink.add(state);
  }

  fetchUser(context) async {
    try {
      UserModel userModel;
      if (await _hasToken()) {
        userModel = await _repository.fetchUser();
      } else
        throw Exception('Silahkan login terlebih dahulu');
      _userController.sink.add(userModel);
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
      _logout(context);
    }
  }

  getAchievement(context) async {
    bool isHack = false;
    try {
      AchievementModel achievementModel;
      if (await _hasToken())
        achievementModel = await _repository.getAchievement();
      else {
        isHack = true;
        throw Exception('Silahkan login terlebih dahulu');
      }
      _achievementController.sink.add(achievementModel);
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
      if (isHack) _logout(context);
    }
  }

  _logout(context) async {
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
    _achievementController.close();
    _userController.close();
    _stateController.close();
  }
}

final bloc = HomeBloc();
