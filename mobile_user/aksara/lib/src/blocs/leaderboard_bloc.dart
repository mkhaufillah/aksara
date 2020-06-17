import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/blocs/auth_bloc_provider.dart' as authProvider;
import 'package:aksara/src/models/leaderboard_model.dart';
import 'package:aksara/src/ui/auth.dart';
import 'package:aksara/src/resources/repository.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LeaderboardBloc {
  final _repository = Repository();
  final _leaderboardController = PublishSubject<LeaderboardModel>();

  Observable<LeaderboardModel> get leaderboard => _leaderboardController.stream;

  getLeaderboard(context) async {
    bool isHack = false;
    try {
      LeaderboardModel leaderboardModel;
      if (await _hasToken()) {
        leaderboardModel = await _repository.getLeaderboard();
      } else {
        isHack = true;
        throw Exception('Silahkan login terlebih dahulu');
      }
      _leaderboardController.sink.add(leaderboardModel);
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
    _leaderboardController.close();
  }
}

final bloc = LeaderboardBloc();
