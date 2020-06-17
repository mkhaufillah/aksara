import 'package:aksara/src/blocs/home_bloc_provider.dart';
import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/models/achievement_add_model.dart';
import 'package:aksara/src/ui/home.dart';
import 'package:aksara/src/ui/widgets/btn_custom.dart';
import 'package:flutter/material.dart';

class ResultQuiz extends StatelessWidget {
  final AchievementAddModel achievementAddModel;

  ResultQuiz({this.achievementAddModel});

  @override
  Widget build(BuildContext context) {
    double iWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: (achievementAddModel != null)
              ? GlobalData.ACCENT_COLOR
              : GlobalData.BACKGROUND_COLOR,
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 40.0),
                width: iWidth * 0.5,
                child: Image.asset(
                  (achievementAddModel != null)
                      ? 'assets/images/laugh.png'
                      : 'assets/images/cry.png',
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  (achievementAddModel != null)
                      ? 'Yey.... Selamat, Kamu berhasil menyelesaikan soal'
                      : 'Yahhhhh, Kamu gagal menyelesaikan soal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: (achievementAddModel != null)
                        ? GlobalData.TEXT_COLOR
                        : GlobalData.ERROR_COLOR,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  'Kamu mendapatkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: GlobalData.TEXT_COLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  (achievementAddModel != null)
                      ? '+${achievementAddModel.content.pointAdd} poin'
                      : '+0 poin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: (achievementAddModel != null)
                        ? GlobalData.SUCCESS_COLOR
                        : GlobalData.GREY_COLOR,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  (achievementAddModel != null)
                      ? '+${achievementAddModel.content.rankAdd} rangking'
                      : '+0 rangking',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: (achievementAddModel != null)
                        ? GlobalData.SUCCESS_COLOR
                        : GlobalData.GREY_COLOR,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 10),
                child: Text(
                  (achievementAddModel != null)
                      ? 'Semangat, kamu cuma butuh ${achievementAddModel.content.modPoint} poin lagi untuk naik ke level ${achievementAddModel.content.levelNow + 1}'
                      : 'Semangat, jangan pantang menyerah. Kamu pasti bisa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: GlobalData.TEXT_COLOR,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              BtnCustom(
                name: 'Kembali',
                shadowColor: (achievementAddModel != null)
                    ? GlobalData.BACKGROUND_COLOR
                    : GlobalData.ACCENT_COLOR,
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeBlocProvider(
                      child: Home(),
                    ),
                  ),
                  (Route<dynamic> route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
