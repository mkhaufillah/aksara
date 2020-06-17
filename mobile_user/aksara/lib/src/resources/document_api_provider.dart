import 'dart:convert';

import 'package:aksara/src/models/achievement_add_model.dart';
import 'package:aksara/src/models/content_model.dart';
import 'package:aksara/src/models/document_model.dart';
import 'package:aksara/src/models/error_model.dart';
import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/models/quiz_model.dart';
import 'package:aksara/src/models/sub_document_model.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;

class DocumentApiProvider {
  final Client client = Client();

  Future<DocumentModel> getDocument({@required int page}) async {
    final response = await client
        .get('${GlobalData.URL}/get-documents?page=$page', headers: {
      'Content-Type': 'application/json',
      'Token': GlobalData.API_TOKEN,
      'Authorization':
          (GlobalData.authorization == null) ? '' : GlobalData.authorization,
    });
    if (response.statusCode == 200) {
      return DocumentModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }

  Future<SubDocumentModel> getSubDocument({
    @required int page,
    @required int documentId,
  }) async {
    final response = await client.get(
        '${GlobalData.URL}/get-sub-documents?documentId=$documentId&page=$page',
        headers: {
          'Content-Type': 'application/json',
          'Token': GlobalData.API_TOKEN,
          'Authorization': (GlobalData.authorization == null)
              ? ''
              : GlobalData.authorization,
        });
    if (response.statusCode == 200) {
      return SubDocumentModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }

  Future<ContentModel> getContent({
    @required int page,
    @required int subDocumentId,
  }) async {
    final response = await client.get(
        '${GlobalData.URL}/get-contents?subDocumentId=$subDocumentId&page=$page',
        headers: {
          'Content-Type': 'application/json',
          'Token': GlobalData.API_TOKEN,
          'Authorization': (GlobalData.authorization == null)
              ? ''
              : GlobalData.authorization,
        });
    if (response.statusCode == 200) {
      return ContentModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }

  Future<QuizModel> getQuiz({@required int contentId}) async {
    final response = await client
        .get('${GlobalData.URL}/get-quizes?contentId=$contentId', headers: {
      'Content-Type': 'application/json',
      'Token': GlobalData.API_TOKEN,
      'Authorization':
          (GlobalData.authorization == null) ? '' : GlobalData.authorization,
    });
    if (response.statusCode == 200) {
      return QuizModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }

  Future<AchievementAddModel> sendAchievement(
    context, {
    @required int contentId,
    @required int quizResult,
    @required int timeStart,
    @required int timeEnd,
  }) async {
    String deviceId = await _getId(context);
    final response = await client.post(
      '${GlobalData.URL}/send-achievement',
      headers: {
        'Content-Type': 'application/json',
        'Token': GlobalData.API_TOKEN,
        'Authorization':
            (GlobalData.authorization == null) ? '' : GlobalData.authorization,
      },
      body: json.encode({
        'contentId': contentId,
        'quizResult': quizResult,
        'timeStart': timeStart,
        'timeEnd': timeEnd,
        'signature': '$deviceId',
      }),
    );
    if (response.statusCode == 200) {
      return AchievementAddModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }

  Future<String> _getId(context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId;
    }
  }
}
