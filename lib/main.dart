import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:map_app/src/localization/localization_widget.dart';
import 'package:map_app/src/map_app.dart';
import '../service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  di.init();
  runApp(_buildWidgetTree());
}

Widget _buildWidgetTree() {
  return const LocalizationWidget(child: MapApp());
}
