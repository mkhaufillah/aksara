import 'dart:convert';

import 'package:aksara/src/models/error_model.dart';
import 'package:aksara/src/models/leaderboard_model.dart';
import 'package:aksara/src/global_data.dart';
import 'package:http/http.dart' show Client;

class LeaderboardApiProvider {
  final Client client = Client();

  Future<LeaderboardModel> getLeaderboard() async {
    final response =
        await client.get('${GlobalData.URL}/get-leaderboard', headers: {
      'Content-Type': 'application/json',
      'Token': GlobalData.API_TOKEN,
      'Authorization':
          (GlobalData.authorization == null) ? '' : GlobalData.authorization,
    });
    if (response.statusCode == 200) {
      return LeaderboardModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }
}
