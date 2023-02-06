import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:map_app/data/shared_preferances/app_preferances.dart';
import 'package:map_app/src/screens/main_screen/main_screen_state.dart';
import 'package:map_app/src/models/userInfo.dart' as app;

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit({
    required this.appPreferences,
    required this.googleSignInApi,
  }) : super(const MainScreenState());

  final AppPreferences appPreferences;
  final GoogleSignIn googleSignInApi;

  void initParams() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }
  }

  void onChangeLocation(String latitude, String longitude) async {
    final userId = appPreferences.getString('userId');
    try {
      DatabaseReference reference =
          FirebaseDatabase.instance.ref("users/$userId");
      reference.update({"latitude": latitude});
      reference.update({"longitude": longitude});
    } catch (e) {
      print(e);
    }
  }

  Future<app.UserInfo> onTakeSelectedUserInfo(String id) async {
    var selectedUserInfo = app.UserInfo(
      name: '',
      email: '',
      avatarUrl: '',
      latitude: '',
      longitude: '',
      markerColor: Colors.red.value,
    );
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('users/$id').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        selectedUserInfo = app.UserInfo(
          name: data['name'],
          email: data['email'],
          avatarUrl: data['avatarUrl'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          markerColor: data['markerColor'],
        );
      } else {
        print('No data available.');
      }
    } catch (e) {
      print(e);
    }
    return selectedUserInfo;
  }

  Future<void> onSignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await googleSignInApi.signOut();

      appPreferences.putString('userId', '');
    } catch (e) {
      print(e);
    }
  }
}
