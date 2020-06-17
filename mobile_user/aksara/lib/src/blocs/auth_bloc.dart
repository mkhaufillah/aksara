import 'package:aksara/src/blocs/auth_validator.dart';
import 'package:aksara/src/blocs/home_bloc_provider.dart' as homeProvider;
import 'package:aksara/src/models/check_user_model.dart';
import 'package:aksara/src/ui/home.dart';
import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/models/auth_model.dart';
import 'package:aksara/src/resources/repository.dart';
import 'package:aksara/src/ui/mailing.dart';
import 'package:aksara/src/ui/widgets/btn_custom.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc with AuthValidator {
  final _repository = Repository();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<int>();
  final _isLoadingController = BehaviorSubject<bool>();
  int _counter = 0;

  Function(String) get updateEmail => _emailController.sink.add;
  Function(String) get updatePassword => _passwordController.sink.add;

  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);
  Stream<int> get state => _stateController.stream;
  Stream<bool> get isLoading => _isLoadingController.stream;
  Stream<bool> get submitValid =>
      Observable.combineLatest2(email, password, (email, password) {
        return true;
      });

  hasToken(context) async {
    if (await _repository.hasToken()) {
      GlobalData.authorization = await _repository.getToken();
      _redirectToHome(context);
    } else {
      _passwordController.sink.add('thisIsTempPass');
      _stateController.sink.add(0);
    }
  }

  submit(context) async {
    _isLoadingController.sink.add(true);
    try {
      if (_stateController.value == 0) {
        await _checkUser();
      } else if (_stateController.value == 1)
        await _authentifikasi(context);
      else if (_stateController.value == 2) await _register(context);
    } catch (e) {
      if (_counter >= 3 &&
          e.message.toString() ==
              'Sayang sekali, password kamu tidak tepat, silahkan ulangi') {
        _counter = 0;
        _stateController.add(1);
        Alert(
            context: context,
            style: AlertStyle(
              isCloseButton: false,
              buttonAreaPadding: EdgeInsets.all(6.0),
              titleStyle: TextStyle(
                color: GlobalData.TEXT_COLOR,
                fontWeight: FontWeight.w800,
              ),
            ),
            title: 'Kamu tega melupakan passwordnya',
            image: Image.asset('assets/images/cry.png'),
            content: Column(
              children: <Widget>[
                BtnCustom(
                  name: 'Bantu ingetin',
                  onPressed: () => _resetPassword(context),
                ),
                BtnCustom(
                  name: 'Tidak mau',
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: GlobalData.ERROR_COLOR,
                )
              ],
            ),
            buttons: []).show();
      } else {
        _counter++;
        Flushbar(
          margin: EdgeInsets.all(8),
          title: 'Opps...',
          message: (e.message == '' || e.message == null)
              ? 'Error jaringan'
              : '${e.message}',
          backgroundColor: GlobalData.ERROR_COLOR,
          isDismissible: false,
          duration: Duration(seconds: 10),
        )..show(context);
      }
    }
    _isLoadingController.sink.add(false);
  }

  _checkUser() async {
    _passwordController.sink.add(null);
    final validEmail = _emailController.value;
    CheckUserModel checkUser = await _repository.checkUser(
      email: validEmail,
    );
    if (checkUser.isFound)
      _stateController.sink.add(1);
    else
      _stateController.sink.add(2);
  }

  _authentifikasi(context) async {
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;
    AuthModel auth = await _repository.authenticate(
      email: validEmail,
      password: validPassword,
    );
    GlobalData.authorization = auth.token;
    await _repository.persistToken(auth.token);
    _redirectToHome(context);
  }

  _register(context) async {
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;
    await _repository.register(
      email: validEmail,
      password: validPassword,
    );
    _redirectToMailing(context);
  }

  _resetPassword(context) async {
    Navigator.pop(context);
    _redirectToMailing(context);
    try {
      final validEmail = _emailController.value;
      await _repository.resetPassword(
        email: validEmail,
      );
    } catch (_e) {}
  }

  _redirectToHome(context) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => homeProvider.HomeBlocProvider(
            child: Home(),
          ),
        ),
        (Route<dynamic> route) => false,
      );

  _redirectToMailing(context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Mailing(email: _emailController.value),
        ),
      );

  dispose() async {
    _emailController.close();
    _passwordController.close();
    _stateController.close();
    _isLoadingController.close();
  }
}

final bloc = AuthBloc();
