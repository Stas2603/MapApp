import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:map_app/src/app_resources/locale_keys.g.dart';

class NavigationBarDrawer extends StatelessWidget {
  const NavigationBarDrawer({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => Drawer(
        child: Column(
          children: [
            _buildHeader(context),
            _buildMenuItem(context),
          ],
        ),
      );

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.account_box),
          title: Text(LocaleKeys.profile.tr()),
          onTap: () => Navigator.pushNamed(context, '/profile'),
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app_rounded),
          title: Text(LocaleKeys.signOut.tr()),
          onTap: onTap,
        )
      ],
    );
  }
}
