import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/models/sub_document_model.dart';
import 'package:aksara/src/resources/repository.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class SubDocumentListBloc {
  final _repository = Repository();

  Future<List<SubDocument>> getSubDocuments(
    context,
    int currentListSize,
    int documentId,
  ) async {
    List<SubDocument> subDocuments = List<SubDocument>();
    try {
      int page = (currentListSize / 20).floor();
      if ((currentListSize % 20) == 0) {
        SubDocumentModel subDocumentModel = await _repository.getSubDocument(
            page: page, documentId: documentId);
        subDocuments = subDocumentModel.subDocuments;
      }
    } catch (e) {
      Flushbar(
        margin: EdgeInsets.all(8),
        title: 'Opps...',
        message: (e.message == '' || e.message == null)
            ? 'Error jaringan'
            : '${e.message}',
        backgroundColor: GlobalData.ERROR_COLOR,
        isDismissible: false,
        duration: Duration(seconds: 6),
      )..show(context);
    }
    return subDocuments;
  }
}

final bloc = SubDocumentListBloc();
