import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:map_app/src/app_resources/locale_keys.g.dart';

Future<void> showInfoDialog({
  required BuildContext context,
  required String? avatar,
  required String? name,
  required String? email,
  required void Function()? onPressed,
  required void Function()? onCancel,
}) {
  final size = MediaQuery.of(context).size;
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(LocaleKeys.information.tr())),
          content: SizedBox(
            height: size.height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(avatar!),
                Text(name!),
                Text(email!),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: Text(LocaleKeys.ok.tr()),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: onPressed,
              child: Text(LocaleKeys.routeTo.tr()),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: onCancel,
              child: Text(LocaleKeys.cancelRouteTo.tr()),
            ),
          ],
        );
      });
}
