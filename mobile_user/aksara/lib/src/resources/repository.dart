import 'package:aksara/src/models/achievement_add_model.dart';
import 'package:aksara/src/models/achievement_model.dart';
import 'package:aksara/src/models/auth_model.dart';
import 'package:aksara/src/models/check_user_model.dart';
import 'package:aksara/src/models/content_model.dart';
import 'package:aksara/src/models/document_model.dart';
import 'package:aksara/src/models/history_model.dart';
import 'package:aksara/src/models/leaderboard_model.dart';
import 'package:aksara/src/models/quiz_model.dart';
import 'package:aksara/src/models/register_model.dart';
import 'package:aksara/src/models/reset_password_model.dart';
import 'package:aksara/src/models/sub_document_model.dart';
import 'package:aksara/src/models/update_bio_model.dart';
import 'package:aksara/src/models/user_model.dart';
import 'package:aksara/src/resources/auth_api_provider.dart';
import 'package:aksara/src/resources/document_api_provider.dart';
import 'package:aksara/src/resources/leaderboard_api_provider.dart';
import 'package:aksara/src/resources/save_state_provider.dart';
import 'package:aksara/src/resources/user_api_provider.dart';
import 'package:aksara/src/resources/auth_storage_provider.dart';
import 'package:flutter/material.dart';

class Repository {
  final _userApiProvider = UserApiProvider();
  final _authApiProvider = AuthApiProvider();
  final _authStorageProvider = AuthStorageProvider();
  final _leaderboardApiProvider = LeaderboardApiProvider();
  final _documentApiProvider = DocumentApiProvider();
  final _saveStateApiProvider = SaveStateProvider();

  Future<UserModel> fetchUser() => _userApiProvider.fetchUser();

  Future<AchievementModel> getAchievement() =>
      _userApiProvider.getAchievement();

  Future<HistoryModel> getHistory() => _userApiProvider.getHistory();

  Future<UpdateBioModel> updateBio({
    @required String name,
    @required String faculty,
    @required String department,
    @required String studyProgram,
    @required String generation,
  }) =>
      _userApiProvider.updateBio(
        name: name,
        faculty: faculty,
        department: department,
        studyProgram: studyProgram,
        generation: generation,
      );

  Future<CheckUserModel> checkUser({
    @required String email,
  }) =>
      _authApiProvider.checkUser(email: email);

  Future<AuthModel> authenticate({
    @required String email,
    @required String password,
  }) =>
      _authApiProvider.authenticate(email: email, password: password);

  Future<RegisterModel> register({
    @required String email,
    @required String password,
  }) =>
      _authApiProvider.register(email: email, password: password);

  Future<ResetPasswordModel> resetPassword({
    @required String email,
  }) =>
      _authApiProvider.resetPassword(email: email);

  Future<String> getToken() => _authStorageProvider.getToken();

  Future<void> deleteToken() => _authStorageProvider.deleteToken();

  Future<void> persistToken(String token) =>
      _authStorageProvider.persistToken(token);

  Future<bool> hasToken() => _authStorageProvider.hasToken();

  Future<LeaderboardModel> getLeaderboard() =>
      _leaderboardApiProvider.getLeaderboard();

  Future<DocumentModel> getDocument({@required int page}) =>
      _documentApiProvider.getDocument(page: page);

  Future<SubDocumentModel> getSubDocument({
    @required int page,
    @required int documentId,
  }) =>
      _documentApiProvider.getSubDocument(page: page, documentId: documentId);

  Future<ContentModel> getContent({
    @required int page,
    @required int subDocumentId,
  }) =>
      _documentApiProvider.getContent(page: page, subDocumentId: subDocumentId);

  Future<QuizModel> getQuiz({
    @required int contentId,
  }) =>
      _documentApiProvider.getQuiz(contentId: contentId);

  Future<AchievementAddModel> sendAchievement(
    context, {
    @required int contentId,
    @required int quizResult,
    @required int timeStart,
    @required int timeEnd,
  }) =>
      _documentApiProvider.sendAchievement(
        context,
        contentId: contentId,
        quizResult: quizResult,
        timeStart: timeStart,
        timeEnd: timeEnd,
      );

  Future<void> persistState(String state) =>
      _saveStateApiProvider.persistState(state);

  Future<bool> hasStateTutorial() => _saveStateApiProvider.hasStateTutorial();
}
