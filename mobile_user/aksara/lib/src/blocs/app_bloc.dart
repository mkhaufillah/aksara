import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/resources/repository.dart';
import 'package:aksara/src/blocs/auth_bloc_provider.dart' as authProvider;
import 'package:aksara/src/blocs/home_bloc_provider.dart' as homeProvider;
import 'package:aksara/src/ui/auth.dart';
import 'package:aksara/src/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc {
  final _repository = Repository();
  final _homeController = PublishSubject<Widget>();

  Observable<Widget> get home => _homeController.stream;

  getHome() async {
    Widget home;
    if (await _repository.hasToken()) {
      home = homeProvider.HomeBlocProvider(child: Home());
      GlobalData.authorization = await _repository.getToken();
    } else {
      home = authProvider.AuthBlocProvider(child: Auth());
    }
    _homeController.sink.add(home);
  }

  dispose() {
    _homeController.close();
  }
}

final bloc = AppBloc();
