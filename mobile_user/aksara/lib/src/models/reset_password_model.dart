class ResetPasswordModel {
  String _msg;

  ResetPasswordModel.fromJson(Map<String, dynamic> parsedJson) {
    _msg = parsedJson['msg'];
  }

  get msg => _msg;
}
