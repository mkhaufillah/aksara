import 'package:aksara/src/blocs/app_bloc.dart';
import 'package:aksara/src/global_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    bloc.getHome();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: 'Aksara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: GlobalData.PRIMARY_COLOR,
        accentColor: GlobalData.ACCENT_COLOR,
        backgroundColor: GlobalData.BACKGROUND_COLOR,
        errorColor: GlobalData.ERROR_COLOR,
        brightness: Brightness.light,
        primaryColorBrightness: Brightness.light,
        accentColorBrightness: Brightness.light,
        fontFamily: 'Montserrat',
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: GlobalData.BACKGROUND_COLOR,
        ),
      ),
      home: Scaffold(
        body: StreamBuilder<Widget>(
          stream: bloc.home,
          builder: (context, snapshot) {
            if (snapshot.hasData) return snapshot.data;
            return Center(
              child: SpinKitHourGlass(
                color: GlobalData.TEXT_COLOR,
                size: 36.0,
              ),
            );
          },
        ),
      ),
    );
  }
}
