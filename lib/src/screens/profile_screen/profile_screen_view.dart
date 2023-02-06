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
  Color selectedColor = Colors.red;
  final colorsList = <Color>[
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.blue,
  ];

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
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: _buildTextWidget(LocaleKeys.selectColor.tr(), 30.0),
              ),
              _buildColorsList(),
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
          height: 100,
          width: 100,
        ));
  }

  Widget _buildColorsList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: colorsList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (context, index) {
          return _buildIconTile(index);
        },
      ),
    );
  }

  Widget _buildIconTile(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedColor = colorsList[index];
            context
                .read<ProfileScreenCubit>()
                .onSelectMarkerColor(colorsList[index]);
          });
        },
        child: Container(
          color: colorsList[index],
          child: _setIcon(
            colorsList[index],
          ),
        ),
      ),
    );
  }

  Icon _setIcon(Color widgetColor) {
    if (selectedColor == widgetColor) {
      return const Icon(Icons.check);
    } else {
      return const Icon(null);
    }
  }
}
