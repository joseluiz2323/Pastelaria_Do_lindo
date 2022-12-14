import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pastelaria/utils/database.dart';

import 'app_widget.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Database.init();

  runApp(const AppWidget());
}
