import 'dart:convert';

import 'package:aksara/src/models/achievement_model.dart';
import 'package:aksara/src/models/error_model.dart';
import 'package:aksara/src/models/history_model.dart';
import 'package:aksara/src/models/update_bio_model.dart';
import 'package:aksara/src/models/user_model.dart';
import 'package:aksara/src/global_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;

class UserApiProvider {
  final Client client = Client();

  Future<UserModel> fetchUser() async {
    final response = await client.get('${GlobalData.URL}/get-bio', headers: {
      'Content-Type': 'application/json',
      'Token': GlobalData.API_TOKEN,
      'Authorization':
          (GlobalData.authorization == null) ? '' : GlobalData.authorization,
    });
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }

  Future<AchievementModel> getAchievement() async {
    final response =
        await client.get('${GlobalData.URL}/get-achievement', headers: {
      'Content-Type': 'application/json',
      'Token': GlobalData.API_TOKEN,
      'Authorization':
          (GlobalData.authorization == null) ? '' : GlobalData.authorization,
    });
    if (response.statusCode == 200) {
      return AchievementModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }

  Future<HistoryModel> getHistory() async {
    final response =
        await client.get('${GlobalData.URL}/get-history?page=0', headers: {
      'Content-Type': 'application/json',
      'Token': GlobalData.API_TOKEN,
      'Authorization':
          (GlobalData.authorization == null) ? '' : GlobalData.authorization,
    });
    if (response.statusCode == 200) {
      return HistoryModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }

  Future<UpdateBioModel> updateBio({
    @required String name,
    @required String faculty,
    @required String department,
    @required String studyProgram,
    @required String generation,
  }) async {
    final response = await client.post(
      '${GlobalData.URL}/auth/user/update-bio',
      headers: {
        'Content-Type': 'application/json',
        'Token': GlobalData.API_TOKEN,
        'Authorization':
            (GlobalData.authorization == null) ? '' : GlobalData.authorization,
      },
      body: json.encode({
        'name': name,
        'faculty': faculty,
        'department': department,
        'studyProgram': studyProgram,
        'generation': generation,
      }),
    );
    if (response.statusCode == 200) {
      return UpdateBioModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }
}
