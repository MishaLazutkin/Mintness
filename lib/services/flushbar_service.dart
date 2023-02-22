import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mintness/packages/flushbar_1_10_4/flushbar.dart';


import '../app.dart';
import '../style.dart';

@immutable
class MessageEvent {
  final BuildContext context;
  final String message;
  final bool isError;

  const MessageEvent(this.context, this.message) : isError = false;

  const MessageEvent.error(this.context, this.message) : isError = true;
}

class FlushbarService {
  static final FlushbarService _singleton = FlushbarService._internal();
  factory FlushbarService() => _singleton;
  FlushbarService._internal();

  final _streamController = StreamController<MessageEvent>(sync: true)
    ..stream.listen((MessageEvent event) async {
      Flushbar(
        messageText: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(event.message, style: AppTextStyle.flushbar),
        ),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: event.isError
          ? AppColor.flushbarErrorBackground
          : AppColor.flushbarSuccessBackground,
        //backgroundColor: AppColor.white,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        borderRadius: 16,
        borderWidth: 1,
        borderColor: Colors.white,
        //boxShadows: AppShadow.flushbar,
        duration: const Duration(seconds: 3),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        icon: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: SizedBox(
            height: 32,
            width: 32,
            child: CircleAvatar(
              backgroundColor: event.isError
                  ? AppColor.flushbarErrorIcon
                : AppColor.flushbarSuccessIcon,
              radius: 16,
              child: event.isError
                ? SvgPicture.asset(
                    'lib/assets/icons/alert.svg',
                    color: Colors.white,
                    height: 12,
                  )
                : SvgPicture.asset(
                    'lib/assets/icons/checkmark.svg',
                    color: Colors.white,
                    width: 14,
                  ),
            ),
          ),
        ),
      )..show(event.context).then((result) {});
    });

  void showMessage(String message) {
    _streamController.add(
      MessageEvent(App.globalKey.currentState.context, message),
    );
  }

  void showError(String message) {
    _streamController.add(
      MessageEvent.error(App.globalKey.currentState.context, message),
    );
  }
}
