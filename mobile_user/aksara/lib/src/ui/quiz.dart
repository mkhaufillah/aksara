import 'package:aksara/src/blocs/quiz_bloc_provider.dart';
import 'package:aksara/src/models/quiz_model.dart' as model;
import 'package:aksara/src/ui/widgets/app_bar_custom.dart';
import 'package:aksara/src/global_data.dart';
import 'package:flutter/material.dart';
import 'package:countdown/countdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Quiz extends StatefulWidget {
  final List<model.Quiz> quizes;

  Quiz({this.quizes});

  @override
  State<StatefulWidget> createState() {
    return QuizState(quizes: quizes);
  }
}

class QuizState extends State<Quiz> {
  final List<model.Quiz> quizes;
  CountDown cd = CountDown(Duration(minutes: 7));
  var st;

  QuizBloc bloc;

  QuizState({this.quizes});

  @override
  void didChangeDependencies() {
    bloc = QuizBlocProvider.of(context);
    bloc.updateQuizResult(0);
    bloc.updateContentId(quizes[0].contentId);
    bloc.updateTimeStart(DateTime.now().millisecondsSinceEpoch);
    bloc.updateState(0);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    st.cancel();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double iWidth = MediaQuery.of(context).size.width;
    double iHeight = MediaQuery.of(context).size.height;
    String callName = quizes[0].title;
    if (callName.length > 10) callName = '${callName.substring(0, 10)}...';

    st = cd.stream.listen(
      (d) => bloc.updateStopwatch('${d.inMinutes} : ${d.inSeconds % 60}'),
      onDone: () => bloc.sendAchievement(context),
    );

    return Scaffold(
      appBar: PreferredSize(
        child: StreamBuilder<String>(
            stream: bloc.stopwatch,
            builder: (context, snapshot) {
              String stopwatch = '...';
              if (snapshot.hasData) stopwatch = snapshot.data;
              return AppBarCustom(
                title: '$callName ( $stopwatch )',
              );
            }),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: iHeight,
            child: SingleChildScrollView(
              child: StreamBuilder<int>(
                stream: bloc.state,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(20.0),
                          color: GlobalData.GREY_LIGHT_COLOR,
                          width: iWidth,
                          child: Text(
                            quizes[snapshot.data].question,
                            style: TextStyle(
                              color: GlobalData.TEXT_COLOR,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20.0),
                          width: iWidth,
                          child: Text(
                            'Pilih salah satu warna',
                            style: TextStyle(
                              color: GlobalData.GREY_COLOR,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        answer(snapshot.data, iWidth, iHeight),
                      ],
                    );
                  return Container(
                    width: iWidth,
                    height: iHeight,
                    color: GlobalData.BACKGROUND_COLOR,
                    child: SpinKitHourGlass(
                      color: GlobalData.TEXT_COLOR,
                      size: 28.0,
                    ),
                  );
                },
              ),
            ),
          ),
          StreamBuilder<bool>(
              stream: bloc.isLoading,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data)
                  return Container(
                    width: iWidth,
                    height: iHeight,
                    color: GlobalData.BACKGROUND_COLOR,
                    child: SpinKitHourGlass(
                      color: GlobalData.TEXT_COLOR,
                      size: 28.0,
                    ),
                  );
                return Container();
              })
        ],
      ),
    );
  }

  Widget answer(indexQuiz, iWidth, iHeight) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              answerPoint(0, indexQuiz, iWidth, iHeight),
              answerPoint(1, indexQuiz, iWidth, iHeight),
            ],
          ),
          Row(
            children: <Widget>[
              answerPoint(2, indexQuiz, iWidth, iHeight),
              answerPoint(3, indexQuiz, iWidth, iHeight),
            ],
          )
        ],
      );

  Widget answerPoint(indexAnswer, indexQuiz, iWidth, iHeight) => Container(
        color:
            hexToColor(quizes[indexQuiz].answer[indexAnswer].color.toString()),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: () {
                bloc.updateTimeEnd(DateTime.now().millisecondsSinceEpoch);
                bloc.nextQuiz(
                  context,
                  quizes.length,
                  quizes[indexQuiz].answer[indexAnswer].isCorrect,
                );
              },
              child: Column(
                children: <Widget>[
                  Container(
                    width: iWidth * 0.5,
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 20,
                    ),
                    child: Text(
                      quizes[indexQuiz].answer[indexAnswer].title.toString(),
                      style: TextStyle(
                        color: hexToColor(
                          quizes[indexQuiz]
                              .answer[indexAnswer]
                              .textColor
                              .toString(),
                        ),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    width: iWidth * 0.5,
                    padding: EdgeInsets.all(20.0),
                    height: iHeight * 0.25,
                    child: Text(
                      quizes[indexQuiz].answer[indexAnswer].answer.toString(),
                      style: TextStyle(
                        color: hexToColor(
                          quizes[indexQuiz]
                              .answer[indexAnswer]
                              .textColor
                              .toString(),
                        ),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );

  Color hexToColor(String code) =>
      Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
