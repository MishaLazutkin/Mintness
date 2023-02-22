import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintness/auth/auth_page_email.dart';
import 'package:mintness/home/home_page.dart';
import 'package:mintness/providers/home_provider.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/repositories/local_storage.dart';
import 'package:mintness/services/flushbar_service.dart';
import 'package:mintness/services/internet_connection_service.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:provider/provider.dart';

@immutable
class SplashPage extends StatefulWidget {

  const SplashPage( );

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  Future<void> _init() async {
    await Future.wait([
      LocalStorage().init(),
      InternetConnectionService().init(
        onConnectedListener: () {
          FlushbarService().showMessage('Internet connection is restored.');
          // TODO: Reload data
        },
        onDisconnectedListener: () {
          FlushbarService().showError('Internet connection is lost.');
        },
      ),
    ]);

    if ((LocalStorage().accessToken == null)||(LocalStorage().refreshToken == null)) {
      NavigationService().pushReplacement(context, const AuthPageEmail());
    } else {
      await Future.wait([
          context.read<HomeProvider>().init(),
         context.read<ProfileProvider>().init(),
      ]);
      NavigationService().pushReplacement(context, const HomePage());

    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_init);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
              child: InkWell(
                  child: Container(
                    width: 200,
                    height: 100,
                    child:  SvgPicture.asset(
                      'lib/assets/icons/logoMark.svg',
                      color: Colors.white,
                    ),
                  )),
            ),));


  }
}
