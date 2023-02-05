import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_app/src/app_resources/locale_keys.g.dart';
import 'package:map_app/src/screens/profile_screen/profile_screen_cubit.dart';

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({Key? key}) : super(key: key);

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  String userName = '';
  String userEmail = '';
  String userAvatar = '';

  @override
  void initState() {
    super.initState();
    context.read<ProfileScreenCubit>().initParams();
    userName = context.read<ProfileScreenCubit>().state.userName;
    userEmail = context.read<ProfileScreenCubit>().state.userEmail;
    userAvatar = context.read<ProfileScreenCubit>().state.userAvatar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(LocaleKeys.profile.tr()),
        centerTitle: true,
      ),
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              _buildAvatar(),
              _buildTextWidget(userName, 40.0),
              _buildTextWidget(userEmail, 30.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextWidget(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        text,
        style: GoogleFonts.inter(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.network(
          userAvatar,
          height: 200,
          width: 150,
        ));
  }
}
