import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/ui/widgets/btn_custom.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Mailing extends StatelessWidget {
  final email;

  Mailing({this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(12.0),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 4.0,
                    top: 5.0,
                    child: Icon(
                      FontAwesomeIcons.paperPlane,
                      color: GlobalData.ACCENT_COLOR,
                      size: 120,
                    ),
                  ),
                  Icon(
                    FontAwesomeIcons.paperPlane,
                    color: GlobalData.PRIMARY_COLOR,
                    size: 120,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(12.0),
              child: Text(
                'Kami sudah mengirimkan link verifikasi akun ke $email, Silahkan cek email anda',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GlobalData.TEXT_COLOR,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            BtnCustom(
              name: 'Kembali',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
