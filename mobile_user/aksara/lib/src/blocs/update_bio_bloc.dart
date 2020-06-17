import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/blocs/auth_bloc_provider.dart' as authProvider;
import 'package:aksara/src/blocs/home_bloc_provider.dart' as homeProvider;
import 'package:aksara/src/models/update_bio_model.dart';
import 'package:aksara/src/models/user_model.dart';
import 'package:aksara/src/ui/auth.dart';
import 'package:aksara/src/resources/repository.dart';
import 'package:aksara/src/ui/home.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class UpdateBioBloc {
  final _repository = Repository();
  final _userController = PublishSubject<User>();
  final _nameController = BehaviorSubject<String>();
  final _facultyController = BehaviorSubject<String>();
  final _departmentController = BehaviorSubject<String>();
  final _studyProgramController = BehaviorSubject<String>();
  final _generationController = BehaviorSubject<String>();
  final _isLoadingController = BehaviorSubject<bool>();

  Function(String) get updateName => _nameController.sink.add;
  Function(String) get updateFaculty => _facultyController.sink.add;
  Function(String) get updateDepartment => _departmentController.sink.add;
  Function(String) get updateStudyProgram => _studyProgramController.sink.add;
  Function(String) get updateGeneration => _generationController.sink.add;

  Stream<String> get name => _nameController.stream;
  Stream<String> get faculty => _facultyController.stream;
  Stream<String> get department => _departmentController.stream;
  Stream<String> get studyProgram => _studyProgramController.stream;
  Stream<String> get generation => _generationController.stream;
  Stream<bool> get isLoading => _isLoadingController.stream;
  Observable<User> get user => _userController.stream;

  updateBio(context) async {
    _isLoadingController.sink.add(true);
    bool isHack = false;
    try {
      UpdateBioModel updateBioModel;
      if (await _hasToken()) {
        updateBioModel = await _repository.updateBio(
          name: _nameController.value,
          department: _departmentController.value,
          faculty: _facultyController.value,
          generation: _generationController.value,
          studyProgram: _studyProgramController.value,
        );
        _repository.persistToken(updateBioModel.token);
        GlobalData.authorization = updateBioModel.token;
        _redirectToHome(context);
      } else {
        isHack = true;
        throw Exception('Silahkan login terlebih dahulu');
      }
      _userController.sink.add(updateBioModel.data);
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
    _isLoadingController.sink.add(false);
  }

  fetchUser(context) async {
    bool isHack = false;
    try {
      UserModel userModel;
      if (await _hasToken())
        userModel = await _repository.fetchUser();
      else {
        isHack = true;
        throw Exception('Silahkan login terlebih dahulu');
      }
      _userController.sink.add(userModel.data);
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

  _redirectToHome(context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => homeProvider.HomeBlocProvider(
          child: Home(),
        ),
      ),
      (Route<dynamic> route) => false,
    );
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
    _userController.close();
    _nameController.close();
    _facultyController.close();
    _departmentController.close();
    _studyProgramController.close();
    _generationController.close();
    _isLoadingController.close();
  }
}

final bloc = UpdateBioBloc();
