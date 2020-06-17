import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/models/content_model.dart';
import 'package:aksara/src/resources/repository.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ContentBloc {
  final _repository = Repository();

  Future<List<Content>> getContents(
    context,
    int currentSize,
    int subDocumentId,
  ) async {
    List<Content> contents = List<Content>();
    try {
      int page = (currentSize / 20).floor();
      if ((currentSize % 20) == 0) {
        ContentModel contentModel = await _repository.getContent(
            page: page, subDocumentId: subDocumentId);
        contents = contentModel.contents;
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
    return contents;
  }
}

final bloc = ContentBloc();
