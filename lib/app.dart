import 'package:flutter/material.dart';
import 'package:mintness/splash/splash_page.dart';
import 'package:mintness/style.dart';
import 'package:mintness/widgets/dismiss_keyboard.dart';
import 'home/messenger/controllers/socket_controller.dart';


class App extends StatefulWidget {
  static final globalKey = GlobalKey<NavigatorState>();


  App( );

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) => SocketController(),
        child: DismissKeyboard(
            child: MaterialApp(
              title: 'Mintness',
              theme: ThemeData(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                canvasColor: Colors.transparent,
                useTextSelectionTheme: true,
                textSelectionTheme: TextSelectionThemeData(
                  selectionHandleColor: AppColor.primary,
                  cursorColor: AppColor.primary,
                ),
              ),
              builder: (BuildContext context, Widget child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child,
                );
              },
              navigatorKey: App.globalKey,
              debugShowCheckedModeBanner: false,
              home: SplashPage(),
            )
        )
    );
  }
}