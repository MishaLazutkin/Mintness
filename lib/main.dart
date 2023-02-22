
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mintness/providers/add_time_provider.dart';
import 'package:mintness/providers/auth_provider.dart';
import 'package:mintness/providers/comments_provider.dart';
import 'package:mintness/providers/create_task_provider.dart';
import 'package:mintness/providers/edit_task_provider.dart';
import 'package:mintness/providers/home_provider.dart';
import 'package:mintness/providers/messenger_provider.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/providers/project_provider.dart';
import 'package:mintness/providers/projects_provider.dart';
import 'package:mintness/providers/recent_task_provider.dart';
import 'package:mintness/providers/create_subtask_provider.dart';
import 'package:mintness/providers/reset_password_provider.dart';
import 'package:mintness/providers/task_provider.dart';
import 'package:mintness/providers/time_tracker_provider.dart';
import 'package:mintness/providers/update_subtask_provider.dart';
import 'package:mintness/providers/update_time_provider.dart';
import 'package:provider/provider.dart';
import 'app.dart';

Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);



  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => TaskProvider()),
      ChangeNotifierProvider(create: (_) => CommentsProvider()),
      ChangeNotifierProvider(create: (_) => ProjectsProvider()),
      ChangeNotifierProvider(create: (_) => RecentTaskProvider()),
      ChangeNotifierProvider(create: (_) => TimeTrackerProvider()),
      ChangeNotifierProvider(create: (_) => CreateTaskProvider()),
      ChangeNotifierProvider(create: (_) => AddTimeProvider()),
      ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ChangeNotifierProvider(create: (_) => UpdateTaskProvider()),
      ChangeNotifierProvider(create: (_) => MessengerProvider()),
      ChangeNotifierProvider(create: (_) => CreateSubtaskProvider()),
      ChangeNotifierProvider(create: (_) => UpdateSubtaskProvider()),
      ChangeNotifierProvider(create: (_) => UpdateTimeProvider()),
      ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
    ],
    child: App( ),
  ));
}

// for Android 7.0, because the is HandshakeException: Handshake error in client .
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}