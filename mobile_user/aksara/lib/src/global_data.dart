import 'package:flutter/material.dart';

class GlobalData {
  static const Color PRIMARY_COLOR = Color(0XFF0096FA);
  static const Color ACCENT_COLOR = Color(0XFFFCE38A);
  static const Color BACKGROUND_COLOR = Color(0XFFFDFDFD);
  static const Color ERROR_COLOR = Color(0XFFE84545);
  static const Color SUCCESS_COLOR = Color(0XFF1FAB89);
  static const Color GREY_COLOR = Color(0XFFD4D4D4);
  static const Color GREY_LIGHT_COLOR = Color(0XFFF4F4F4);
  static const Color TEXT_COLOR = Color(0XFF0A4472);

  // production
  static const String URL = 'https://aksara.ub.ac.id/api';
  static const String API_TOKEN =
      'eyJhbGciOiJIUzI1NiJ9.ZjR5bk9HMjFNUQ.yYUXs4ili6YtlU4-XROeY4jbIkIWoxPnS4R5yEksYbk';

  // dev
  // static const String URL = 'http://localhost:5000';
  // static const String API_TOKEN =
  //     'eyJhbGciOiJIUzI1NiJ9.ckxVbnByNkxuaQ.oek_XIPKoPpP6HKNxoKN55tALf-gVrr8B6AIwNwWmfw';

  static const String KEY_TOKEN_AUTH = 'token_auth';
  static const String KEY_STATE = 'state';

  static String authorization;
}
