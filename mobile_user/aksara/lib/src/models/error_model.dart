class ErrorModel {
  _Err _err;

  ErrorModel.fromJson(Map<String, dynamic> parsedJson) {
    _err = _Err(parsedJson['err']);
  }

  get err => _err;
}

class _Err {
  String _msg;

  _Err(err) {
    _msg = err['msg'];
  }

  get msg => _msg;
}
