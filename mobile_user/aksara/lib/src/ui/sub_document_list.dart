import 'package:aksara/src/blocs/content_bloc_provider.dart';
import 'package:aksara/src/blocs/sub_document_list_bloc_provider.dart';
import 'package:aksara/src/models/document_model.dart';
import 'package:aksara/src/models/sub_document_model.dart';
import 'package:aksara/src/ui/content.dart';
import 'package:aksara/src/ui/widgets/app_bar_custom.dart';
import 'package:aksara/src/global_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paging/paging.dart';

class SubDocumentList extends StatefulWidget {
  final Document document;

  SubDocumentList({this.document});

  @override
  State<StatefulWidget> createState() {
    return SubDocumentListState(document: document);
  }
}

class SubDocumentListState extends State<SubDocumentList> {
  final Document document;

  SubDocumentListBloc bloc;

  SubDocumentListState({this.document});

  @override
  void didChangeDependencies() {
    bloc = SubDocumentBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String callName = document.title;
    if (callName.length > 20) callName = '${callName.substring(0, 20)}...';
    return Scaffold(
      appBar: PreferredSize(
        child: AppBarCustom(
          title: callName,
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: Pagination<SubDocument>(
        pageBuilder: (currentListSize) =>
            bloc.getSubDocuments(context, currentListSize, document.id),
        progress: SpinKitThreeBounce(
          color: GlobalData.TEXT_COLOR,
          size: 28.0,
        ),
        itemBuilder: (index, item) {
          return Container(
            color: GlobalData.BACKGROUND_COLOR,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContentBlocProvider(
                      child: Content(subDocument: item),
                    ),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(right: 8),
                          child: Text(
                            '${item.title}',
                            style: TextStyle(
                              color: GlobalData.TEXT_COLOR,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        FontAwesomeIcons.arrowCircleRight,
                        size: 24,
                        color: GlobalData.TEXT_COLOR,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
