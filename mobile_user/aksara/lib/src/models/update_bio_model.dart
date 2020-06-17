import 'package:aksara/src/models/user_model.dart';

class UpdateBioModel {
  String _msg;
  String _token;
  User _data;

  UpdateBioModel.fromJson(Map<String, dynamic> parsedJson) {
    _msg = parsedJson['msg'];
    _token = parsedJson['token'];
    _data = User(parsedJson['data']);
  }

  get msg => _msg;
  get token => _token;
  get data => _data;
}
