import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mintness/utils/cupertino_page_route.dart';
import 'package:mintness/utils/navigator_animations.dart';

import 'flushbar_service.dart';
import 'internet_connection_service.dart';


enum Direction {fromRight, fromLeft, fromBottom}

class NavigationService {
  static final NavigationService _singleton = NavigationService._internal();
  factory NavigationService() => _singleton;
  NavigationService._internal();

  RouteAnimationDirection _iosDirection(Direction direction) {
    switch (direction) {
      case Direction.fromRight: return RouteAnimationDirection.fromRight;
      case Direction.fromLeft: return RouteAnimationDirection.fromLeft;
      default: return RouteAnimationDirection.fromRight;
    }
  }

  AnimationDirection _androidDirection(Direction direction) {
    switch (direction) {
      case Direction.fromRight: return AnimationDirection.fromRight;
      case Direction.fromLeft: return AnimationDirection.fromLeft;
      case Direction.fromBottom: return AnimationDirection.vertical;
      default: return AnimationDirection.fromRight;
    }
  }

  bool _isOffline() {
    if (InternetConnectionService().isOffline) {
      FlushbarService().showError('Internet connection is lost.');
      return true;
    }
    return false;
  }

  Future<dynamic> push(
    BuildContext context,
    Direction direction,
    Widget page, {
    bool withoutAnimation = false,
  }) async {
    if (_isOffline()) return;
    if (withoutAnimation) {
      return await Navigator.push(context, EmptyAnimationRouter(builder: (_) => page));
    } else if (direction == Direction.fromBottom) {
      return await Navigator.push(
        context,
        AnimatedPageRoute(_androidDirection(direction), page),
      );
    } else if (Platform.isIOS) {
      return await Navigator.push(
        context,
        CupertinoPageRoute(direction: _iosDirection(direction), builder: (_) => page),
      );
    } else if (Platform.isAndroid) {
      return await Navigator.push(
        context,
        AnimatedPageRoute(_androidDirection(direction), page),
      );
    }
  }

  Future<void> pushReplacement(
    BuildContext context,
    Widget page,
  ) async {
    if (_isOffline()) return;
    await Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<void> pushAndRemoveUntil(
    BuildContext context,
    Widget page,
    RoutePredicate predicate,
  ) async {
    if (_isOffline()) return;
    await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      predicate,
    );
  }
}
