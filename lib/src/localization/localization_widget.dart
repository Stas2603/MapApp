import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

const _supportedLocales = [Locale('en')];

class LocalizationWidget extends StatelessWidget {
  const LocalizationWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: _supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: child,
    );
  }
}
