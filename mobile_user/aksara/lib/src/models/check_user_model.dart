class CheckUserModel {
  String _msg;
  bool _isFound;

  CheckUserModel.fromJson(Map<String, dynamic> parsedJson) {
    _msg = parsedJson['msg'];
    _isFound = parsedJson['isFound'];
  }

  get msg => _msg;
  get isFound => _isFound;
}
