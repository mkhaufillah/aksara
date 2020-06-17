import 'package:aksara/src/blocs/update_bio_bloc_provider.dart';
import 'package:aksara/src/global_data.dart';
import 'package:aksara/src/models/user_model.dart';
import 'package:aksara/src/ui/widgets/app_bar_custom.dart';
import 'package:aksara/src/ui/widgets/btn_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UpdateBio extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdateBioState();
  }
}

class UpdateBioState extends State<UpdateBio> {
  UpdateBioBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = UpdateBioBlocProvider.of(context);
    bloc.fetchUser(context);
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
      appBar: PreferredSize(
        child: AppBarCustom(
          title: 'Edit Profile',
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<User>(
          stream: bloc.user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                margin: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    field(
                      bloc.name,
                      'Edit nama',
                      (snapshot.data.name == null)
                          ? 'Nama kosong'
                          : snapshot.data.name,
                      (String value) {
                        bloc.updateName(value);
                      },
                      isNum: false,
                    ),
                    field(
                      bloc.faculty,
                      'Edit fakultas',
                      (snapshot.data.faculty == null)
                          ? 'Fakultas kosong'
                          : snapshot.data.faculty,
                      (String value) {
                        bloc.updateFaculty(value);
                      },
                      isNum: false,
                    ),
                    field(
                      bloc.department,
                      'Edit jurusan',
                      (snapshot.data.department == null)
                          ? 'Jurusan kosong'
                          : snapshot.data.department,
                      (String value) {
                        bloc.updateDepartment(value);
                      },
                      isNum: false,
                    ),
                    field(
                      bloc.studyProgram,
                      'Edit program studi',
                      (snapshot.data.studyProgram == null)
                          ? 'Program studi kosong'
                          : snapshot.data.studyProgram,
                      (String value) {
                        bloc.updateStudyProgram(value);
                      },
                      isNum: false,
                    ),
                    field(
                      bloc.generation,
                      'Edit angkatan',
                      (snapshot.data.generation == null)
                          ? 'Angkatan kosong'
                          : '${snapshot.data.generation}',
                      (String value) {
                        bloc.updateGeneration(value);
                      },
                      isNum: true,
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
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget field(blocVal, hint, label, onChanged, {@required isNum}) {
    return Container(
      margin: EdgeInsets.all(12.0),
      child: TextField(
        keyboardType: (!isNum) ? TextInputType.text : TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: GlobalData.GREY_LIGHT_COLOR,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: GlobalData.GREY_LIGHT_COLOR),
          ),
          hintText: '$hint',
          labelText: '$label',
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget submitButton() {
    return BtnCustom(
      name: 'Perbarui Profile',
      onPressed: () => bloc.updateBio(context),
    );
  }
}
