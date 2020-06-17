import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/models/document_model.dart';
import 'package:aksara/src/resources/repository.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class DocumentListBloc {
  final _repository = Repository();

  Future<List<Document>> getDocuments(context, int currentListSize) async {
    List<Document> documents = List<Document>();
    try {
      int page = (currentListSize / 20).floor();
      if (page != 0 && currentListSize < 20) return List<Document>();
      if ((currentListSize % 20) == 0) {
        DocumentModel documentModel = await _repository.getDocument(page: page);
        documents = documentModel.documents;
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
    return documents;
  }
}

final bloc = DocumentListBloc();
