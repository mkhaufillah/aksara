import 'package:aksara/src/models/user_model.dart';

class RegisterModel {
  String _msg;
  User _user;

  RegisterModel.fromJson(Map<String, dynamic> parsedJson) {
    _msg = parsedJson['msg'];
    _user = User(parsedJson['user']);
  }

  get msg => _msg;
  get user => _user;
}
