import 'dart:ui';
import 'package:flutter/material.dart';

import '../style.dart';


mixin FullscreenLoaderMixin<T extends StatefulWidget> on State<T> {

  bool _showLoader = false;
  bool get showLoader => _showLoader;
  set showLoader(bool value) => setState(() => _showLoader = value);

  Future runWithLoader(Function function) async {
    showLoader = true;
    try {
      final result = await function();
      showLoader = false;
      return result;
    } catch (exception, stackTrace) {
      showLoader = false;
      throw exception;
    }
  }
}

@immutable
class FullscreenLoader extends StatelessWidget {

  final bool showGrayBackground;

  const FullscreenLoader({this.showGrayBackground = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showGrayBackground)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(color: const Color.fromRGBO(0, 0, 0, 0.3)),
          ),
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
          ),
        ),
      ],
    );
  }
}
