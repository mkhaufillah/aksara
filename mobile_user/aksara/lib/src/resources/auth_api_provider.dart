import 'dart:convert';

import 'package:aksara/src/models/auth_model.dart';
import 'package:aksara/src/models/check_user_model.dart';
import 'package:aksara/src/models/error_model.dart';
import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/models/register_model.dart';
import 'package:aksara/src/models/reset_password_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;

class AuthApiProvider {
  final Client client = Client();

  Future<CheckUserModel> checkUser({
    @required String email,
  }) async {
    final response = await client.get(
      '${GlobalData.URL}/auth/user/check?email=$email',
      headers: {
        'Content-Type': 'application/json',
        'Token': GlobalData.API_TOKEN,
      },
    );
    if (response.statusCode == 200) {
      return CheckUserModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }

  Future<AuthModel> authenticate({
    @required String email,
    @required String password,
  }) async {
    final response = await client.post(
      '${GlobalData.URL}/auth/user/login',
      headers: {
        'Content-Type': 'application/json',
        'Token': GlobalData.API_TOKEN,
      },
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return AuthModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }

  Future<RegisterModel> register({
    @required String email,
    @required String password,
  }) async {
    final response = await client.post(
      '${GlobalData.URL}/auth/user/register',
      headers: {
        'Content-Type': 'application/json',
        'Token': GlobalData.API_TOKEN,
      },
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return RegisterModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }

  Future<ResetPasswordModel> resetPassword({
    @required String email,
  }) async {
    final response = await client.post(
      '${GlobalData.URL}/auth/user/request-reset-password',
      headers: {
        'Content-Type': 'application/json',
        'Token': GlobalData.API_TOKEN,
      },
      body: json.encode({'email': email}),
    );
    if (response.statusCode == 200) {
      return ResetPasswordModel.fromJson(json.decode(response.body));
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
      throw Exception(errorModel.err.msg.toString());
    }
  }
}
