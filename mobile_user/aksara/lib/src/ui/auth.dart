import 'package:aksara/src/blocs/auth_bloc_provider.dart';
import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/ui/widgets/btn_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Auth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthState();
  }
}

class AuthState extends State<Auth> {
  AuthBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = AuthBlocProvider.of(context);
    bloc.hasToken(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(12.0),
              child: StreamBuilder<int>(
                stream: bloc.state,
                builder: (context, snapshot) {
                  String title = 'Gabung';
                  if (snapshot.hasData) {
                    if (snapshot.data == 1)
                      title = 'Masuk';
                    else if (snapshot.data == 2) title = 'Daftar';
                  }
                  return Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 36,
                      color: GlobalData.TEXT_COLOR,
                    ),
                  );
                },
              ),
            ),
            emailField(),
            StreamBuilder<int>(
              stream: bloc.state,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == 1)
                    return passwordField('Masukkan password');
                  else if (snapshot.data == 2)
                    return passwordField('Buat password baru kamu');
                }
                return Container();
              },
            ),
            StreamBuilder<bool>(
              stream: bloc.isLoading,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data)
                    return SpinKitThreeBounce(
                      color: GlobalData.TEXT_COLOR,
                      size: 28.0,
                    );
                  else
                    return Container();
                }
                return Container();
              },
            ),
            submitButton(),
          ],
        ),
      ),
    );
  }

  Widget emailField() {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return Container(
          margin: EdgeInsets.all(12.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              filled: true,
              fillColor: GlobalData.GREY_LIGHT_COLOR,
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: GlobalData.GREY_LIGHT_COLOR),
              ),
              hintText: 'example@domain',
              labelText: 'Masukkan email',
              errorText: snapshot.error,
            ),
            onChanged: (String value) {
              bloc.updateEmail(value);
            },
          ),
        );
      },
    );
  }

  Widget passwordField(label) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return Container(
          margin: EdgeInsets.all(12.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: GlobalData.GREY_LIGHT_COLOR,
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: GlobalData.GREY_LIGHT_COLOR),
              ),
              hintText: '********',
              labelText: label,
              errorText: snapshot.error,
            ),
            onChanged: (String value) {
              bloc.updatePassword(value);
            },
          ),
        );
      },
    );
  }

  Widget submitButton() {
    return StreamBuilder<bool>(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return BtnCustom(
          name: 'Gabung Sekarang',
          onPressed: () => snapshot.hasData ? bloc.submit(context) : null,
        );
      },
    );
  }
}
