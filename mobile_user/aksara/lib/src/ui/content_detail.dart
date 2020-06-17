import 'package:aksara/src/blocs/content_detail_bloc_provider.dart';
import 'package:aksara/src/blocs/quiz_bloc_provider.dart';
import 'package:aksara/src/ui/quiz.dart' as ui;
import 'package:aksara/src/models/content_model.dart';
import 'package:aksara/src/models/quiz_model.dart';
import 'package:aksara/src/ui/widgets/app_bar_custom.dart';
import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/ui/widgets/btn_custom.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentDetail extends StatefulWidget {
  final Content content;

  ContentDetail({this.content});

  @override
  State<StatefulWidget> createState() {
    return ContentDetailState(content: content);
  }
}

class ContentDetailState extends State<ContentDetail> {
  final Content content;

  ContentDetailBloc bloc;

  ContentDetailState({this.content});

  @override
  void didChangeDependencies() {
    bloc = ContentDetailBlocProvider.of(context);
    bloc.setState(0);
    bloc.getQuiz(context, content.id);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double iWidth = MediaQuery.of(context).size.width;
    double iHeight = MediaQuery.of(context).size.height;
    String callName = content.title;
    if (callName.length > 20) callName = '${callName.substring(0, 20)}...';
    return Scaffold(
      appBar: PreferredSize(
        child: AppBarCustom(
          title: callName,
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: Container(
        height: iHeight,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              contentText(iWidth),
              santun(iWidth),
              akrab(iWidth),
              copy(iWidth),
              link(iWidth),
              dialogTxt(iWidth),
              dialogImg(iWidth),
              btnDialog(iWidth, iHeight),
              btnQuestion(iWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget contentText(iWidth) {
    Widget data;
    if (content.content != null) {
      data = Container(
        padding: EdgeInsets.all(20.0),
        color: GlobalData.GREY_LIGHT_COLOR,
        width: iWidth,
        child: SelectableText(
          content.content,
          style: TextStyle(
            color: GlobalData.TEXT_COLOR,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.justify,
        ),
      );
    } else
      data = Container();
    return data;
  }

  Widget santun(iWidth) {
    Widget data;
    if (content.santun != null) {
      data = Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.only(
            right: 20.0,
            left: 20.0,
            top: 10.0,
            bottom: 10.0,
          ),
          color: GlobalData.SUCCESS_COLOR,
          width: iWidth,
          child: Row(
            children: <Widget>[
              Container(
                width: (iWidth - 40) * 0.2,
                margin: EdgeInsets.only(right: 20),
                child: Image.asset(
                  'assets/images/santun.png',
                  fit: BoxFit.fill,
                ),
              ),
              SelectableText(
                content.santun,
                style: TextStyle(
                  color: GlobalData.BACKGROUND_COLOR,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ));
    } else
      data = Container();
    return data;
  }

  Widget akrab(iWidth) {
    Widget data;
    if (content.akrab != null) {
      data = Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.only(
            right: 20.0,
            left: 20.0,
            top: 10.0,
            bottom: 10.0,
          ),
          color: GlobalData.ERROR_COLOR,
          width: iWidth,
          child: Row(
            children: <Widget>[
              Container(
                width: (iWidth - 40) * 0.2,
                margin: EdgeInsets.only(right: 20),
                child: Image.asset(
                  'assets/images/akrab.png',
                  fit: BoxFit.fill,
                ),
              ),
              SelectableText(
                content.akrab,
                style: TextStyle(
                  color: GlobalData.BACKGROUND_COLOR,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ));
    } else
      data = Container();
    return data;
  }

  Widget copy(iWidth) {
    Widget data;
    if (content.copy != null) {
      data = Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.only(
          right: 20.0,
          left: 20.0,
          top: 10.0,
          bottom: 10.0,
        ),
        color: GlobalData.TEXT_COLOR,
        width: iWidth,
        child: Column(
          children: <Widget>[
            SelectableText(
              content.copy,
              style: TextStyle(
                color: GlobalData.BACKGROUND_COLOR,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.justify,
            ),
            BtnCustom(
              name: 'Salin Teks',
              onPressed: () {
                Clipboard.setData(new ClipboardData(text: content.copy));
                Flushbar(
                  margin: EdgeInsets.all(8),
                  title: 'Sukses',
                  message: 'Kamu berhasil menyalin teks',
                  backgroundColor: GlobalData.SUCCESS_COLOR,
                  isDismissible: true,
                  duration: Duration(seconds: 5),
                )..show(context);
              },
              backgroundColor: GlobalData.PRIMARY_COLOR,
              margin: 20.0,
            ),
          ],
        ),
      );
    } else
      data = Container();
    return data;
  }

  Widget link(iWidth) {
    Widget data;
    if (content.link != null) {
      data = Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.only(
          right: 20.0,
          left: 20.0,
          top: 10.0,
          bottom: 10.0,
        ),
        color: GlobalData.TEXT_COLOR,
        width: iWidth,
        child: Column(
          children: <Widget>[
            SelectableText(
              content.link,
              style: TextStyle(
                color: GlobalData.BACKGROUND_COLOR,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.justify,
            ),
            BtnCustom(
              name: 'Buka Link',
              onPressed: () {
                _launchURL(content.link);
              },
              backgroundColor: GlobalData.PRIMARY_COLOR,
              margin: 20.0,
            ),
          ],
        ),
      );
    } else
      data = Container();
    return data;
  }

  Widget dialogTxt(iWidth) {
    return StreamBuilder<int>(
        stream: bloc.state,
        builder: (context, snapshot) {
          String p1 = '...';
          String p2 = '...';
          if (snapshot.hasData &&
              snapshot.data < content.dialogs.length &&
              snapshot.data > -1) {
            if (snapshot.data % 2 == 0) {
              p1 = content.dialogs[snapshot.data].content.toString();
              p2 = '...';
            } else {
              p1 = '...';
              p2 = content.dialogs[snapshot.data].content.toString();
            }
            return Container(
              margin: EdgeInsets.all(20.0),
              width: iWidth - 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: (iWidth - 60) * 0.5,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: GlobalData.PRIMARY_COLOR,
                      borderRadius: BorderRadius.all(
                        Radius.circular(35),
                      ),
                    ),
                    child: SelectableText(
                      p1,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: GlobalData.BACKGROUND_COLOR,
                      ),
                    ),
                  ),
                  Container(
                    width: (iWidth - 60) * 0.5,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: GlobalData.ACCENT_COLOR,
                      borderRadius: BorderRadius.all(
                        Radius.circular(35),
                      ),
                    ),
                    child: SelectableText(
                      p2,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: GlobalData.TEXT_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        });
  }

  Widget dialogImg(iWidth) {
    return StreamBuilder<int>(
      stream: bloc.state,
      builder: (context, snapshot) {
        double ml = 10;
        double mr = 10;

        if (snapshot.hasData && snapshot.data < content.dialogs.length) {
          if (snapshot.data % 2 != 0) {
            ml = 20;
            mr = 10;
          } else {
            ml = 10;
            mr = 20;
          }
          return Container(
            margin: EdgeInsets.all(20),
            width: iWidth - 40,
            child: Row(
              children: <Widget>[
                Container(
                  width: (iWidth - 40) * 0.5,
                  padding: EdgeInsets.all(ml),
                  child: Image.asset(
                    'assets/images/dialog01.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: (iWidth - 40) * 0.5,
                  padding: EdgeInsets.all(mr),
                  child: Image.asset(
                    'assets/images/dialog02.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget btnQuestion(iWidth) => StreamBuilder<QuizModel>(
        stream: bloc.quiz,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return BtnCustom(
              name: 'Selesaikan Kuis',
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizBlocProvider(
                    child: ui.Quiz(quizes: snapshot.data.quizes),
                  ),
                ),
                (Route<dynamic> route) => false,
              ),
              backgroundColor: GlobalData.SUCCESS_COLOR,
              margin: 20.0,
            );
          if (snapshot.hasError)
            return Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              color: GlobalData.ERROR_COLOR,
              width: iWidth,
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(
                  color: GlobalData.BACKGROUND_COLOR,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            );
          return SpinKitThreeBounce(
            color: GlobalData.ACCENT_COLOR,
            size: 28.0,
          );
        },
      );

  Widget btnDialog(iWidth, iHeight) => StreamBuilder<int>(
        stream: bloc.state,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              (snapshot.data < content.dialogs.length - 1)) {
            if (snapshot.data > -1)
              return Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: BtnCustom(
                  name: 'Lanjutkan dialog',
                  onPressed: () => bloc.incrementState(),
                  margin: 0,
                ),
              );
            return Container();
          } else
            return Container();
        },
      );

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Flushbar(
        margin: EdgeInsets.all(8),
        title: 'Gagal',
        message: 'Link tidak bisa dibuka',
        backgroundColor: GlobalData.ERROR_COLOR,
        isDismissible: true,
        duration: Duration(seconds: 5),
      )..show(context);
    }
  }
}
