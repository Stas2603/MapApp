import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/data/shared_preferances/app_preferances.dart';
import 'package:map_app/src/screens/profile_screen/profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit({
    required this.appPreferences,
  }) : super(const ProfileScreenState());

  AppPreferences appPreferences;

  void initParams() {
    final userName = appPreferences.getString('userName');
    final userEmail = appPreferences.getString('userEmail');
    final userAvatar = appPreferences.getString('userAvatar');
    final markerColor = appPreferences.getString('markerColor');

    emit(
      state.copyWith(
        userAvatar: userAvatar,
        userEmail: userEmail,
        userName: userName,
        markerColor: Color(int.parse(markerColor!)),
      ),
    );
  }

  void onSelectMarkerColor(Color markerColor) {
    final userId = appPreferences.getString('userId');
    try {
      DatabaseReference reference =
          FirebaseDatabase.instance.ref("users/$userId");
      reference.update({"markerColor": markerColor.value});
      appPreferences.putString('markerColor', markerColor.value.toString());
    } catch (e) {
      print(e);
    }
  }
}
