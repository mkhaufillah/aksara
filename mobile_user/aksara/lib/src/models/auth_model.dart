import 'package:aksara/src/models/user_model.dart';

class AuthModel {
  String _msg;
  String _token;
  User _user;

  AuthModel.fromJson(Map<String, dynamic> parsedJson) {
    _msg = parsedJson['msg'];
    _token = parsedJson['token'];
    _user = User(parsedJson['user']);
  }

  get msg => _msg;
  get token => _token;
  get user => _user;
}
