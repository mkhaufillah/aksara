import 'package:aksara/src/blocs/document_list_bloc_provider.dart';
import 'package:aksara/src/blocs/sub_document_list_bloc_provider.dart';
import 'package:aksara/src/models/document_model.dart';
import 'package:aksara/src/ui/sub_document_list.dart';
import 'package:aksara/src/ui/widgets/app_bar_custom.dart';
import 'package:aksara/src/global_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paging/paging.dart';

class DocumentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DocumentListState();
  }
}

class DocumentListState extends State<DocumentList> {
  DocumentListBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = DocumentBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBarCustom(
          title: 'Document',
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: Pagination<Document>(
        pageBuilder: (currentListSize) =>
            bloc.getDocuments(context, currentListSize),
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
                    builder: (context) => SubDocumentBlocProvider(
                      child: SubDocumentList(document: item),
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
